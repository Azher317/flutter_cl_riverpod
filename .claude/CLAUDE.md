# CLAUDE.md

Guidance for Claude Code (claude.ai/code) working in this repository.

This file holds the **always-true invariants**.

`auth` is **shipped infrastructure, not a sample** — the login slice that establishes a
session. The **session itself is a core concern** (`core/session/`, owns state + token +
`logout()`); the router redirect, the `Authenticator` interceptor and the 401→logout
handler depend on *that*, and `auth` merely feeds it via login (`setSession`). Edit auth's
UI and flow; don't delete it. `splash` is the spinner the router holds on while the
session restores from cache.

`auth` is also the **reference slice**: when scaffolding a new feature, copy its *shape*
— layer order, file naming, the `Either` contract — never its symbols. Copying the shape
is not importing the feature: no feature imports another. Cross-feature session access
goes through `sessionControllerProvider` (rule 3).

Layer detail lives in [.claude/rules/](rules/) — those files are path-scoped and load
automatically when a matching file is opened (`theming.md` for `lib/core/theme/**`,
`data-layer.md` for `lib/features/*/data/**`, `pubspec.md` for `pubspec.yaml`, and so on).
Scaffolding a new vertical slice is the **`add-feature` skill**: it carries the ordered
checklist and the `clr-*` snippet catalogue. The shared-widget catalogue lives in
[docs/widgets.md](../docs/widgets.md); general Dart/Flutter style defaults (additive,
never overriding the rules here) live in [docs/dart-style.md](../docs/dart-style.md).

## Commands

```bash
# Codegen — required after touching any @riverpod, @freezed, or .arb file
flutter pub run build_runner build --delete-conflicting-outputs   # or: bin/run.sh
flutter pub run build_runner watch  --delete-conflicting-outputs   # rebuild on save

# Lint — riverpod_lint runs via custom_lint (NOT the analyzer)
dart run custom_lint          # full lint incl. Riverpod rules; writes custom_lint.log (gitignored)
flutter analyze               # analyzer-only pass

# Assets — regenerate constants after adding/renaming/removing an image
dart run app:gen_assets

# Run
flutter run
```

---

## Layer rules

Hard invariants. Rules 1, 2, 3 and 5 are enforced in CI by
[bin/check_arch.sh](../bin/check_arch.sh) (run it locally before pushing).

1. **`lib/core/**` must not import `package:app/features/`.** If `core/` ever needs
   something a feature owns, invert it: an interface in `core/` + a throwing provider +
   an override at the composition root. *Currently holds.* (Session used to work this
   way; it now lives entirely in `core/session/`, so no override is needed.)
2. **`lib/core/**` should not import `package:app/router/`.** `router/` imports every
   feature screen, so a `core/ → router/` edge is rule 1 with an extra hop. Route paths
   live in [route_names.dart](../lib/core/utils/constants/route_names.dart) so `core/`
   can name a destination without importing the route table. *Currently holds.*
3. **No feature imports another feature.** Session state is read through
   `sessionControllerProvider` ([core/session/](../lib/core/session/)) — it exposes
   `user`, `isSignedIn` and `logout()` (the token is network-only — the Dio
   `Authenticator` reads it from `sessionProvider` directly; UI never sees it). Session
   is core, so no feature imports `auth` for it. Only
   `lib/router/` imports `features/*` at all, and only for the *screens* it composes.
   A feature may import its own files; only feature-A → feature-B is a violation
   (checked by [bin/check_arch.sh](../bin/check_arch.sh)).
4. **`domain/` imports nothing but `core/errors`, `core/usecase`, `core/utils/either`,
   and its own feature's `domain/`.** No Flutter, no Dio, no Riverpod, no `data/`
   models. Entities are plain Dart classes (see
   [user_entity.dart](../lib/core/session/entities/user_entity.dart), which is a shared
   identity type and therefore lives in `core/session/`, not in the `auth` feature).
5. **`package:dio/dio.dart` appears only under `lib/core/network/**` and
   [network_error_mapper.dart](../lib/core/errors/network_error_mapper.dart).**
   The only `on DioException` *catch* is in
   [api_consumer.dart](../lib/core/network/api_consumer.dart); other textual hits
   are doc comments.
6. **Data sources return *models*, throw typed `*Exception`s, and are Dio-free.**
   They never return `Either`, never build a `Failure`, never touch a widget.
7. **Repositories return `Either<Failure, T>` and are the only callers of `guard()`.**
   They map model → entity via `.toEntity()`.
