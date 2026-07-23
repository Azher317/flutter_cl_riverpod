import 'package:app/core/observability/app_logger.dart';
import 'package:app/core/session/session_notifier.dart';
import 'package:app/core/utils/constants/route_names.dart';
import 'package:app/features/auth/presentation/screens/login_screen.dart';
import 'package:app/features/home/presentation/screens/home_screen.dart';
import 'package:app/features/splash/presentation/screens/splash_screen.dart';
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
    initialLocation: RouteNames.splash,
    navigatorKey: _rootNavigatorKey,
    refreshListenable: refreshNotifier,
    observers: [if (kDebugMode) TalkerRouteObserver(routeTalker)],
    redirect: (context, state) {
      final session = ref.read(sessionProvider);
      final loc = state.matchedLocation;

      // Debug-only log viewer must stay reachable even signed out.
      if (kDebugMode && state.matchedLocation == RouteNames.logs) {
        return null;
      }

      // Session still restoring from cache → hold on the splash screen.
      if (session.isLoading) {
        return loc == RouteNames.splash ? null : RouteNames.splash;
      }

      final signedIn = session.value != null;

      // Signed out → only the login screen is allowed.
      if (!signedIn) {
        return loc == RouteNames.login ? null : RouteNames.login;
      }

      // Signed in → bounce away from the splash/login screens.
      if (loc == RouteNames.splash || loc == RouteNames.login) {
        return RouteNames.home;
      }

      return null; // no redirect needed
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      if (kDebugMode)
        GoRoute(
          path: RouteNames.logs,
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
