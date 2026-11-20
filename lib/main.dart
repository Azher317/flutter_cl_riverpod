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
        // Debug: Flutter prints it in its own format (widget path, links),
        // so AppLogger doesn't print it a second time; it still reaches the
        // ErrorReporter.
        if (kDebugMode) FlutterError.presentError(details);
        AppLogger.fatal(
          details.exception,
          details.stack,
          'FlutterError',
          printedByFlutter: kDebugMode,
        );
      };
      PlatformDispatcher.instance.onError = (error, stack) {
        AppLogger.fatal(error, stack, 'Uncaught platform error');
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
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          ],
          child: const App(),
        ),
      );
    },
    (error, stack) {
      AppLogger.fatal(error, stack, 'Uncaught async error');
    },
  );
}
