---
name: add-push
description: Turn on push notifications in an app (FCM or OneSignal). Only when the user calls it by name or asks to set up push.
disable-model-invocation: true
---

# Turn on push notifications

Follow `docs/guides/push.md` step by step; this is its checklist.

1. **Ask which provider:** Firebase Cloud Messaging or OneSignal.
2. **Add the package and native setup** the guide lists for that provider
   (Firebase: `flutterfire configure`; iOS: upload an APNs `.p8` key, which
   covers both development and production).
3. **Write the adapter** implementing `PushMessaging` (`lib/core/push/`), and the
   token registrar that sends the token to the backend.
4. **Override both providers in `main.dart`.**
5. **Choose when to ask permission.** Never at first launch and never forced
   (`.claude/rules/permissions.md`): ask when the user does something that
   needs notifications, with a short reason first.
6. **Never log a push payload or token**, not even in debug.
7. Run the `verify` skill, then test one real push on a device.
