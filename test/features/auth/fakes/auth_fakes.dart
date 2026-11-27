import 'package:app/core/errors/failures.dart';
import 'package:app/core/session/data/session_repository.dart';
import 'package:app/core/session/entities/auth_session_entity.dart';
import 'package:app/core/session/entities/user_entity.dart';
import 'package:app/core/utils/either.dart';
import 'package:app/features/auth/domain/params/login_params.dart';
import 'package:app/features/auth/domain/repositories/auth_repository.dart';

const testUser = UserEntity(
  id: '1',
  role: 0,
  name: 'Test User',
  phone: '07701234567',
  createdAt: '2026-01-01',
);

const testSession = AuthSessionEntity(token: 'secret-token', user: testUser);

/// An [AuthRepository] that answers with [result] (after [delay], if set)
/// and records the params it was called with.
class FakeAuthRepository implements AuthRepository {
  FakeAuthRepository(this.result, {this.delay});

  Either<Failure, AuthSessionEntity> result;
  final Future<void>? delay;
  final calls = <LoginParams>[];

  @override
  Future<Either<Failure, AuthSessionEntity>> login(LoginParams params) async {
    calls.add(params);
    if (delay != null) await delay;
    return result;
  }
}

/// In-memory [SessionRepository]: nothing touches secure storage.
class FakeSessionRepository implements SessionRepository {
  AuthSessionEntity? cached;

  @override
  Future<AuthSessionEntity?> read() async => cached;

  @override
  Future<void> persist(AuthSessionEntity session) async => cached = session;

  @override
  Future<void> clear() async => cached = null;
}
