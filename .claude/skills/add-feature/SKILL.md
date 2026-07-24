---
name: add-feature
description: Scaffold a new vertical slice (domain → data → di → presentation) using the clr-* snippet library. Use when adding a feature, entity, repository contract, usecase, model, datasource, provider wiring, notifier, or screen under lib/features/.
---

# Adding a feature

Ordered checklist. Placeholders are shown against their real `auth` counterparts.
`auth` is the **reference slice**: copy its *shape* — layer order, file naming, the
`Either` contract — never its symbols. No feature imports another; if the new feature
needs the session, inject `sessionControllerProvider` from `core/session/`.

| # | Step | File | Rule |
|---|---|---|---|
| 1 | **Entity** | `domain/entities/user_entity.dart` | Plain class. Hand-write `==`/`hashCode`/`toString`. No JSON, no Flutter. |
| 2 | **Repository contract** | `domain/repositories/auth_repository.dart` | `abstract class`; every method returns `Future<Either<Failure, T>>`. |
| 3 | **Params** | `domain/params/login_params.dart` | One plain class per multi-arg usecase. Skip for no-arg calls. |
| 4 | **Usecase** | `domain/usecases/login_usecase.dart` | `implements UseCase<AuthSessionEntity, LoginParams>` (or `NoParamsUseCase<T>`); single `call()` that delegates to the repo. One usecase per operation. |
| 5 | **Models** | `data/models/user_model.dart` | `@freezed abstract class Model with _$Model` (Freezed 3 requires `abstract`/`sealed`) + `@jsonSerializable` (from [annotations/](../../../lib/core/utils/annotations/)); add `const Model._();` so you can define `.toEntity()`. Request-only bodies use `@jsonSerializableRequest`. |
| 6 | **Remote datasource** | `data/datasources/auth_remote_data_source.dart` | `abstract class` + `Impl` taking `ApiConsumer`. Call `_api.post(Endpoints.x, data: ...)`, parse with `Model.fromJson`. **Dio-free.** Add an `on <AppException>` catch *only* when the endpoint reinterprets a status. |
| 7 | **Local datasource** (optional) | `data/datasources/auth_local_data_source.dart` | Secure storage for anything sensitive, `SharedPreferences` otherwise. Wrap failures in `CacheException`. |
| 8 | **Endpoint constant** | [endpoints.dart](../../../lib/core/network/endpoints.dart) | `static const String login = '/auth/login';` — paths live in one place. |
| 9 | **Repository impl** | `data/repositories/auth_repository_impl.dart` | `with SafeRepositoryCall implements AuthRepository`; every method body is `guard(() async {...})`. This is the *only* exception→failure translation. |
| 10 | **DI wiring** | `di/auth_providers.dart` | `@riverpod` functions: datasource → repository → one provider per usecase. `ref.watch(...)` the dependency. |
| 11 | **Notifier** | `presentation/notifiers/login_notifier.dart` | `@riverpod class XNotifier extends _$XNotifier`; `build()` returns the initial state; actions set `AsyncLoading` then `.fold()` into `AsyncError(failure, StackTrace.current)` / `AsyncData`. |
| 12 | **Screen** | `presentation/screens/login_screen.dart` | `ConsumerWidget`, or `HookConsumerWidget`/`StatefulHookConsumerWidget` if you need hooks. `ref.listen` the notifier and call `context.showFailure(failure)` on `AsyncError`. |
| 13 | **Route** | [route_names.dart](../../../lib/core/utils/constants/route_names.dart) + [app_router.dart](../../../lib/router/app_router.dart) | Add a `static const` path to `RouteNames`, then a `GoRoute` in `app_router.dart`. |
| 14 | **Strings** | `app_en.arb` + `app_ar.arb` | Add the key to **both**. Placeholders need an `@key` block. |
| 15 | **Codegen** | — | `flutter pub run build_runner build --delete-conflicting-outputs`. |

Provider naming is documented in [CLAUDE.md](../../CLAUDE.md) — the generator drops a
trailing `Notifier` from a class name.

**What `splash` legitimately skips.** It is presentation-only: no server call, no
persisted state, so there is no entity, contract, usecase, model, datasource,
repository, or `di/` folder to write.
[splash_screen.dart](../../../lib/features/splash/presentation/screens/splash_screen.dart) is a
bare spinner rendered while the session restores from cache. Skip steps 1–10 only when
the feature genuinely owns no data. The moment it reads or writes anything remote or
persisted, do the whole chain — don't call a datasource from a notifier.

---

## Snippets (VS Code)

The checklist above is fully covered by a snippet library in [.vscode/](../../../.vscode/).
**These snippets are the canonical way to scaffold boilerplate in this project** —
they are kept in sync with the `auth` reference slice, and every one of them has been
verified to pass `build_runner` + `flutter analyze`.

