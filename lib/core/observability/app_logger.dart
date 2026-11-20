import 'package:app/core/observability/console_printer.dart';
import 'package:app/core/observability/error_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// The one way the app logs.
///
/// Debug and UAT builds ([showDebugTools]) print one short line per entry to
/// the console; prod builds print nothing and keep nothing. Errors also go to
/// the [ErrorReporter], so a release build still reports them.
///
/// Only `lib/core/observability/` imports `package:logger`; everything else
/// logs through [AppLogger]. `bin/check_arch.sh` enforces it.
abstract final class AppLogger {
  static ErrorReporter _reporter = const NoopErrorReporter();

  static Logger _console = _defaultConsole();

  static Logger _defaultConsole() => Logger(
    filter: DebugToolsFilter(),
    printer: OneLinePrinter(),
    output: PlatformConsoleOutput(),
  );

  /// Installs the crash service adapter, once, in `main`.
  static void useReporter(ErrorReporter reporter) => _reporter = reporter;

  /// Tests only: send console lines to [output] instead of [debugPrint].
  @visibleForTesting
  static void useConsoleOutput(LogOutput? output) {
    _console = output == null
        ? _defaultConsole()
        : Logger(
            filter: DebugToolsFilter(),
            printer: OneLinePrinter(),
            output: output,
          );
  }

  static void info(String message) => _console.i(message);

  static void warning(String message) => _console.w(message);

  static void error(String message, [Object? error, StackTrace? stackTrace]) {
    _console.e(message, error: _loggable(error), stackTrace: stackTrace);
    _reporter.recordError(error ?? message, stackTrace, reason: message);
  }

  static void handle(Object error, [StackTrace? stackTrace, String? message]) {
    _console.e(
      message ?? error.toString(),
      error: message == null ? null : _loggable(error),
      stackTrace: stackTrace,
    );
    _reporter.recordError(error, stackTrace, reason: message);
  }

  /// A crash: an uncaught error, or a Flutter framework error.
  ///
  /// With [printedByFlutter] (framework errors in debug, which
  /// `FlutterError.presentError` already printed in Flutter's own format),
  /// nothing is printed again, so the error shows once.
  static void fatal(
    Object error,
    StackTrace? stackTrace,
    String reason, {
    bool printedByFlutter = false,
  }) {
    if (!printedByFlutter) {
      _console.f(reason, error: _loggable(error), stackTrace: stackTrace);
    }
    _reporter.recordError(error, stackTrace, reason: reason, fatal: true);
  }

  /// One HTTP call, from `NetworkLogger` only. [text] is the summary line,
  /// optionally followed by body lines.
  ///
  static void network(String text, {required bool failed}) => _console.log(
    failed ? Level.warning : Level.info,
    TaggedMessage('HTTP', text),
  );

  /// A screen change, from `RouteLogObserver` only.
  static void route(String text) => _console.i(TaggedMessage('ROUTE', text));

  /// `logger` refuses a [StackTrace] passed as the error.
  static Object? _loggable(Object? error) => error is StackTrace ? null : error;
}
