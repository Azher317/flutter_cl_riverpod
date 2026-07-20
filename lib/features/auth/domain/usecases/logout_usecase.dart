import 'package:app/core/errors/failures.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/core/utils/either.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase implements NoParamsUseCase<void> {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, void>> call() => _repository.logout();
}
