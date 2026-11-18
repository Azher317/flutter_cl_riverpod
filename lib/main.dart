import 'dart:async';

import 'package:app/app.dart';
import 'package:app/core/observability/app_logger.dart';
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

      final sharedPreferences = await SharedPreferences.getInstance();

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
