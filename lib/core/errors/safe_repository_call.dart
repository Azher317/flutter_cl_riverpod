import 'package:app/core/errors/exceptions.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/utils/either.dart';

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
    } on BadRequestException catch (e) {
      return Left(BadRequestFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ForbiddenException catch (e) {
      return Left(ForbiddenFailure(e.message));
    } on NotFoundException catch (e) {
      return Left(NotFoundFailure(e.message));
    } on ConflictException catch (e) {
      return Left(ConflictFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    } catch (e) {
      // Safety net: anything a data source lets escape that isn't one of the
      // app exceptions above (e.g. a `Model.fromJson` parse error) becomes a
      // ServerFailure rather than an uncaught error. Data sources should still
      // throw typed exceptions; this only prevents crashes.
      return Left(ServerFailure(e.toString()));
    }
  }
}
