import 'dart:developer' as developer;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Logs provider failures so they aren't silently swallowed.
///
/// This only logs via `dart:developer` — there's no Crashlytics/Sentry wired
/// into this app yet. Swap the body of [providerDidFail] for a real crash
/// reporter's `recordError` call once one is added.
base class AppProviderObserver extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    final provider = context.provider;
    developer.log(
      'Provider failed: ${provider.name ?? provider.runtimeType}',
      name: 'AppProviderObserver',
      error: error,
      stackTrace: stackTrace,
      level: 1000, // SEVERE
    );
  }
}
