import 'dart:async';

import 'package:app/app.dart';
import 'package:app/core/observability/app_logger.dart';
import 'package:app/core/session/session_provider.dart';
import 'package:app/core/storage/shared_preferences_provider.dart';
import 'package:app/features/auth/presentation/notifiers/auth_session_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talker_riverpod_logger/talker_riverpod_logger.dart';
import 'package:timeago/timeago.dart' as timeago;

const String appName = 'Starter';

Future<void> main() async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

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
          observers: [
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
            sessionControllerProvider.overrideWith(
              (ref) => ref.watch(authSessionProvider.notifier),
            ),
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
