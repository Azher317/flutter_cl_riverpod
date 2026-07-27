---
name: flutter-setup-declarative-routing
description: Add or change a route in THIS project's go_router setup. Routing is already configured with session-driven redirect — use this to add screens/routes, NOT for first-time setup, and NEVER for imperative navigation after login/logout.
metadata:
  model: models/gemini-3.1-pro-preview
  last_modified: Tue, 21 Apr 2026 21:08:03 GMT
---
# Routing (this project)

> This project **already uses** `go_router` (`^16.0.0`, see
> [pubspec.yaml](../../../pubspec.yaml)). Do **not** run `flutter create` or re-scaffold
> `MaterialApp.router`. This skill is for **adding/changing routes** the project way.

## Ground truth (verify before editing)

- The router lives under [lib/router/](../../../lib/router/) and is the **only** place
  allowed to import `features/*` screens (CLAUDE.md rule 3).
- Route paths are named constants in
  [route_names.dart](../../../lib/core/utils/constants/route_names.dart) so that
  `core/` can reference a destination without importing the route table
  (rule 2). Add new paths there; don't inline string paths at call sites.
- Auth gating is a **`redirect`** driven by session state (`RouterRefreshNotifier` +
  `redirect`), not per-screen guards. See [.claude/rules/routing.md](../../rules/routing.md).

## Hard rule (CLAUDE.md rule 15)

**No imperative `context.go(...)` / `context.push(...)` after login or logout.**
Update the session (`ref.read(sessionProvider.notifier).setSession(...)` on login;
`logout()` via `sessionControllerProvider`), and the router **redirects on session
change** automatically. Imperative navigation here fights the redirect and creates
inconsistent stacks. Imperative `context.go`/`push` is fine for ordinary in-app
navigation between non-session-gated screens.

## Workflow: add a route

- [ ] 1. Add the path constant to
       [route_names.dart](../../../lib/core/utils/constants/route_names.dart).
- [ ] 2. Add the `GoRoute` (or nest it under the appropriate `ShellRoute` /
       `StatefulShellRoute`) in [lib/router/](../../../lib/router/), pointing `builder`
       at the feature screen. Only `lib/router/` may import that screen.
- [ ] 3. If the route must be reachable only when signed in / out, extend the existing
       `redirect` logic on the session — do **not** add a bespoke guard widget.
- [ ] 4. Navigate to it with `context.goNamed(...)` / `context.go(<RouteNames const>)`
       for normal transitions (subject to rule 15 above).
- [ ] 5. Verify: `flutter analyze` clean and `bin/check_arch.sh` passes (rules 1–3 are
       CI-enforced; a `core/ → router/` or feature→feature import will fail it).

## Nested navigation (shells)

`StatefulShellRoute.indexedStack` is the right tool for a persistent bottom-nav shell
that keeps each branch's state. Keep the shell scaffold generic (theme tokens, no
feature vocabulary — [.claude/rules/presentation.md](../../rules/presentation.md)) and
localize labels via `context.l10n.*` (rule 11), e.g.:

```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) =>
      ScaffoldWithNavBar(navigationShell: navigationShell),
  branches: [
    StatefulShellBranch(routes: [/* GoRoute(...) */]),
    StatefulShellBranch(routes: [/* GoRoute(...) */]),
  ],
);
```

## Deep linking

Native deep-link config (Android intent filters / `assetlinks.json`, iOS
`FlutterDeepLinkingEnabled` / associated domains / AASA) is platform setup, not Dart —
consult [bin/deep_link.sh](../../../bin/deep_link.sh) and the platform manifests before
changing anything. `go_router` already parses paths declaratively, so a new `GoRoute`
is automatically deep-linkable once the platform side allows the URL.
