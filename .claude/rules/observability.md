---
paths:
  - "lib/core/observability/**"
---

# Logging / observability

All logging flows through one global Talker instance in
[app_logger.dart](../../lib/core/observability/app_logger.dart) — HTTP (`TalkerDioLogger`),
Riverpod (`TalkerRiverpodObserver` in `main.dart`), Flutter/platform errors
(`FlutterError.onError` + `PlatformDispatcher.onError` + `runZonedGuarded`), and
manual logs. It's a top-level global rather than provider-held because call sites
like `PagingControllerX` have no `Ref`.

Use the `AppLogger` static wrapper (`AppLogger.error/warning/handle`) at manual call
sites so swapping in a crash reporter is a one-file change. A separate `routeTalker`
prints go_router transitions to console only (`useHistory: false`) so they don't
crowd the shared timeline shown in `TalkerScreen` (`/logs`, debug builds only).

The three `talker*` packages are pinned to a patched fork — see [pubspec.md](pubspec.md).
