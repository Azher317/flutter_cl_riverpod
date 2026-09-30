import 'package:app/core/session/data/session_repository.dart';
import 'package:app/core/session/entities/auth_session_entity.dart';
import 'package:app/core/session/entities/user_entity.dart';
import 'package:app/core/session/session_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// In-memory [SessionRepository] that records calls instead of touching
/// secure storage.
class _FakeSessionRepository implements SessionRepository {
  _FakeSessionRepository([this.cached]);

  AuthSessionEntity? cached;
  int clearCalls = 0;

  @override
  Future<AuthSessionEntity?> read() async => cached;

  @override
  Future<void> persist(AuthSessionEntity session) async => cached = session;

  @override
  Future<void> clear() async {
    clearCalls++;
    cached = null;
  }
}

void main() {
  const user = UserEntity(
    id: '1',
    role: 0,
    name: 'Test User',
    phone: '0500000000',
    createdAt: '2026-01-01',
  );
  const session = AuthSessionEntity(token: 'secret-token', user: user);

  /// A container over [repo], with the session already restored from cache.
  Future<ProviderContainer> restored(_FakeSessionRepository repo) async {
    final container = ProviderContainer.test(
      overrides: [sessionRepositoryProvider.overrideWithValue(repo)],
    );
    await container.read(sessionProvider.future);
    return container;
  }

  group('session read providers', () {
    test('empty cache -> no user, signed out', () async {
      final container = await restored(_FakeSessionRepository());

      expect(container.read(currentUserProvider), isNull);
      expect(container.read(isSignedInProvider), isFalse);
    });

    test('cached session -> exposes its user, signed in', () async {
      final container = await restored(_FakeSessionRepository(session));

      expect(container.read(currentUserProvider), user);
      expect(container.read(isSignedInProvider), isTrue);
    });

    test('listeners fire on setSession and logout', () async {
      final container = await restored(_FakeSessionRepository());

      final users = <UserEntity?>[];
      final signedIn = <bool>[];
      container
        ..listen(currentUserProvider, (_, next) => users.add(next))
        ..listen(isSignedInProvider, (_, next) => signedIn.add(next));

      container.read(sessionProvider.notifier).setSession(session);
      await container.pump();

      expect(users, [user]);
      expect(signedIn, [true]);

      await container.read(sessionProvider.notifier).logout();
      await container.pump();

      expect(users, [user, null]);
      expect(signedIn, [true, false]);
    });

    test('logout clears the repository', () async {
      final repo = _FakeSessionRepository(session);
      final container = await restored(repo);

      await container.read(sessionProvider.notifier).logout();

      expect(repo.clearCalls, 1);
      expect(repo.cached, isNull);
    });
  });
}
