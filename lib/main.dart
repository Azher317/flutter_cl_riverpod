import 'dart:async';

import 'package:app/app.dart';
import 'package:app/core/network/api_document.dart';
import 'package:app/core/observability/app_logger.dart';
import 'package:app/core/storage/fresh_install_guard.dart';
import 'package:app/core/storage/secure_storage_provider.dart';
import 'package:app/core/storage/shared_preferences_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'package:timeago/timeago.dart' as timeago;

const String appName = 'Starter';

Future<void> main() async {
  // Every run names its server (env/*.json); stop here if this one didn't.
  ApiDocument.assertConfigured();

  // Flutter Driver's text-entry emulation hijacks the real text input
  // channel, silently breaking normal keyboard input — only enable it when
  // a driver/integration test run explicitly asks for it.
  const enableDriverExtension = bool.fromEnvironment(
    'ENABLE_FLUTTER_DRIVER_EXTENSION',
  );
  if (enableDriverExtension) {
    enableFlutterDriverExtension();
  }
  await runZonedGuarded(
    () async {
      final binding = WidgetsFlutterBinding.ensureInitialized();
      // Hold the native splash until SplashHost's first frame matches it
      // (SplashHost removes it).
      FlutterNativeSplash.preserve(widgetsBinding: binding);

      FlutterError.onError = (details) {
        talker.handle(details.exception, details.stack, 'FlutterError');
        FlutterError.presentError(details);
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        talker.handle(error, stack, 'Uncaught platform error');
        return true;
      };

      // Startup work that doesn't depend on each other runs together, so the
      // first frame waits for the slowest step, not the sum of all of them:
      //   final (prefs, _) = await (SharedPreferences.getInstance(),
      //       Firebase.initializeApp()).wait;
      // Keep only ordered steps sequential (e.g. a storage wipe before reads).
      final sharedPreferences = await SharedPreferences.getInstance();
      // Ordered: a reinstall must wipe the Keychain before the session is
      // restored from it.
      await FreshInstallGuard.run(sharedPreferences, createSecureStorage());

      timeago.setLocaleMessages(
        'ar',
        timeago.ArMessages(),
      ); // Arabic time labels

      runApp(
        ProviderScope(
          // Debug only: the observer runs on every provider event, which is
          // pure overhead in a release build.
          observers: [
            if (kDebugMode)
              TalkerRiverpodObserver(
                talker: talker,
                settings: const TalkerRiverpodLoggerSettings(
                  printProviderAdded: false,
                  printProviderUpdated: false,
                ),
              ),
          ],
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          ],
          child: const App(),
        ),
      );
    },
    (error, stack) {
      talker.handle(error, stack, 'Uncaught async error');
    },
  );
}
