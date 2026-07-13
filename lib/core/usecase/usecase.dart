import 'package:app/core/either.dart';
import 'package:app/core/errors/failures.dart';

/// A use case that takes [Params] and returns [T].
///
/// Matches this codebase's existing convention of a single positional
/// param (see `LoginUseCase`), rather than a named `{required Params params}`
/// call — adopted from akwaan_lib's `UseCase` contract but adapted so
/// existing call sites don't need to change.
abstract class UseCase<T, Params> {
  Future<Either<Failure, T>> call(Params params);
}

/// A use case that takes no params.
abstract class NoParamsUseCase<T> {
  Future<Either<Failure, T>> call();
}
