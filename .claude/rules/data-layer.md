---
paths:
  - "lib/features/*/data/**"
  - "lib/core/errors/**"
  - "lib/core/network/**"
---

# Error handling

There is a **local `Either`** ([either.dart](../../lib/core/utils/either.dart)) — this
project does **not** use `dartz`/`fpdart`. Errors are translated exactly twice, each
in one place:

1. **Transport → exception.** `DioConsumer`
   ([api_consumer.dart](../../lib/core/network/api_consumer.dart)) is the only place that
   catches `DioException`; it delegates to `NetworkErrorMapper.toException`
   ([network_error_mapper.dart](../../lib/core/errors/network_error_mapper.dart)), which
   classifies every transport error into a typed `*Exception`
   ([exceptions.dart](../../lib/core/errors/exceptions.dart)) — one per HTTP status the UI
   may branch on (400/401/403/404/409) plus `NetworkException`/`ServerException`.
   A data source adds an `on <AppException>` catch only when its endpoint
   *reinterprets* a status (auth's login turns 401 `UnauthorizedException` into
   `InvalidCredentialsException` —
   [auth_remote_data_source.dart](../../lib/features/auth/data/datasources/auth_remote_data_source.dart)).
2. **Exception → failure.** Repositories wrap calls in `guard(() async {...})` from
   the `SafeRepositoryCall` mixin
   ([safe_repository_call.dart](../../lib/core/errors/safe_repository_call.dart)), mapping
   each exception to its mirroring `Failure`
   ([failures.dart](../../lib/core/errors/failures.dart), `sealed`). A trailing bare
   `catch` collapses stray non-app errors (e.g. a `fromJson` parse error) to
   `ServerFailure`.
3. Notifiers `.fold()` into `AsyncData`/`AsyncError`.
4. Screens render through the **central presenter**: `context.showFailure(failure)`
   / `context.localizeFailure(failure)`
   ([failure_messenger.dart](../../lib/core/messaging/failure_messenger.dart)) — one
   localized `switch` over the sealed `Failure`, never re-written per screen.
   Exception messages carry only backend text (or empty); generic user-facing
   wording is localized here.

Adding a `Failure` breaks two exhaustive switches — `guard()` and `localizeFailure()`.
