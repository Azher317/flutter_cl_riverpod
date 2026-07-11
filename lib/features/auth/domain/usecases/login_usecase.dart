import 'package:app/core/either.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/features/auth/domain/entities/auth_session_entity.dart';
import 'package:app/features/auth/domain/params/login_params.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, AuthSessionEntity>> call(LoginParams params) =>
      _repository.login(params);
}
