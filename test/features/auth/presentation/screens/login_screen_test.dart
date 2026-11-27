import 'dart:async';

import 'package:app/core/errors/failures.dart';
import 'package:app/core/session/data/session_repository.dart';
import 'package:app/core/session/entities/auth_session_entity.dart';
import 'package:app/core/session/session_notifier.dart';
import 'package:app/core/utils/either.dart';
import 'package:app/features/auth/di/auth_providers.dart';
import 'package:app/features/auth/presentation/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/pump_app.dart';
import '../../../../helpers/screen_sizes.dart';
import '../../fakes/auth_fakes.dart';

void main() {
  /// Pumps the login screen over [repo]; returns the container so a test can
  /// read the session.
  Future<ProviderContainer> pumpLogin(
    WidgetTester tester,
    FakeAuthRepository repo, {
    Locale locale = const Locale('ar'),
    Size? size,
  }) async {
    final container = ProviderContainer.test(
      overrides: [
        authRepositoryProvider.overrideWithValue(repo),
        sessionRepositoryProvider.overrideWithValue(FakeSessionRepository()),
      ],
    );
    // The app restores the session before login is reachable (the router
    // holds on splash until then); do the same here.
    await container.read(sessionProvider.future);
    await pumpApp(
      tester,
      UncontrolledProviderScope(
        container: container,
        child: const LoginScreen(),
      ),
      locale: locale,
      size: size,
      messenger: true,
    );
    return container;
  }

  Finder phoneField() => find.byType(TextField).at(0);
  Finder passwordField() => find.byType(TextField).at(1);

  Future<void> fillAndSubmit(WidgetTester tester) async {
    await tester.enterText(phoneField(), '07701234567');
    await tester.enterText(passwordField(), 'secret1');
    await tester.tap(find.byType(FilledButton));
    await tester.pump();
  }

  group('languages', () {
    testWidgets('Arabic (default): shows the Arabic login button', (
      tester,
    ) async {
      await pumpLogin(tester, FakeAuthRepository(const Right(testSession)));
      expect(find.text('تسجيل الدخول'), findsOneWidget);
    });

    testWidgets('English: shows the English login button', (tester) async {
      await pumpLogin(
        tester,
        FakeAuthRepository(const Right(testSession)),
        locale: const Locale('en'),
      );
      expect(find.text('Login'), findsOneWidget);
    });
  });

  testWidgets('submit with empty fields: shows the required message and '
      'does not call the server', (tester) async {
    final repo = FakeAuthRepository(const Right(testSession));
    await pumpLogin(tester, repo, locale: const Locale('en'));

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(find.text('The field is required'), findsWidgets);
    expect(repo.calls, isEmpty);
  });

  testWidgets('loading: the button shows a spinner and is disabled', (
    tester,
  ) async {
    final gate = Completer<void>();
    final repo = FakeAuthRepository(
      const Right(testSession),
      delay: gate.future,
    );
    await pumpLogin(tester, repo, locale: const Locale('en'));

    await fillAndSubmit(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Login'), findsNothing);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );

    gate.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('error: shows the localized failure, and submitting again '
      'retries', (tester) async {
    final repo = FakeAuthRepository(
      const Left<Failure, AuthSessionEntity>(
        InvalidCredentialsFailure('server text'),
      ),
    );
    final container = await pumpLogin(tester, repo, locale: const Locale('en'));

    await fillAndSubmit(tester);
    await tester.pumpAndSettle();

    expect(find.text('Invalid phone number or password'), findsOneWidget);
    expect(container.read(isSignedInProvider), isFalse);
    expect(find.text('Login'), findsOneWidget);

    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();
    expect(repo.calls, hasLength(2));
  });

  testWidgets('success: sends the typed phone and password and signs in', (
    tester,
  ) async {
    final repo = FakeAuthRepository(const Right(testSession));
    final container = await pumpLogin(tester, repo, locale: const Locale('en'));

    await fillAndSubmit(tester);
    await tester.pumpAndSettle();

    expect(repo.calls.single.phone, '07701234567');
    expect(repo.calls.single.password, 'secret1');
    expect(container.read(sessionProvider).value, testSession);
  });

  for (final locale in const [Locale('ar'), Locale('en')]) {
    testAtScreenSizes('no overflow (${locale.languageCode})', (
      tester,
      size,
    ) async {
      await pumpLogin(
        tester,
        FakeAuthRepository(const Right(testSession)),
        locale: locale,
        size: size,
      );
      expect(tester.takeException(), isNull);
    }, tablets: true);
  }
}
