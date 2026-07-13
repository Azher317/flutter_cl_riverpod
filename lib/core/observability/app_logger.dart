import 'package:flutter/foundation.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Single Talker instance for the whole app — HTTP, Riverpod, framework
/// errors, and manual logs all flow through this one timeline.
///
/// Global rather than provider-held because some call sites (e.g.
/// [PagingControllerX]) have no [Ref] to read a provider from.
final talker = TalkerFlutter.init(
  settings: TalkerSettings(
    // Verbose/info logs are debug-only noise; error/critical stay on so
    // release crashes are still captured.
    enabled: true,
    useConsoleLogs: kDebugMode,
    useHistory: kDebugMode,
    maxHistoryItems: kDebugMode ? 1000 : 100,
  ),
  // Riverpod add/update/dispose/fail logs are noisy by default; start with
  // them off in the "Packages settings" sheet, toggle back on when needed.
  filter: TalkerFilter(
    disabledKeys: [
      TalkerKey.riverpodAdd,
      TalkerKey.riverpodUpdate,
      TalkerKey.riverpodDispose,
      TalkerKey.riverpodFail,
    ],
  ),
);

/// Route transitions are console-only: they print with the same Talker
/// formatting but never enter the shared history, so they don't crowd out
/// HTTP/error entries in the log viewer — [TalkerScreen] renders [talker]'s
/// history, not this one.
final routeTalker = TalkerFlutter.init(
  settings: TalkerSettings(
    enabled: kDebugMode,
    useConsoleLogs: kDebugMode,
    useHistory: false,
  ),
);

/// Thin wrapper around [talker] so manual call sites depend on this
/// interface rather than the Talker package directly — swapping in a crash
/// reporter later is then a one-file change.
abstract class AppLogger {
  const AppLogger._();

  static void warning(String message) => talker.warning(message);

  static void error(String message, [Object? error, StackTrace? stackTrace]) =>
      talker.error(message, error, stackTrace);

  static void handle(Object error, [StackTrace? stackTrace, String? message]) =>
      talker.handle(error, stackTrace, message);
}
