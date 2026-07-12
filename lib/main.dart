import 'dart:async';
import 'dart:developer' as developer;

import 'package:app/app.dart';
import 'package:app/core/observability/app_provider_observer.dart';
import 'package:app/core/session/session_provider.dart';
import 'package:app/features/auth/presentation/notifiers/auth_session_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/storage/shared_preferences_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

const String appName = 'Azher';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) {
      developer.log(
        'FlutterError',
        name: 'main',
        error: details.exception,
        stackTrace: details.stack,
        level: 1000,
      );
      FlutterError.presentError(details);
    };
    PlatformDispatcher.instance.onError = (error, stack) {
      developer.log(
        'Uncaught platform error',
        name: 'main',
        error: error,
        stackTrace: stack,
        level: 1000,
      );
      return true;
    };

    final sharedPreferences = await SharedPreferences.getInstance();

    timeago.setLocaleMessages(
      'ar',
      timeago.ArMessages(),
    ); // Arabic time labels

    runApp(
      ProviderScope(
        observers: [AppProviderObserver()],
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
          sessionControllerProvider.overrideWith(
            (ref) => ref.watch(authSessionProvider.notifier),
          ),
        ],
        child: const App(),
      ),
    );
  }, (error, stack) {
    developer.log(
      'Uncaught async error',
      name: 'main',
      error: error,
      stackTrace: stack,
      level: 1000,
    );
  });
}
