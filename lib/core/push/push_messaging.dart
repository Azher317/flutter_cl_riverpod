/// One notification, as the app needs it. The provider adapter (FCM,
/// OneSignal…) builds it from the provider's payload.
class PushMessage {
  const PushMessage({
    this.title = '',
    this.body = '',
    this.route,
    this.data = const {},
  });

  final String title;
  final String body;

  /// The in-app path a tap opens (`/orders/42`), or `null` for none. Agree
  /// with the backend on one data key (e.g. `route`) and read it in the
  /// adapter; screens never parse payloads.
  final String? route;

  /// The raw data payload, for anything app-specific.
  final Map<String, Object?> data;
}

/// Everything the app needs from a push provider, behind one seam. The
/// structure ships [NoPushMessaging]; an app with notifications writes one
/// adapter (FCM or OneSignal, docs/push.md) and overrides
/// `pushMessagingProvider` in `main.dart`. Nothing outside the adapter
/// imports the provider's package.
abstract interface class PushMessaging {
  /// Starts the SDK (and, for FCM, how pushes show while the app is open).
  /// Called once, after the first frame. Never asks for the permission:
  /// that's `ensurePermission(AppPermission.notifications)` at a good moment.
  Future<void> init();

  /// This device's token or subscription id, once the provider has one.
  Future<String?> token();

  Stream<String> get tokenRefreshes;

  /// Notifications that arrive while the app is open (to refresh a badge or
  /// a list). Showing them is the adapter's job.
  Stream<PushMessage> get foreground;

  /// Taps on a notification while the app runs (background or foreground).
  Stream<PushMessage> get taps;

  /// The tap that launched the app from closed, if any.
  Future<PushMessage?> initialTap();

  /// `android` or `ios`, for the backend.
  String get platform;
}

/// The default: an app without notifications. Does nothing, never fails.
class NoPushMessaging implements PushMessaging {
  const NoPushMessaging();

  @override
  Future<void> init() async {}

  @override
  Future<String?> token() async => null;

  @override
  Stream<String> get tokenRefreshes => const Stream.empty();

  @override
  Stream<PushMessage> get foreground => const Stream.empty();

  @override
  Stream<PushMessage> get taps => const Stream.empty();

  @override
  Future<PushMessage?> initialTap() async => null;

  @override
  String get platform => '';
}

/// Tells the backend about this device's token. The structure ships
/// [NoPushTokenRegistrar]; an app with notifications implements it with its
/// endpoints (through `ApiConsumer`) and overrides
/// `pushTokenRegistrarProvider`.
abstract interface class PushTokenRegistrar {
  /// After sign-in, on every launch while signed in, and on token refresh.
  /// Idempotent on the server.
  Future<void> register({required String token, required String platform});

  /// Right after sign-out, so the previous user stops receiving pushes. The
  /// auth token is already gone: the endpoint must accept the device token
  /// alone (or the backend unlinks devices on logout itself).
  Future<void> unregister({required String token});
}

class NoPushTokenRegistrar implements PushTokenRegistrar {
  const NoPushTokenRegistrar();

  @override
  Future<void> register({
    required String token,
    required String platform,
  }) async {}

  @override
  Future<void> unregister({required String token}) async {}
}
