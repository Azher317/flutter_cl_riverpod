/// Where errors go in release builds, so they are seen somewhere.
///
/// The base ships no crash service; a project picks one (Firebase
/// Crashlytics is the usual choice) and installs an adapter at startup with
/// `AppLogger.useReporter(...)`. See docs/guides/crash-reporting.md.
abstract interface class ErrorReporter {
  /// A caught or uncaught error. [fatal] marks crashes (framework and
  /// uncaught errors from `main`).
  void recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  });

  /// A breadcrumb attached to the next error report.
  void log(String message);
}

/// The default: reports nowhere.
final class NoopErrorReporter implements ErrorReporter {
  const NoopErrorReporter();

  @override
  void recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) {}

  @override
  void log(String message) {}
}
