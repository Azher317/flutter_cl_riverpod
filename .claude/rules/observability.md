---
paths:
  - "lib/core/observability/**"
  - "lib/core/network/dio_module.dart"
  - "lib/core/network/network_logger.dart"
  - "lib/core/network/redact.dart"
  - "lib/router/route_log_observer.dart"
  - "lib/main.dart"
---

# Logging / observability

- **Log only through `AppLogger`** (`info`, `warning`, `error`, `handle`,
  `fatal`). Only `lib/core/observability/` imports `package:logger`;
  `bin/check_arch.sh` fails anywhere else. `AppLogger.network` and
  `AppLogger.route` are for `NetworkLogger` and `RouteLogObserver` only.
- **Console only.** There is no log screen and no log history. Debug and UAT
  builds ([`showDebugTools`](../../lib/core/config/debug_tools.dart)) print one
  short line per entry through `debugPrint`, so it shows in the `flutter run`
  terminal, the IDE console and logcat:

  ```text
  23:41:09 HTTP  POST /api/user/auth/login  200  66ms
  23:41:09 INFO  Signed in
  23:41:09 ROUTE Open /
  ```

  A prod release prints nothing and keeps nothing.
- **Colours:** only the tag and the HTTP status are painted. Status: 2xx/3xx
  green, 4xx red, 5xx orange, no response (timeout, offline) red. Tags: `ERROR`
  and `FATAL` red, `WARN` orange, `ROUTE` dim. `--dart-define=LOG_COLORS=false`
  turns them off (agents always do). Xcode's console and logcat show the raw
  codes.
- **HTTP bodies:** failed calls (4xx, 5xx, no response) print the request and
  response bodies under their line. `--dart-define=LOG_BODIES=true` prints them
  for every call; use it when an endpoint returns 200 with the wrong data.
  Bodies are cut at about 2,000 characters. Headers never print.
- **Masking:** every printed body and query goes through
  [redact.dart](../../lib/core/network/redact.dart). Add any new personal field
  (national id, address) to `hiddenBodyKeys`. It masks known keys only; it is
  not a security boundary.
- **Errors always reach the `ErrorReporter`** (`AppLogger.error`, `handle`,
  `fatal`), in every build. The base ships a no-op one; a project installs a
  crash service with `AppLogger.useReporter(...)` in `main`
  ([crash-reporting.md](../../docs/guides/crash-reporting.md)).
- **Framework errors print once:** in debug, `FlutterError.presentError` prints
  Flutter's own format and `AppLogger.fatal(printedByFlutter: true)` only reports
  it.
- Never log push payloads, tokens or personal data, even at `info`.
