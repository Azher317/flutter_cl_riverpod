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

**Access is split so the token never leaks to UI:**

- **UI** reads `SessionController`
  ([session_controller.dart](../../lib/core/session/session_controller.dart)) via
  `sessionControllerProvider` — `user`, `isSignedIn`, `logout()`. **No token.** This is
  the only session type presentation ever touches.
- **The network layer** reads the token straight from `sessionProvider`'s `AsyncValue`
  (`ref.read(sessionProvider).value?.token`) inside the Dio `Authenticator`
  ([authenticator.dart](../../lib/core/network/authenticator.dart)). `core/network` is
  allowed to see the token; presentation is not, because it never reads `sessionProvider`
  — only the router does (for redirects).

`sessionControllerProvider`
([session_provider.dart](../../lib/core/session/session_provider.dart)) delegates to the
`Session` notifier (which implements `SessionController`). The router watches
`sessionProvider`'s raw `AsyncValue` for `isLoading` vs signed-out.

**A feature that authenticates produces a session and hands it over** — it does not own
session state. `auth`'s `LoginNotifier` calls `loginUseCase`, then
`ref.read(sessionProvider.notifier).setSession(entity)`. That's the only write path
besides `logout()`. Everything else is read-only through the two interfaces above.

**One provider throws until overridden — `sharedPreferencesProvider`.** Any test
touching `dioProvider`, `settingsProvider`, or anything downstream must supply that
override; the session providers no longer need one (they resolve from core).

**`@riverpod` is auto-dispose by default (Riverpod 3).** A plain `@riverpod` provider
resets its state the moment nothing listens — e.g. after you navigate off the screen
that was watching it. A provider whose state must outlive its last listener — session,
dio, storage, settings, any app-lifetime cache — needs `@Riverpod(keepAlive: true)`
(the reason `core/session/`, `dio_module`, both storages and settings all use it).
Feature notifiers and per-screen providers stay plain `@riverpod` unless their state
must survive navigation.

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
