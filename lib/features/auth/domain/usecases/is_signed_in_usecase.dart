import 'package:app/core/either.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/usecase/usecase.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';

class IsSignedInUseCase implements NoParamsUseCase<bool> {
  const IsSignedInUseCase(this._repository);

  final AuthRepository _repository;

  @override
  Future<Either<Failure, bool>> call() => _repository.isSignedIn();
}
