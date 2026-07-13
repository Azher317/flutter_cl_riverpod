import 'package:app/features/auth/presentation/notifiers/auth_session_provider.dart';
import 'package:app/features/auth/presentation/screens/login_screen.dart';
import 'package:app/features/home/presentation/screens/home_screen.dart';
import 'package:app/features/splash/presentation/screens/splash_screen.dart';
import 'package:app/core/observability/app_logger.dart';
import 'package:app/router/router_refresh_notifier.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:talker_flutter/talker_flutter.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'shell',
);

// GoRouter configuration
// lib/router/app_router.dart

final routerProvider = Provider<GoRouter>((ref) {
  final refreshNotifier = RouterRefreshNotifier(ref);

  final router = GoRouter(
    debugLogDiagnostics: false,
    initialLocation: RoutesDocument.splash,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: refreshNotifier,
    observers: [if (kDebugMode) TalkerRouteObserver(routeTalker)],
    redirect: (context, state) {
      final session = ref.read(authSessionProvider);
      final loc = state.matchedLocation;

      // Debug-only log viewer must stay reachable even signed out.
      if (kDebugMode && state.matchedLocation == RoutesDocument.logs) {
        return null;
      }

      // Session still restoring from cache → hold on the splash screen.
      if (session.isLoading) {
        return loc == RoutesDocument.splash ? null : RoutesDocument.splash;
      }

      final signedIn = session.value != null;

      // Signed out → only the login screen is allowed.
      if (!signedIn) {
        return loc == RoutesDocument.login ? null : RoutesDocument.login;
      }

      // Signed in → bounce away from the splash/login screens.
      if (loc == RoutesDocument.splash || loc == RoutesDocument.login) {
        return RoutesDocument.home;
      }

      return null; // no redirect needed
    },
    routes: [
      GoRoute(
        path: RoutesDocument.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RoutesDocument.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RoutesDocument.login,
        builder: (context, state) => const LoginScreen(),
      ),
      if (kDebugMode)
        GoRoute(
          path: RoutesDocument.logs,
          builder: (context, state) => TalkerScreen(
            talker: talker,
            appBarTitle: 'Debug',
            showMonitorButton: false,
          ),
        ),
    ],
  );

  // Clean up when provider disposes
  ref.onDispose(refreshNotifier.dispose);
  ref.onDispose(router.dispose);

  return router;
});

class RoutesDocument {
  const RoutesDocument._();
  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String logs = '/logs';
}
