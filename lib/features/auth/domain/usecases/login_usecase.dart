import 'package:app/core/errors/failures.dart';
import 'package:app/core/session/entities/auth_session_entity.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/core/utils/either.dart';
import 'package:app/features/auth/domain/params/login_params.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase implements UseCase<AuthSessionEntity, LoginParams> {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, AuthSessionEntity>> call(LoginParams params) =>
      _repository.login(params);
}
