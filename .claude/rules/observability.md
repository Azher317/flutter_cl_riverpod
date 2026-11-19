---
paths:
  - "lib/core/observability/**"
  - "lib/core/network/dio_module.dart"
  - "lib/main.dart"
---

# Logging / observability

- **Log only through `AppLogger`** (`info`, `warning`, `error`, `handle`,
  `fatal`). Direct `talker.` calls are allowed only in `app_logger.dart`,
  `dio_module.dart` (the `TalkerDioLogger`) and `lib/router/` (route observer,
  logs screen). `bin/check_arch.sh` fails anywhere else.
- **`showDebugTools`** ([debug_tools.dart](../../lib/core/config/debug_tools.dart))
  is on in debug builds and in builds whose `API_ENV` is not `prod`. It turns on
  the console, the log history, the Dio logger, route logs and the logs screen.
  A prod release prints nothing to logcat and keeps no history.
- **Errors always reach the `ErrorReporter`** (`AppLogger.error`, `handle`,
  `fatal`), in every build. The base ships a no-op one; a project installs a
  crash service with `AppLogger.useReporter(...)` in `main`
  ([crash-reporting.md](../../docs/guides/crash-reporting.md)).
- **Framework errors print once:** in debug, `FlutterError.presentError` prints
  Flutter's own format and `AppLogger.fatal(printedByFlutter: true)` keeps a copy
  for the logs screen only.
- **Console is compact:** no headers; response bodies are cut from the console
  but stay in the logs screen. Add any new personal field (phone, email, national
  id) to `hiddenBodyKeys` in `dio_module.dart`.
- **Logs screen:** one `DebugLogsTile`, in the app's settings screen. Never a
  second entry point.
- Never log push payloads, tokens or personal data, even at `info`.

The `talker*` packages are pinned to a patched fork — see [pubspec.md](pubspec.md).
