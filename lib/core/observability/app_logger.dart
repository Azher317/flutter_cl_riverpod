import 'dart:developer' as developer;

import 'package:app/core/config/debug_tools.dart';
import 'package:app/core/observability/error_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Single Talker instance for the whole app: HTTP, framework errors and
/// manual logs all flow through this one timeline, which the logs screen
/// shows.
///
/// Debug and UAT builds ([showDebugTools]) print to the console and keep a
/// history; prod builds do neither, so nothing reaches logcat or memory.
/// Errors still reach the [ErrorReporter] in every build.
///
/// Only the logging wiring may use [talker] directly (this file, the Dio and
/// route observers, the logs screen). Everything else logs through
/// [AppLogger]; `bin/check_arch.sh` enforces it.
final talker = TalkerFlutter.init(
  // showDebugTools is true when analysed (debug), false in a prod build.
  // ignore: avoid_redundant_argument_values
  settings: TalkerSettings(
    // ignore: avoid_redundant_argument_values
    useConsoleLogs: showDebugTools,
    // ignore: avoid_redundant_argument_values
    useHistory: showDebugTools,
  ),
  logger: _CompactConsoleLogger(),
);

/// Route transitions are console-only: they print with the same formatting
/// but never enter the shared history, so they don't crowd out HTTP and
/// error entries in the logs screen.
final routeTalker = TalkerFlutter.init(
  settings: TalkerSettings(
    useHistory: false,
    // ignore: avoid_redundant_argument_values
    useConsoleLogs: showDebugTools,
  ),
  logger: _CompactConsoleLogger(),
);

/// Marks an entry that belongs in the logs screen but not the console
/// (framework errors, which Flutter already prints in its own format).
const _historyOnly = '[history-only]';

/// The console shows a short version of each entry; the logs screen keeps
/// the full one:
/// - response bodies are cut from the console (method, URL, status, time
///   stay); the logs screen still shows them;
/// - entries marked [_historyOnly] are not printed at all.
class _CompactConsoleLogger extends TalkerLogger {
  _CompactConsoleLogger()
    : super(settings: TalkerLoggerSettings(maxLineWidth: 60), output: _output);

  static void _output(String message) {
    if (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS) {
      // debugPrint cuts long lines on iOS; dart:developer doesn't.
      message.split('\n').forEach((line) => developer.log(line, name: 'app'));
    } else {
      debugPrint(message);
    }
  }

  @override
  void log(dynamic msg, {LogLevel? level, AnsiPen? pen}) {
    final text = msg?.toString() ?? '';
    if (text.contains(_historyOnly)) return;
    super.log(_dropResponseBody(text), level: level, pen: pen);
  }

  static String _dropResponseBody(String text) {
    if (!text.startsWith('[${TalkerKey.httpResponse}]')) return text;
    final i = text.indexOf('\nData: ');
    return i < 0 ? text : text.substring(0, i);
  }
}

/// The one way the app logs. Errors also go to the [ErrorReporter], so a
/// release build still reports them.
abstract final class AppLogger {
  static ErrorReporter _reporter = const NoopErrorReporter();

  /// Installs the crash service adapter, once, in `main`.
  static void useReporter(ErrorReporter reporter) => _reporter = reporter;

  static void info(String message) => talker.info(message);

  static void warning(String message) => talker.warning(message);

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    talker.error(message, error, stackTrace);
    _reporter.recordError(error ?? message, stackTrace, reason: message);
  }

  static void handle(Object error, [StackTrace? stackTrace, String? message]) {
    talker.handle(error, stackTrace, message);
    _reporter.recordError(error, stackTrace, reason: message);
  }

  /// A crash: an uncaught error, or a Flutter framework error.
  ///
  /// With [printedByFlutter] (framework errors in debug, which
  /// `FlutterError.presentError` already printed in Flutter's own format),
  /// the entry goes to the logs screen only, so it prints once.
  static void fatal(
    Object error,
    StackTrace? stackTrace,
    String reason, {
    bool printedByFlutter = false,
  }) {
    talker.handle(
      error,
      stackTrace,
      printedByFlutter ? '$_historyOnly $reason' : reason,
    );
    _reporter.recordError(error, stackTrace, reason: reason, fatal: true);
  }
}
