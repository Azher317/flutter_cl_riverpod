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

## Page transitions

Every route uses `pageBuilder: (context, state) => appPage(context, state, const XScreen())`
([page_transitions.dart](../../lib/router/page_transitions.dart)): one fade-through on
Android and iOS, iOS swipe-back kept, bottom-sheet backdrop tilt supported, and the first
screen skips its entrance while the splash hands over. Never `builder:` (that falls back
to the platform default and the app animates differently per OS).

## Splash

`SplashHost` (app.dart builder) draws the splash over the app until the router leaves
`RouteNames.splash`, then fades out over the first screen. The splash route itself is
an empty `Scaffold`. Leaving splash is driven by the session (never a timer). Native splash
colours in `pubspec.yaml` must equal the theme's `surface`; rerun
`dart run flutter_native_splash:create` after changing them or the logo.

## Bottom navigation (opt-in)

Only for apps whose design has a bottom navigation bar. Replace the tab routes with a
`StatefulShellRoute` built by [AppShell](../../lib/router/app_shell.dart); each branch keeps
its own history. Pushed detail pages that should cover the bar use
`parentNavigatorKey: _rootNavigatorKey`.

```dart
StatefulShellRoute(
  pageBuilder: (context, state, shell) => appPage(context, state, shell),
  builder: (context, state, shell) => shell,
  navigatorContainerBuilder: (context, shell, children) => AppShell(
    shell: shell,
    children: children,
    destinations: [
      NavigationDestination(icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home), label: context.l10n.home),
      NavigationDestination(icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person), label: context.l10n.account),
    ],
  ),
  branches: [
    StatefulShellBranch(routes: [
      GoRoute(path: RouteNames.home,
          pageBuilder: (context, state) => appPage(context, state, const HomeScreen())),
    ]),
    StatefulShellBranch(routes: [
      GoRoute(path: RouteNames.account,
          pageBuilder: (context, state) => appPage(context, state, const AccountScreen())),
    ]),
  ],
),
```

An app without bottom navigation deletes `lib/router/app_shell.dart`.
