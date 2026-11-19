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

# The backend's shape

How the backend wraps answers, errors and pages lives only in
[api_envelope.dart](../../lib/core/network/api_envelope.dart) (rule 19).
`ApiConsumer` already returns the unwrapped payload; a data source never reads
`data`/`message` wrappers itself. New backend: [new-backend.md](../../docs/guides/new-backend.md).

# Guests (rule 20)

A data source or provider for one user's data (their requests, profile,
notifications) makes **no call** for a guest: it watches `isSignedInProvider` and
returns empty when signed out. A screen built from several sections lets each
section fail on its own, so one failing call never blanks the whole screen.

# Fake data

**First ask the person: "Is the backend for this feature ready?"**

- **Ready:** write no fake data. If the feature has an old fake source, delete
  it, its draft in `docs/api/drafts/` and its line in `di/`.
- **Not ready:**
  1. Write the endpoint you expect in `docs/api/drafts/<feature>.md` (method,
     path, request, response with field names and types), and add a row for it
     to `docs/backend/REQUESTS.md` so the backend sees what the app expects.
  2. Build the fake source strictly from that draft, in
     `data/datasources/mock/<feature>_mock_data_source.dart`, implementing the
     same data-source interface. One line in the feature's `di/` picks fake or
     real; screens never know which.
  3. When the backend is ready: compare its docs with the draft, fix the models
     where they differ, switch the `di/` line to the real source, delete the
     mock file and the draft, run the tests.

`bin/build_release.sh` refuses to build while any `datasources/mock/` file
exists, so fake data never reaches a store.
