import 'package:app/core/either.dart';
import 'package:app/core/errors/exceptions.dart';
import 'package:app/core/errors/failures.dart';

/// Shared try/catch → [Failure] mapping so repositories don't hand-copy the
/// same exception-to-failure switch on every method.
mixin SafeRepositoryCall {
  Future<Either<Failure, T>> guard<T>(Future<T> Function() call) async {
    try {
      return Right(await call());
    } on InvalidCredentialsException catch (e) {
      return Left(InvalidCredentialsFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }
}
