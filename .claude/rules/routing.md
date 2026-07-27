---
paths:
  - "lib/router/**"
---

# Routing

Single `routerProvider` (`go_router`) in [app_router.dart](../../lib/router/app_router.dart).
Redirects are driven by the core `sessionProvider`'s `AsyncValue`: `isLoading` → hold on
splash; `value == null` → force login; signed in → bounce off splash/login. The
debug-only `/logs` route (`TalkerScreen`) stays reachable while signed out.
`RouterRefreshNotifier` ([router_refresh_notifier.dart](../../lib/router/router_refresh_notifier.dart))
re-runs redirects when session state changes. Paths are constants on `RouteNames`
([route_names.dart](../../lib/core/utils/constants/route_names.dart)) — deliberately in
`core/`, not `router/`, so `core/` widgets can name a route without importing the route
table (CLAUDE.md rule 2).

Navigation after login is **declarative** — `LoginNotifier` updates the session and
the redirect does the rest. Don't push routes imperatively on auth state change.
