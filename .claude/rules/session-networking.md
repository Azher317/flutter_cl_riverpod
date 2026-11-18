---
paths:
  - "lib/core/session/**"
  - "lib/core/network/**"
  - "lib/main.dart"
---

# Session & networking

**Session is a core concern, not a feature.** `core/session/` owns the whole thing:
the state notifier `Session`
([session_notifier.dart](../../lib/core/session/session_notifier.dart), provider
`sessionProvider`, holding `AsyncValue<AuthSessionEntity?>`), the persistence
(`SessionRepository` over secure storage —
[session_repository.dart](../../lib/core/session/data/session_repository.dart)), and the
entities ([auth_session_entity.dart](../../lib/core/session/entities/auth_session_entity.dart),
[user_entity.dart](../../lib/core/session/entities/user_entity.dart)). No override, no
throwing session provider — it's self-contained core.

**Access is split so the token never leaks to features:**

- **Features read** the session through `currentUserProvider` (`UserEntity?`) and
  `isSignedInProvider` (`bool`), both in
  [session_notifier.dart](../../lib/core/session/session_notifier.dart). **No token.**
  These are the only session reads presentation ever makes.
- **Features write** only through `ref.read(sessionProvider.notifier)` —
  `setSession(...)` after login, `logout()`. Never `ref.watch`/`ref.read` of
  `sessionProvider` itself.
- **The network layer** reads the token straight from `sessionProvider`'s `AsyncValue`
  (`ref.read(sessionProvider).value?.token`) inside the Dio `Authenticator`
  ([authenticator.dart](../../lib/core/network/authenticator.dart)). `core/network` and
  `lib/router` (redirects) are the only readers of `sessionProvider`'s state.

Both read providers are `keepAlive` and derive from `sessionProvider` with `select`, so
they rebuild exactly when the user or signed-in flag changes — on login, logout and
cache restore. `isSignedInProvider` is `false` while the session restores; the router
watches `sessionProvider`'s raw `AsyncValue` for `isLoading` and holds on splash, so
screens never see that state. Any user-scoped provider watches `currentUserProvider`
(or is autoDispose) so it rebuilds/clears when the session drops to `null` — `logout()`
can't invalidate feature providers itself without `core/` importing features.

**A feature that authenticates produces a session and hands it over** — it does not own
session state. `auth`'s `LoginNotifier` calls `loginUseCase`, then
`ref.read(sessionProvider.notifier).setSession(entity)`. That's the only write path
besides `logout()`. Everything else is read-only through the two derived providers above.

**One provider throws until overridden — `sharedPreferencesProvider`.** Any test
touching `dioProvider`, `settingsProvider`, or anything downstream must supply that
override; the session providers don't need one (they resolve from core). Tests override
`sessionRepositoryProvider` with an in-memory fake to control the cached session.

**`@riverpod` is auto-dispose by default (Riverpod 3).** A plain `@riverpod` provider
resets its state the moment nothing listens — e.g. after you navigate off the screen
that was watching it. A provider whose state must outlive its last listener — session,
dio, storage, settings, any app-lifetime cache — needs `@Riverpod(keepAlive: true)`
(the reason `core/session/`, `dio_module`, both storages and settings all use it).
Feature notifiers and per-screen providers stay plain `@riverpod` unless their state
must survive navigation.

**`keepAlive` is the exception, not the default.** Allowed only for:
- app-lifetime services: Dio, storage, settings, session, push, the router;
- small caches the whole app reads and that are expensive to refetch (store config,
  lookups such as governorates), and only when they watch `currentUserIdProvider` (or
  `currentUserProvider`) if they are user-scoped, so logout clears them.

Never for screen data (lists, details, forms): those auto-dispose, and Riverpod refetches
them when the screen opens again. A kept-alive provider is never freed for the whole
process. If a screen must survive a short trip away, use `ref.keepAlive()` with a timer
inside the provider, not the annotation. Each `keepAlive: true` carries a one-line
comment saying which case above it is.

Dio is configured in [dio_module.dart](../../lib/core/network/dio_module.dart): base URL
from `ApiDocument`, an `Authenticator` interceptor attaching the bearer token, and a
401 interceptor that triggers **exactly one** logout across concurrent requests
(guarded by a `Completer`). Not a refresh-token flow — a 401 ends the session.
Debug builds add `TalkerDioLogger` with header/body redaction.

HTTP goes through the manual `ApiConsumer`/`DioConsumer` — **not** Retrofit. Data
sources call `_api.get/post/put/delete` and parse models themselves. Opt a call out
of the 401→logout with `extra: const {'skipAuthLogout': true}` (the login call).
Inject `apiConsumerProvider`; reach raw Dio via `ref.dio` only if you must.

[api_document.dart](../../lib/core/network/api_document.dart) still points at a demo API
— change it first in a new project.

## Push notifications

Push is plumbing in `core/push/` with no provider inside; an app plugs FCM or OneSignal
in through one adapter and one registrar ([docs/guides/push.md](../../docs/guides/push.md)). The token
follows the session (`PushController` watches `isSignedInProvider`), and taps open
through the router via `PushHost`. Never import a push package outside the adapter, and
never ask for the notification permission on launch.
