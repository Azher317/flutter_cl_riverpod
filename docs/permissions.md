# Permissions

**Opt-in.** The structure ships the flow (`ensurePermission`) and an interface
([lib/core/permissions/](../lib/core/permissions/)), but no plugin. Apps that never ask
for a permission carry nothing.

## Before adding any permission: ask the app owner

For **each** permission, an agent stops and asks Azher, in one question:

> "The <feature> needs <permission>. Should it be **optional** (the feature offers
> another way when refused, e.g. typing the code instead of scanning) or **required**
> (the feature can't work without it; refusing leaves only that feature unavailable)?"

Never decide this alone, and never default to required. The answer becomes the
`need:` argument (`PermissionNeed.optional` / `.required`).

Even **required** never forces the user: the OS prompt can always be refused, the rest
of the app keeps working, and the app never asks in a loop. Required only changes the
wording ("This feature needs access") and that the feature stays unavailable.

## Using it

```dart
final ok = await ensurePermission(
  context,
  ref,
  AppPermission.camera,
  reason: context.l10n.cameraReason, // why, in one sentence
  need: PermissionNeed.optional,     // what Azher decided
);
if (!context.mounted) return;
if (ok) {
  openScanner();
} else {
  showManualCodeField(); // optional: the other way. Required: a short note.
}
```

- Call it **when the user taps the feature**, never on app start or on a screen's
  first build.
- Give one `reason` string per permission (ARB, both languages): what it's for, in
  the user's terms.
- Never call the plugin directly; never re-ask after a "no" without a new tap.

## Setting it up in an app (once)

1. `flutter pub add permission_handler`
2. Add the adapter, e.g. `lib/core/permissions/permission_handler_service.dart`:

   ```dart
   import 'package:app/core/permissions/permission_service.dart';
   import 'package:permission_handler/permission_handler.dart' as ph;

   class PermissionHandlerService implements PermissionService {
     const PermissionHandlerService();

     static ph.Permission _map(AppPermission p) => switch (p) {
       AppPermission.camera => ph.Permission.camera,
       AppPermission.photos => ph.Permission.photos,
       AppPermission.microphone => ph.Permission.microphone,
       AppPermission.locationWhenInUse => ph.Permission.locationWhenInUse,
       AppPermission.locationAlways => ph.Permission.locationAlways,
       AppPermission.notifications => ph.Permission.notification,
     };

     static AppPermissionStatus _status(ph.PermissionStatus s) => switch (s) {
       // iOS partial access / quiet notifications still let the feature work.
       ph.PermissionStatus.granted ||
       ph.PermissionStatus.limited ||
       ph.PermissionStatus.provisional => AppPermissionStatus.granted,
       // Parental controls / MDM: the user can't change it from a prompt.
       ph.PermissionStatus.permanentlyDenied ||
       ph.PermissionStatus.restricted => AppPermissionStatus.permanentlyDenied,
       ph.PermissionStatus.denied => AppPermissionStatus.denied,
     };

     @override
     Future<AppPermissionStatus> status(AppPermission p) async =>
         _status(await _map(p).status);

     @override
     Future<AppPermissionStatus> request(AppPermission p) async =>
         _status(await _map(p).request());

     @override
     Future<bool> openSettings() => ph.openAppSettings();
   }
   ```

3. In `main.dart`, add to the `ProviderScope` overrides:
   `permissionServiceProvider.overrideWithValue(const PermissionHandlerService())`.
4. **iOS:** the plugin ships with every permission switched off. Switch on only the
   ones the app uses in `ios/Podfile`'s `post_install` (`'PERMISSION_CAMERA=1'`, …;
   the list is in the plugin's README), and add each one's usage sentence to
   `ios/Runner/Info.plist` (`NSCameraUsageDescription`, …). Apple can reject an app
   that declares permissions it doesn't use, or misses a sentence.
5. **Android:** add each `<uses-permission>` to `android/app/src/main/AndroidManifest.xml`.

Checked against `permission_handler` 13.0.2's README (iOS macros, statuses).
