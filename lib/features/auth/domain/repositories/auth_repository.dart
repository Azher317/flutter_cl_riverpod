import 'package:app/core/either.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/features/auth/domain/entities/auth_session_entity.dart';
import 'package:app/features/auth/domain/params/login_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSessionEntity>> login(LoginParams params);

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, AuthSessionEntity?>> getCachedSession();

  Future<Either<Failure, bool>> isSignedIn();
}
