import 'package:app/app.dart';
import 'package:app/core/session/session_provider.dart';
import 'package:app/features/auth/presentation/providers/auth_session_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app/core/storage/shared_preferences_provider.dart';
import 'package:timeago/timeago.dart' as timeago;

const String appName = 'Azher';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPreferences = await SharedPreferences.getInstance();

  timeago.setLocaleMessages('ar', timeago.ArMessages()); // Arabic time labels

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => sharedPreferences),
        sessionControllerProvider.overrideWith(
          (ref) => ref.watch(authSessionProvider.notifier),
        ),
      ],
      child: const App(),
    ),
  );
}
