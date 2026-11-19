import 'package:app/core/config/app_config.dart';
import 'package:app/core/session/data/session_repository.dart';
import 'package:app/core/session/entities/auth_session_entity.dart';
import 'package:app/core/session/entities/user_entity.dart';
import 'package:app/core/session/session_notifier.dart';
import 'package:app/core/session/sign_in_gate.dart';
import 'package:app/core/utils/constants/route_names.dart';
import 'package:app/router/redirect.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class _SignedOut implements SessionRepository {
  @override
  Future<AuthSessionEntity?> read() async => null;
  @override
  Future<void> persist(AuthSessionEntity session) async {}
  @override
  Future<void> clear() async {}
}

const _session = AuthSessionEntity(
  token: 't',
  user: UserEntity(
    id: '1',
    role: 0,
    name: 'n',
    phone: '07700000001',
    createdAt: '2026-01-01',
  ),
);

void main() {
  group('appRedirect', () {
    String? go(
      String loc, {
      bool restoring = false,
      bool signedIn = false,
      bool handBack = false,
      SignInMode mode = SignInMode.required,
    }) => appRedirect(
      location: loc,
      restoring: restoring,
      signedIn: signedIn,
      handBack: handBack,
      mode: mode,
    );

    test('restoring holds on the splash', () {
      expect(go(RouteNames.home, restoring: true), RouteNames.splash);
    });
    test('sign-in required: signed out goes to sign-in', () {
      expect(go(RouteNames.home), RouteNames.login);
      expect(go(RouteNames.login), isNull);
    });
    test('guest mode: signed out browses', () {
      expect(go(RouteNames.home, mode: SignInMode.guest), isNull);
      expect(go(RouteNames.splash, mode: SignInMode.guest), RouteNames.home);
    });
    test('signed in leaves sign-in, unless a hand-back is waiting', () {
      expect(go(RouteNames.login, signedIn: true), RouteNames.home);
      expect(go(RouteNames.login, signedIn: true, handBack: true), isNull);
    });
  });

  testWidgets('requireSignIn: the action runs on the same screen after '
      'sign-in, with what was typed still there', (tester) async {
    final draft = TextEditingController();
    String? sent;

    final routerProvider = Provider<GoRouter>((ref) {
      final router = GoRouter(
        initialLocation: '/form',
        routes: [
          GoRoute(
            path: '/form',
            builder: (_, _) => Consumer(
              builder: (context, ref, _) => Scaffold(
                body: Column(
                  children: [
                    TextField(controller: draft),
                    TextButton(
                      onPressed: () => ref.requireSignIn(
                        context,
                        () async => sent = draft.text,
                      ),
                      child: const Text('Send'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          GoRoute(
            path: RouteNames.login,
            builder: (_, _) => Consumer(
              builder: (context, ref, _) => Scaffold(
                body: TextButton(
                  onPressed: () =>
                      ref.read(sessionProvider.notifier).setSession(_session),
                  child: const Text('Sign in'),
                ),
              ),
            ),
          ),
        ],
      );
      listenForSignInHandBack(ref, router);
      return router;
    });

    await tester.pumpWidget(
      ProviderScope(
        overrides: [sessionRepositoryProvider.overrideWithValue(_SignedOut())],
        child: Consumer(
          builder: (context, ref, _) =>
              MaterialApp.router(routerConfig: ref.watch(routerProvider)),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'my complaint');
    await tester.tap(find.text('Send'));
    await tester.pumpAndSettle();
    expect(find.text('Sign in'), findsOneWidget);
    expect(sent, isNull);

    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    expect(find.text('Send'), findsOneWidget); // back on the form
    expect(sent, 'my complaint');
  });
}
