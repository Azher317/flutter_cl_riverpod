import 'package:app/core/errors/failures.dart';
import 'package:app/core/session/entities/auth_session_entity.dart';
import 'package:app/core/utils/either.dart';
import 'package:app/features/auth/domain/params/login_params.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSessionEntity>> login(LoginParams params);
}
