# CLAUDE.md

The always-true invariants, one line each. The reasons and details load
automatically from [.claude/rules/](rules/) when a matching file is opened.
Commands: [COMMANDS.md](../COMMANDS.md). Shared widgets:
[docs/guides/widgets.md](../docs/guides/widgets.md). New backend:
[docs/guides/new-backend.md](../docs/guides/new-backend.md).

`auth` is shipped infrastructure (the sign-in that sets the session) and the
**reference slice**: copy its shape for a new feature, never its symbols. The
session itself is core (`core/session/`).

## Working rules

- Commit locally; push only when asked.
- No screenshots unless asked. Check UI with a widget test first; on a
  simulator take one small screenshot of the end state, no sleep loops, and run
  long device checks in a helper agent.
- One thread per task. `docs/PHASES.md` is the handover: a status table under 2 KB.
- Plan first only for work over ~3 files or any behaviour change. A plan lists
  the widgets it reuses, improves and adds (with why no existing one fits).
- Before building a screen that needs the server, ask whether its backend is
  ready ([data-layer.md](rules/data-layer.md), "Fake data").
- Reports go in chat, not new files. Edit code with the Edit tool; scripts only
  for mechanical multi-file renames.
- One agent writes in a checkout at a time. Spike branches are never merged;
  only what was learned moves over.
- Don't edit `docs/api/` (the backend contract) or `design/` unless asked.

## Layer rules

`bin/check_arch.sh` enforces the ones marked (checked); it runs on every commit
and in CI.

1. `lib/core/` never imports `features/` (checked).
2. `lib/core/` never imports `router/`; route paths live in `RouteNames` (checked).
3. No feature imports another (checked). Session: watch `currentUserProvider` /
   `isSignedInProvider`, change it via `sessionProvider.notifier`; only
   `core/network` and `lib/router` read `sessionProvider`'s state.
4. `domain/` imports only `core/errors`, `core/usecase`, `core/utils/either`,
   `core/session/entities` (the pure-Dart session and user) and its own
   `domain/`. No Flutter, Dio, Riverpod or models.
5. `package:dio` only under `core/network/` and the error mapper (checked).
6. Data sources return models and throw `*Exception`s; never `Either`, never UI.
7. Repositories return `Either<Failure, T>` and are the only callers of `guard()`.
8. `Failure`s are built only in `safe_repository_call.dart`.
9. Presentation never sees an `*Exception`; notifiers `.fold()` the `Either`.
10. Only `failure_messenger.dart` switches on `Failure`.
11. No user-visible string literal: `context.l10n.*`, in every ARB the app ships.
12. No hard-coded colours, fonts or text styles; spacing uses `Insets` (checked).
13. Never read or edit `*.g.dart`, `*.freezed.dart` or `lib/core/l10n/generated/`;
    searches skip them (`.ignore`). Change the source, re-run codegen.
14. Notifiers and screens go through a `@riverpod` usecase provider.
15. No `context.go(...)` after sign-in or sign-out; the router redirects on
    session change. Guest-mode apps use `ref.requireSignIn(context, then)`.
16. `lib/core/` is infrastructure; business code shared by 2+ features lives in
    `lib/shared/`, which imports only `core/` (checked).
17. Features use the shared widgets: no raw text field, date/time picker,
    dialog or bottom sheet, and no public `*Field`/`*Button`/`*Dialog`/
    `*Sheet`/`*Card` class inside `lib/features` (checked). If one almost fits,
    add a parameter to it; never a second widget for the same job.
18. Log only through `AppLogger`; haptics only through `AppHaptics` (checked).
19. The backend's response shape lives only in `core/network/api_envelope.dart`.
20. Data for a signed-in user is never requested for a guest.

## Builds

- Every run names its server: `flutter run --dart-define-from-file=env/uat.json`
  (the VS Code launch configs do it). No server named: the app stops at launch.
- Debugging an endpoint that returns wrong data: add
  `--dart-define=LOG_BODIES=true` and read the bodies in the console. Without
  it only failed calls (4xx, 5xx) print their bodies.
- Run the app through `bin/flutter_quiet.sh run ...` (the VS Code launch
  configs do it): it hides Android's own system log lines.
  `FLUTTER_ALL_LOGS=1` shows them.
- Release: `bin/build_release.sh prod appbundle` (or `ipa`). Needs
  `android/key.properties`; refuses a placeholder host and any fake data.
