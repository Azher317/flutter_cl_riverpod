# Crash reporting

The base ships no crash service. Errors go to `AppLogger`, which forwards
`error`, `handle` and `fatal` to an `ErrorReporter`
([error_reporter.dart](../../lib/core/observability/error_reporter.dart)). The
default reports nowhere. Add a real one before the first store release, so
release errors are seen somewhere.

Firebase Crashlytics is the usual choice (free for mobile apps). Steps checked
against [Firebase's Flutter guide](https://firebase.google.com/docs/crashlytics/flutter/get-started)
(page last updated 2026-11-18):

1. Add the packages:
   ```bash
   flutter pub add firebase_core firebase_crashlytics firebase_analytics
   ```
2. Run `flutterfire configure` from the project root. It writes
   `firebase_options.dart` and adds the Crashlytics Gradle plugin for Android.
3. Add the adapter, `lib/core/observability/crashlytics_reporter.dart`:
   ```dart
   import 'package:app/core/observability/error_reporter.dart';
   import 'package:firebase_crashlytics/firebase_crashlytics.dart';

   final class CrashlyticsReporter implements ErrorReporter {
     const CrashlyticsReporter();

     @override
     void recordError(
       Object error,
       StackTrace? stackTrace, {
       String? reason,
       bool fatal = false,
     }) => FirebaseCrashlytics.instance.recordError(
       error,
       stackTrace,
       reason: reason,
       fatal: fatal,
     );

     @override
     void log(String message) => FirebaseCrashlytics.instance.log(message);
   }
   ```
4. In `main.dart`, after `Firebase.initializeApp(...)` and before `runApp`:
   ```dart
   AppLogger.useReporter(const CrashlyticsReporter());
   ```
   `main.dart` already sends framework errors, platform errors and uncaught
   async errors through `AppLogger.fatal`, so nothing else changes.
5. Test it once: in a release build pointing at UAT, throw from a button, reopen
   the app, and check the Crashlytics console.

Keep personal data out of `reason` and `log` messages; they are uploaded.
