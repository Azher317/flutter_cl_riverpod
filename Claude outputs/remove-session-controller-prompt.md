Plan, then implement, a refactor of the session API in this Flutter scaffold (Riverpod 3 + codegen). Read every file listed below before planning. This is a scaffold, not a full app: keep the change minimal and don't add features.

## Goal

Remove `SessionController` and `sessionControllerProvider`. Replace them with two reactive providers derived from `sessionProvider`: `currentUserProvider` and `isSignedInProvider`.

## Why (for your understanding only — do not write this history anywhere)

`sessionControllerProvider` watches `sessionProvider.notifier`. That notifier instance does not change when `state` changes, so anything watching it never rebuilds on login or logout. The interface also doesn't really hide the token, because `sessionProvider` is public. Derived providers built with `select` fix both problems.

## Code changes

1. **`lib/core/session/session_notifier.dart`**, the new home of the read API:
   - Remove `implements SessionController` and the SessionController import.
   - Remove the `user` and `isSignedIn` getters from `Session`. They are non-reactive snapshots and a trap. Keep `build()`, `setSession()` and `logout()`, without `@override` on `logout`.
   - In the same file, add:
     ```dart
     /// The signed-in user, or `null` when signed out or still restoring.
     /// Reactive: rebuilds on login/logout. Never exposes the token.
     @Riverpod(keepAlive: true)
     UserEntity? currentUser(Ref ref) =>
         ref.watch(sessionProvider.select((s) => s.value?.user));

     /// Whether a session exists. `false` while restoring from cache — the router
     /// holds on splash using `sessionProvider.isLoading`, so screens never see
     /// that ambiguous state.
     @Riverpod(keepAlive: true)
     bool isSignedIn(Ref ref) =>
         ref.watch(sessionProvider.select((s) => s.value != null));
     ```
   - Rewrite the doc comments on `Session` and inside `logout()` so they describe the current design:
     - Features read session data through `currentUserProvider` / `isSignedInProvider`.
     - Features write only through `sessionProvider.notifier` (`setSession`, `logout`).
     - Only `core/network` (the token) and `lib/router` (the redirect) read `sessionProvider`'s state.
     - Any user-scoped provider must watch `currentUserProvider`, or be autoDispose, so it clears on logout.
2. **Delete** `lib/core/session/session_controller.dart`, `lib/core/session/session_provider.dart` and its generated `session_provider.g.dart`.
3. **`lib/core/network/dio_module.dart`**: the 401 handler calls `ref.read(sessionProvider.notifier).logout()`. Fix the imports.
4. **`lib/features/home/presentation/screens/home_screen.dart`**: the logout button calls `ref.read(sessionProvider.notifier).logout()`. Fix the imports.
5. **`lib/core/network/authenticator.dart`**: update the doc comment. It must not mention `SessionController`.
6. Leave the router, `RouterRefreshNotifier` and `LoginNotifier` logic as they are. They already use `sessionProvider` correctly. Only touch their comments if they mention removed symbols.
7. Run `dart run build_runner build --delete-conflicting-outputs`.

## Tests

Add `test/core/session/session_providers_test.dart`. Use `ProviderContainer.test()` and override `sessionRepositoryProvider` with an in-memory fake `SessionRepository`. Cover these cases:

- Restoring from an empty cache gives `currentUserProvider == null` and `isSignedInProvider == false`.
- Restoring from a cached session exposes that user, and `isSignedIn` is true.
- **Regression:** with a listener (`container.listen`) on both providers, `setSession()` updates them to the user and `true`. Then `logout()` updates them to `null` and `false`. Assert that the listener fired each time.
- `logout()` calls the repository's `clear()`.

Follow the existing style in `test/core/errors/network_error_mapper_test.dart` and `.claude/skills/flutter-add-widget-test` where relevant.

## `.claude/` documentation

Update every mention so the docs read **as if this design had always been the design**. That means:

- No "previously", "replaced", "no longer", "now", "instead of the old…" or anything similar.
- No changelog notes.
- No comments in code about what was removed.
- Where an existing sentence in a file you touch already uses history phrasing about the session (for example "the session providers no longer need one" in `rules/session-networking.md`), rewrite it in present tense.

Files to update:

- `.claude/CLAUDE.md`: the intro line about cross-feature session access (~line 17), rule 3 (~lines 60–65), and the anti-pattern table row (~line 136). The new rule is:
  - Features read the session through `currentUserProvider` / `isSignedInProvider`.
  - Features change it only through `ref.read(sessionProvider.notifier)` (`setSession` / `logout`).
  - Features never read `sessionProvider`'s state, because that's where the token is. Only `core/network` (token) and `lib/router` (redirect) do.
  - User-scoped providers watch `currentUserProvider`.
- `.claude/rules/session-networking.md`: rewrite the "Access is split" section and the paragraph after it to match. Update file links; `session_controller.dart` and `session_provider.dart` no longer exist.
- `.claude/skills/add-feature/SKILL.md` (line ~11): a feature that needs the session watches `currentUserProvider` / `isSignedInProvider` and logs out via `sessionProvider.notifier`.
- `.claude/skills/flutter-setup-declarative-routing/SKILL.md` (~lines 28–29): logout via `ref.read(sessionProvider.notifier).logout()`.
- `.claude/agents/architecture-auditor.md`: add checks that flag:
  - (a) any file under `lib/features/` that reads `sessionProvider` state, meaning `ref.watch(sessionProvider)` / `ref.read(sessionProvider)` without `.notifier`, or any `.token` access;
  - (b) any user-scoped provider that doesn't watch `currentUserProvider` and isn't autoDispose;
  - (c) any watch of a `.notifier` used to derive reactive state.

  Match the file's existing format.
- Check `debug-investigator.md`, `test-runner.md`, the other rules/skills, `README.md` and `docs/`. Edit only if they mention the session API.

Don't touch `graphify-out/`, and leave the generated `.g.dart` files to build_runner.

## Done when

- `grep -rn "SessionController\|sessionControllerProvider\|session_controller\|session_provider.dart" lib test .claude README.md docs` returns nothing.
- `flutter analyze` is clean.
- `flutter test` passes, including the new tests.
- The final summary lists every changed file. I'll review before any commit; don't commit.
