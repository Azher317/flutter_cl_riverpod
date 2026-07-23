import 'package:app/core/errors/failures.dart';
import 'package:app/core/errors/safe_repository_call.dart';
import 'package:app/core/session/entities/auth_session_entity.dart';
import 'package:app/core/utils/either.dart';
import 'package:app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:app/features/auth/domain/params/login_params.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl with SafeRepositoryCall implements AuthRepository {
  const AuthRepositoryImpl({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<Either<Failure, AuthSessionEntity>> login(LoginParams params) {
    return guard(() async {
      final user = await _remoteDataSource.login(params);
      // The session is handed to the core `Session` notifier, which owns
      // persistence — the repository no longer caches it here.
      return AuthSessionEntity(token: user.token, user: user.toEntity());
    });
  }
}
