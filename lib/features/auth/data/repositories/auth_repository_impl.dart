import 'package:app/core/errors/exceptions.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/errors/safe_repository_call.dart';
import 'package:app/core/utils/either.dart';
import 'package:app/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:app/features/auth/data/models/authentication_model.dart';
import 'package:app/features/auth/domain/entities/auth_session_entity.dart';
import 'package:app/features/auth/domain/params/login_params.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl with SafeRepositoryCall implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, AuthSessionEntity>> login(LoginParams params) {
    return guard(() async {
      final user = await _remoteDataSource.login(params);
      final session = AuthenticationModel.fromUserModel(user);
      await _localDataSource.cacheSession(session);
      return session.toEntity();
    });
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _localDataSource.clearSession();
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, AuthSessionEntity?>> getCachedSession() async {
    try {
      final session = await _localDataSource.getCachedSession();
      return Right(session?.toEntity());
    } on CacheException {
      // A stale/corrupted cache isn't a user-facing failure — treat it as
      // "no session" rather than surfacing an error.
      return const Right(null);
    }
  }

  @override
  Future<Either<Failure, bool>> isSignedIn() async {
    final result = await getCachedSession();
    return result.fold(
      Left.new,
      (session) => Right(session != null),
    );
  }
}
