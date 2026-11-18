import 'dart:async';

import 'package:app/core/push/push_messaging.dart';
import 'package:app/core/push/push_providers.dart';
import 'package:app/core/session/session_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeMessaging implements PushMessaging {
  // Closed in the test's tearDown.
  // ignore: close_sinks
  final taps_ = StreamController<PushMessage>.broadcast();
  // ignore: close_sinks
  final refreshes = StreamController<String>.broadcast();
  PushMessage? launchTap;

  @override
  Future<void> init() async {}

  @override
  Future<String?> token() async => 'tok-1';

  @override
  Stream<String> get tokenRefreshes => refreshes.stream;

  @override
  Stream<PushMessage> get foreground => const Stream.empty();

  @override
  Stream<PushMessage> get taps => taps_.stream;

  @override
  Future<PushMessage?> initialTap() async => launchTap;

  @override
  String get platform => 'android';
}

class _FakeRegistrar implements PushTokenRegistrar {
  final log = <String>[];

  @override
  Future<void> register({
    required String token,
    required String platform,
  }) async => log.add('register $token $platform');

  @override
  Future<void> unregister({required String token}) async =>
      log.add('unregister $token');
}

class _SignedIn extends Notifier<bool> {
  _SignedIn(this._initial);

  final bool _initial;

  @override
  bool build() => _initial;

  void set(bool value) => state = value;
}

void main() {
  late _FakeMessaging messaging;
  late _FakeRegistrar registrar;

  ProviderContainer start({required bool signedIn}) {
    messaging = _FakeMessaging();
    registrar = _FakeRegistrar();
    final signedInState = NotifierProvider<_SignedIn, bool>(
      () => _SignedIn(signedIn),
    );
    final container = ProviderContainer(
      overrides: [
        pushMessagingProvider.overrideWithValue(messaging),
        pushTokenRegistrarProvider.overrideWithValue(registrar),
        isSignedInProvider.overrideWith((ref) => ref.watch(signedInState)),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(messaging.taps_.close);
    addTearDown(messaging.refreshes.close);
    container
      ..listen(pushControllerProvider, (_, _) {})
      ..listen(signedInState, (_, _) {});
    _signedIn = (v) => container.read(signedInState.notifier).set(v);
    return container;
  }

  Future<void> settle() => Future<void>.delayed(Duration.zero);

  test('signed in: the token goes to the backend on start', () async {
    start(signedIn: true);
    await settle();
    expect(registrar.log, ['register tok-1 android']);
  });

  test('signed out: no token is sent; sign-in sends it', () async {
    start(signedIn: false);
    await settle();
    expect(registrar.log, isEmpty);
    _signedIn(true);
    await settle();
    expect(registrar.log, ['register tok-1 android']);
  });

  test('sign-out withdraws the token', () async {
    start(signedIn: true);
    await settle();
    _signedIn(false);
    await settle();
    expect(registrar.log.last, 'unregister tok-1');
  });

  test('a tap queues its route until the router takes it', () async {
    final container = start(signedIn: true);
    await settle();
    messaging.taps_.add(const PushMessage(route: '/orders/42'));
    await settle();
    expect(container.read(pendingPushRouteProvider), '/orders/42');
    expect(
      container.read(pendingPushRouteProvider.notifier).take(),
      '/orders/42',
    );
    expect(container.read(pendingPushRouteProvider), isNull);
  });

  test('the default (no push) does nothing and never fails', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    container.listen(pushControllerProvider, (_, _) {});
    await settle();
    expect(container.read(pendingPushRouteProvider), isNull);
  });
}

late void Function(bool) _signedIn;
