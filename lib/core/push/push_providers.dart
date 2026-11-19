import 'dart:async';

import 'package:app/core/observability/app_logger.dart';
import 'package:app/core/push/push_messaging.dart';
import 'package:app/core/session/session_notifier.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'push_providers.g.dart';

// keepAlive: App-lifetime service: push.
@Riverpod(keepAlive: true)
PushMessaging pushMessaging(Ref ref) => const NoPushMessaging();

// keepAlive: App-lifetime service: push.
@Riverpod(keepAlive: true)
PushTokenRegistrar pushTokenRegistrar(Ref ref) => const NoPushTokenRegistrar();

/// Where a tapped notification wants to go, until the router can take it
/// (it waits while the splash is up). `PushHost` opens it and clears it.
// keepAlive: App-lifetime service: push.
@Riverpod(keepAlive: true)
class PendingPushRoute extends _$PendingPushRoute {
  @override
  String? build() => null;

  void open(String route) => state = route;

  String? take() {
    final route = state;
    state = null;
    return route;
  }
}

/// The push plumbing every app needs, whatever the provider:
///
/// - the device token goes to the backend while signed in (launch, sign-in,
///   token refresh) and is withdrawn right after sign-out;
/// - a tap (app open, in the background, or launched from closed) queues its
///   [PushMessage.route] for `PushHost`, which opens it once the splash is
///   gone.
///
/// Started by `PushHost`. With the default [NoPushMessaging] it does
/// nothing.
// keepAlive: App-lifetime service: push.
@Riverpod(keepAlive: true)
class PushController extends _$PushController {
  final _subs = <StreamSubscription<Object?>>[];
  String? _token;

  @override
  void build() {
    final messaging = ref.watch(pushMessagingProvider);
    ref.onDispose(() {
      for (final s in _subs) {
        unawaited(s.cancel());
      }
      _subs.clear();
    });
    ref.listen(isSignedInProvider, (was, now) {
      if (now) {
        unawaited(_register(messaging));
      } else if (was ?? false) {
        unawaited(_unregister());
      }
    });
    Future.microtask(() => _start(messaging));
  }

  Future<void> _start(PushMessaging messaging) async {
    try {
      await messaging.init();
      _subs
        ..add(
          messaging.tokenRefreshes.listen((t) {
            _token = t;
            unawaited(_send(messaging, t));
          }),
        )
        ..add(messaging.taps.listen(_tap));
      await _register(messaging);
      final initial = await messaging.initialTap();
      if (initial != null && ref.mounted) _tap(initial);
    } on Object catch (e, s) {
      AppLogger.handle(e, s, 'Push: start failed');
    }
  }

  Future<void> _register(PushMessaging messaging) async {
    try {
      final token = await messaging.token();
      if (token == null) return;
      _token = token;
      await _send(messaging, token);
    } on Object catch (e, s) {
      // e.g. no APNs token yet (simulator): the next launch tries again.
      AppLogger.handle(e, s, 'Push: no token');
    }
  }

  Future<void> _send(PushMessaging messaging, String token) async {
    if (!ref.mounted || !ref.read(isSignedInProvider)) return;
    try {
      await ref
          .read(pushTokenRegistrarProvider)
          .register(token: token, platform: messaging.platform);
    } on Object catch (e, s) {
      AppLogger.handle(e, s, 'Push: token not registered');
    }
  }

  Future<void> _unregister() async {
    final token = _token;
    if (token == null) return;
    try {
      await ref.read(pushTokenRegistrarProvider).unregister(token: token);
    } on Object catch (e, s) {
      AppLogger.handle(e, s, 'Push: token not withdrawn');
    }
  }

  void _tap(PushMessage message) {
    final route = message.route;
    if (route == null || !ref.mounted) return;
    ref.read(pendingPushRouteProvider.notifier).open(route);
  }
}
