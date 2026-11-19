---
paths:
  - "lib/features/**"
  - "lib/shared/**"
---

# Feature layout and providers

Moved out of CLAUDE.md to keep it short. Scaffold a new slice with the
`add-feature` skill.

## Layout (`lib/features/<feature>/`)

- `domain/`: `entities/` (pure), `repositories/` (abstract), `usecases/`,
  `params/`. Usecases implement `UseCase<T, Params>` / `NoParamsUseCase<T>`
  ([usecase.dart](../../lib/core/usecase/usecase.dart)) and return
  `Future<Either<Failure, T>>`.
- `data/`: `models/` (Freezed + json_serializable, each with `.toEntity()`),
  `datasources/` (remote via `ApiConsumer`, local via secure storage;
  fake data only in `datasources/mock/`, see data-layer.md),
  `repositories/` (implement the domain contract `with SafeRepositoryCall`).
- `presentation/`: `screens/`, `notifiers/` (`@riverpod` notifiers holding
  `AsyncValue`), `widgets/` (private pieces of this feature's screens only;
  reusable widgets go to `core/widgets` or `lib/shared`).
- `di/`: `@riverpod` functions wiring datasource → repository → usecase.

## Provider naming (generator behaviour, easy to get wrong)

`@riverpod` on a function `authRepository` gives `authRepositoryProvider`. On a
class the generator drops a trailing `Notifier`: `class LoginNotifier` gives
`loginProvider`; `class Session` gives `sessionProvider`. Derive names from this
rule; don't open the `.g.dart` to check.

## Anti-patterns

| Don't | Why | Do instead |
|---|---|---|
| Add `dartz` / `fpdart` | The project has a local sealed `Either` | [either.dart](../../lib/core/utils/either.dart) |
| Reach into another feature's `data/`, `domain/` or notifiers | Couples slices that should stay deletable | Session via `currentUserProvider` / `isSignedInProvider`; shared business code in `lib/shared/` (rule 16) |
| Copy a widget from another feature | The next bug gets fixed in one copy only | Move it to `core/widgets` or `lib/shared` and use it from both (rule 17) |