> **Instruction for any AI agent working in this repo.** When a piece of boilerplate
> you need matches a snippet below, **expand that snippet and fill in only its
> placeholders** — do not regenerate the surrounding code from scratch. Name the
> snippet you used by prefix (e.g. *"scaffolded from `clr-data-repo-impl`"*) and write
> out only the parts it leaves as placeholders: the type names, fields, method bodies.
> This is required, not optional: it cuts token usage substantially and keeps generated
> code byte-identical across features instead of drifting with each regeneration. Read
> the snippet body from the `.code-snippets` file when you need to know exactly what it
> produces.

### Files — one per layer, mirroring `lib/features/<feature>/`

| File | Covers |
|---|---|
| [domain.code-snippets](../../../.vscode/domain.code-snippets) | entity, repository contract, params, usecases |
| [data.code-snippets](../../../.vscode/data.code-snippets) | models, datasources, repository impl, API methods |
| [di.code-snippets](../../../.vscode/di.code-snippets) | `@riverpod` provider wiring |
| [presentation.code-snippets](../../../.vscode/presentation.code-snippets) | notifiers, screens, `AsyncValue` handling |
| [core.code-snippets](../../../.vscode/core.code-snippets) | exceptions, failures, endpoints, routes, providers |

### Conventions

Prefix is `clr-<layer>-<thing>`; typing `clr-` lists the whole library. All are
scoped to Dart.

**Type the first placeholder in `snake_case`.** Class names are derived from it by
VS Code's `/pascalcase` and `/camelcase` transforms, which split on `_` — so
`order_item` yields `OrderItem`, `orderItem`, and the `order_item` path segment from
a single entry. The exceptions are snippets that need no import path (entity, params,
exception, failure, and the fragment snippets); those take the identifier directly in
the case it is used. Each `description` states which.

Snippets emit full `package:app/...` imports — never relative, never a barrel. Line
wrapping is a best-effort guess (it depends on how long your names turn out); let
format-on-save settle it.

### Catalogue

| Prefix | Purpose | Layer |
|---|---|---|
| `clr-domain-entity` | Plain entity + hand-written `==`/`hashCode`/`toString` | domain |
| `clr-domain-repo` | `abstract` repository contract returning `Either` | domain |
| `clr-domain-params` | Params class for a multi-arg usecase | domain |
| `clr-domain-usecase` | `implements UseCase<T, Params>` | domain |
| `clr-domain-usecase-noparams` | `implements NoParamsUseCase<T>` | domain |
| `clr-data-model` | Freezed response model + `@jsonSerializable` + `.toEntity()` | data |
| `clr-data-model-request` | Send-only request body (`@freezedRequest`) | data |
| `clr-data-datasource-remote` | `abstract` + `Impl(ApiConsumer)` + in-file provider | data |
| `clr-data-datasource-local` | Secure-storage datasource + in-file provider | data |
| `clr-data-api-method` | One `_api.<verb>` + `Model.fromJson` method | data |
| `clr-data-api-method-paged` | Paged call returning `PaginatedResponse<T>` | data |
| `clr-data-repo-impl` | `with SafeRepositoryCall implements XRepository` | data |
| `clr-data-guard-method` | One `guard(() async {...})` method | data |
| `clr-di-providers` | Repository + first usecase provider | di |
| `clr-di-usecase` | One usecase provider | di |
| `clr-pres-notifier` | Action notifier: `AsyncLoading` → `.fold()` | presentation |
| `clr-pres-notifier-data` | Load-on-build notifier folding an `Either` | presentation |
| `clr-pres-screen` | `ConsumerWidget` + `AsyncValue.when` + empty/error states | presentation |
| `clr-pres-screen-form` | `FormBody` + `ref.listen` → `showFailure` + submit button | presentation |
| `clr-pres-screen-paged` | `usePagingControllerEither` + `defaultListDelegate` | presentation |
| `clr-pres-listen-failure` | The `ref.listen` → `context.showFailure(...)` block | presentation |
| `clr-pres-async-when` | The `AsyncValue.when` block | presentation |
| `clr-core-exception` | New `*Exception` for `exceptions.dart` | core |
| `clr-core-failure` | New `*Failure` for `failures.dart` | core |
| `clr-core-endpoint` | `Endpoints` path constant | core |
| `clr-core-route` | `GoRoute` entry for the router | core |
| `clr-core-provider` | Bare `@riverpod` function provider | core |

Two gotchas the snippets encode so you don't have to remember them: a request model
needs `@freezedRequest` (with a bare `@freezed`, Freezed only emits `toJson()` when a
`fromJson` factory exists, leaving a send-only body with no serializer), and adding a
`Failure` breaks two exhaustive switches — `guard()` and `localizeFailure()`.
