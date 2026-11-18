# Push notifications

The structure ships the plumbing, not a provider. Nothing here imports Firebase or
OneSignal; an app without notifications changes nothing.

| Piece | File | What it does |
|---|---|---|
| `PushMessaging` | [push_messaging.dart](../../lib/core/push/push_messaging.dart) | The seam to the provider: init, token, refreshes, taps, launch tap. Default `NoPushMessaging`. |
| `PushTokenRegistrar` | same | Tells your backend about the token. Default `NoPushTokenRegistrar`. |
| `PushController` | [push_providers.dart](../../lib/core/push/push_providers.dart) | Sends the token while signed in (launch, sign-in, refresh); withdraws it right after sign-out; queues a tapped notification's route. |
| `PushHost` | [push_host.dart](../../lib/core/push/push_host.dart) | In `app.dart`: starts the controller and opens the queued route through the router once the splash is gone. |

## Turning it on in an app

1. **Pick the provider** and add its package (`firebase_messaging` + Firebase setup,
   or `onesignal_flutter`). Follow the provider's own install guide for the Android and
   iOS project changes (APNs key, capabilities, `google-services.json`, …).
2. **Write the adapter** `lib/core/push/<provider>_push_messaging.dart`
   implementing `PushMessaging` (sketches below). It is the only file importing the
   provider's package. It maps the payload to `PushMessage(route: …)`: agree with the
   backend on one data key, e.g. `route: "/orders/42"`.
3. **Write the registrar** `lib/core/push/data/push_token_registrar_impl.dart` with
   your two endpoints through `ApiConsumer` (e.g. `PUT /devices` with
   `{token, platform}`, `DELETE /devices/{token}`). Unregister runs after sign-out, so
   that endpoint must work without the user's auth token, or the backend unlinks
   devices on logout itself.
4. **Override both** in `main.dart`'s `ProviderScope`:
   `pushMessagingProvider.overrideWithValue(FcmPushMessaging())`,
   `pushTokenRegistrarProvider.overrideWith((ref) => PushTokenRegistrarImpl(ref.watch(apiConsumerProvider)))`.
5. **Ask for the permission at a good moment** (after the user did something that makes
   notifications useful, e.g. placed an order), never on first launch:
   `ensurePermission(context, ref, AppPermission.notifications, reason: …)` — see
   [permissions.md](permissions.md) (and ask Azher: optional or required).

## Adapter sketches

These show the shape. **Check each call against the package version you install**;
plugin APIs change between majors.

**FCM** (`firebase_messaging`):

```dart
class FcmPushMessaging implements PushMessaging {
  final _fcm = FirebaseMessaging.instance;

  @override
  Future<void> init() async {
    // Foreground display: iOS via setForegroundNotificationPresentationOptions;
    // Android needs flutter_local_notifications to show onMessage pushes.
  }

  @override
  Future<String?> token() => _fcm.getToken();

  @override
  Stream<String> get tokenRefreshes => _fcm.onTokenRefresh;

  @override
  Stream<PushMessage> get foreground => FirebaseMessaging.onMessage.map(_map);

  @override
  Stream<PushMessage> get taps => FirebaseMessaging.onMessageOpenedApp.map(_map);

  @override
  Future<PushMessage?> initialTap() async =>
      switch (await _fcm.getInitialMessage()) { final m? => _map(m), null => null };

  @override
  String get platform => Platform.isIOS ? 'ios' : 'android';

  static PushMessage _map(RemoteMessage m) => PushMessage(
    title: m.notification?.title ?? '',
    body: m.notification?.body ?? '',
    route: m.data['route'] as String?,
    data: m.data,
  );
}
```

**OneSignal** (`onesignal_flutter`): `init()` calls `OneSignal.initialize(appId)`;
`token()` is the push subscription id; `taps` comes from the notification click
listener (`event.notification.additionalData?['route']`); `foreground` from the
foreground-display listener. OneSignal shows foreground notifications itself. A tap
that launched the app arrives through the same click listener, so `initialTap()` can
return `null`.

## Rules

- Screens never import a provider package or parse payloads; they get routes.
- A tap opens through the router (`PushHost`), so redirects (signed out → login) apply.
- Never request the notification permission inside `init()` or on launch.
