import 'dart:async';

import 'package:app/core/errors/failures.dart';
import 'package:app/core/session/data/session_repository.dart';
import 'package:app/core/session/entities/auth_session_entity.dart';
import 'package:app/core/session/session_notifier.dart';
import 'package:app/core/utils/either.dart';
import 'package:app/features/auth/di/auth_providers.dart';
import 'package:app/features/auth/presentation/notifiers/login_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fakes/auth_fakes.dart';

void main() {
  /// A container whose auth repository is [repo], with an empty session
  /// already restored.
  Future<ProviderContainer> containerWith(FakeAuthRepository repo) async {
    final container = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        sessionRepositoryProvider.overrideWithValue(FakeSessionRepository()),
      ],
    );
    await container.read(sessionProvider.future);
    return container;
  }

  /// Every state [loginProvider] goes through, from now on.
  List<AsyncValue<void>> recordStates(ProviderContainer container) {
    final states = <AsyncValue<void>>[];
    container.listen(loginProvider, (_, next) => states.add(next));
    return states;
  }

  test('success: loading, then data, and the session is set', () async {
    final gate = Completer<void>();
    final repo = FakeAuthRepository(
      const Right(testSession),
      delay: gate.future,
    );
    final container = await containerWith(repo);
    final states = recordStates(container);

    final done = container
        .read(loginProvider.notifier)
        .login(phone: '07701234567', password: 'secret1');

    expect(container.read(loginProvider).isLoading, isTrue);
    gate.complete();
    await done;

    expect(states.first, isA<AsyncLoading<void>>());
    expect(states.last, isA<AsyncData<void>>());
    expect(repo.calls.single.phone, '07701234567');
    expect(repo.calls.single.password, 'secret1');
    expect(container.read(sessionProvider).value, testSession);
    expect(container.read(isSignedInProvider), isTrue);
  });

  test('error: loading, then the Failure, and no session', () async {
    const failure = InvalidCredentialsFailure('wrong');
    final repo = FakeAuthRepository(
      const Left<Failure, AuthSessionEntity>(failure),
    );
    final container = await containerWith(repo);
    final states = recordStates(container);

    await container
        .read(loginProvider.notifier)
        .login(phone: '07701234567', password: 'secret1');

    expect(states.first, isA<AsyncLoading<void>>());
    expect(states.last, isA<AsyncError<void>>());
    expect(states.last.error, same(failure));
    expect(container.read(isSignedInProvider), isFalse);
  });
}