8. **`Failure` subclasses are constructed only inside
   [safe_repository_call.dart](../lib/core/errors/safe_repository_call.dart).**
   (The core `SessionRepository` sits outside this `Either`/`guard()` world entirely:
   its reads/writes are best-effort and return plain values — a corrupt cache collapses
   to `null` (signed out), never a `Failure` —
   [session_repository.dart](../lib/core/session/data/session_repository.dart).)
9. **Presentation never sees an `*Exception`.** Notifiers `.fold()` an `Either` into
   `AsyncData`/`AsyncError`; screens only ever handle `Failure`.
10. **Only [failure_messenger.dart](../lib/core/messaging/failure_messenger.dart)
    switches on `Failure`.** Screens call `context.showFailure(f)` /
    `context.localizeFailure(f)`.
11. **No user-visible string literal in a widget.** Everything goes through
    `context.l10n.*`, added to `app_en.arb` *and* `app_ar.arb`.
12. **No hardcoded colours, fonts, or text styles in a widget.** Read
    `context.colorScheme.*`, `context.textTheme.*`, `context.appStatusColors`.
13. **Never read or edit `*.g.dart` / `*.freezed.dart`.** They're generated,
    analyzer-excluded, and machine-owned. To change their output, edit the
    annotation on the source class and re-run build_runner — hand-edits are
    overwritten on the next build. Derive provider names from the naming rule
    below; don't open the `.g.dart` to check. Exclude them from searches:
    `--glob '!*.{g,freezed}.dart'`. They're tracked, not gitignored, so an
    unfiltered `grep` under `lib/` is mostly generated hits.
14. **Notifiers and screens go through a `@riverpod` usecase provider** — never call a
    datasource or repository directly. That seam is where the `Either` contract lives.
15. **No imperative `context.go(...)` after login/logout.** Update the session; the
    router redirects on session change (`RouterRefreshNotifier` + `redirect`).

### Feature layout (`lib/features/<feature>/`)
- `domain/` — `entities/` (pure), `repositories/` (abstract), `usecases/`, `params/`.
  Usecases implement `UseCase<T, Params>` / `NoParamsUseCase<T>` from
  [usecase.dart](../lib/core/usecase/usecase.dart), returning `Future<Either<Failure, T>>`.
- `data/` — `models/` (Freezed + json_serializable, each with `.toEntity()`),
  `datasources/` (remote via `ApiConsumer`, local via secure storage),
  `repositories/` (impl of the domain contract, `with SafeRepositoryCall`).
- `presentation/` — `screens/`, `notifiers/` (`@riverpod` notifiers holding `AsyncValue`),
  and `widgets/` (feature-specific widgets only).
- `di/` — `@riverpod` provider functions wiring datasource → repository → usecase.

**Provider naming (generator behaviour, easy to get wrong):** `@riverpod` on a
*function* `authRepository` → `authRepositoryProvider`. On a *class*, the generator
drops a trailing `Notifier`: `class LoginNotifier` →
[`loginProvider`](../lib/features/auth/presentation/notifiers/login_notifier.dart), while
a class with no `Notifier` suffix keeps its name — `class Session` →
[`sessionProvider`](../lib/core/session/session_notifier.dart).

---

## Anti-patterns

These are the ones the numbered rules above don't already cover.

| Don't | Why | Do instead |
|---|---|---|
| Add `dartz` / `fpdart` | The project has a local sealed `Either` with `fold`/`isLeft`/`isRight` | Import [either.dart](../lib/core/utils/either.dart) |
| Reach into another feature's `data/`, `domain/` or notifiers | Couples two slices that should stay independently deletable | Session → `ref.read(sessionControllerProvider)` (UI only; **no token**). Never read `sessionProvider` from a feature — only `core/network` (token) and the router (redirect) may. Anything else → duplicate the small piece, or promote it to `core/` behind an interface |

---

## graphify

This project has a knowledge graph at graphify-out/ with god nodes, community structure, and cross-file relationships.

Rules:
- For codebase questions, first run `graphify query "<question>"` when graphify-out/graph.json exists. Use `graphify path "<A>" "<B>"` for relationships and `graphify explain "<concept>"` for focused concepts. These return a scoped subgraph, usually much smaller than GRAPH_REPORT.md or raw grep output.
- If graphify-out/wiki/index.md exists, use it for broad navigation instead of raw source browsing.
- Read graphify-out/GRAPH_REPORT.md only for broad architecture review or when query/path/explain do not surface enough context.
- After modifying code, run `graphify update .` to keep the graph current (AST-only, no API cost).

---

## Notes

- Helper scripts live in [bin/](../bin/): `run.sh` (build_runner), `gen_assets.dart`,
  `rename.sh`, `deep_link.sh`, `export.sh`, `uninstall.sh`.
