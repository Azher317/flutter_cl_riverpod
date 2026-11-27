import 'package:app/core/errors/exceptions.dart';
import 'package:app/core/errors/failures.dart';
import 'package:app/core/session/entities/auth_session_entity.dart';
import 'package:app/core/session/entities/user_entity.dart';
import 'package:app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:app/features/auth/data/models/user_model.dart';
import 'package:app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:app/features/auth/domain/params/login_params.dart';
import 'package:flutter_test/flutter_test.dart';

/// A data source that returns [user] or throws [error].
class _FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  _FakeAuthRemoteDataSource({this.user, this.error});

  final UserModel? user;
  final Object? error;
  LoginParams? lastParams;

  @override
  Future<UserModel> login(LoginParams params) async {
    lastParams = params;
    if (error != null) throw error!;
    return user!;
  }
}

void main() {
  const params = LoginParams(phone: '07701234567', password: 'secret1');

  test('success: returns the session built from the user model', () async {
    final source = _FakeAuthRemoteDataSource(
      user: const UserModel(
        token: 'tok',
        phoneNumber: '07701234567',
        id: '7',
        fullName: 'Test User',
        role: 1,
        createdAt: '2026-01-01',
      ),
    );
    final repo = AuthRepositoryImpl(remoteDataSource: source);

    final result = await repo.login(params);

    expect(source.lastParams, same(params));
    expect(result.isRight, isTrue);
    final session = result.fold((_) => null, (s) => s)!;
    expect(
      session,
      const AuthSessionEntity(
        token: 'tok',
        user: UserEntity(
          id: '7',
          role: 1,
          name: 'Test User',
          phone: '07701234567',
          createdAt: '2026-01-01',
        ),
      ),
    );
  });

  // Every exception the data source can let through, and the Failure the
  // repository must turn it into (with the message carried over).
  final cases = <String, (Object, TypeMatcher<Failure>)>{
    'InvalidCredentialsException': (
      const InvalidCredentialsException('m'),
      isA<InvalidCredentialsFailure>(),
    ),
    'NetworkException': (const NetworkException('m'), isA<NetworkFailure>()),
    'BadRequestException': (
      const BadRequestException('m'),
      isA<BadRequestFailure>(),
    ),
    'UnauthorizedException': (
      const UnauthorizedException('m'),
      isA<UnauthorizedFailure>(),
    ),
    'ForbiddenException': (
      const ForbiddenException('m'),
      isA<ForbiddenFailure>(),
    ),
    'NotFoundException': (const NotFoundException('m'), isA<NotFoundFailure>()),
    'ConflictException': (const ConflictException('m'), isA<ConflictFailure>()),
    'ServerException': (const ServerException('m'), isA<ServerFailure>()),
    'CacheException': (const CacheException('m'), isA<CacheFailure>()),
  };

  for (final MapEntry(key: name, value: (error, matcher)) in cases.entries) {
    test('$name maps to its Failure', () async {
      final repo = AuthRepositoryImpl(
        remoteDataSource: _FakeAuthRemoteDataSource(error: error),
      );

      final result = await repo.login(params);

      final failure = result.fold((f) => f, (_) => null);
      expect(failure, matcher);
      expect(failure!.message, 'm');
    });
  }

  test('a non-app error (e.g. a parse error) -> ServerFailure', () async {
    final repo = AuthRepositoryImpl(
      remoteDataSource: _FakeAuthRemoteDataSource(
        error: const FormatException('bad json'),
      ),
    );

    final result = await repo.login(params);

    expect(result.fold((f) => f, (_) => null), isA<ServerFailure>());
  });
}
