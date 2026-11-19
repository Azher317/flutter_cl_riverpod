import 'package:app/core/config/debug_tools.dart';
import 'package:app/core/observability/app_logger.dart';
import 'package:app/core/session/session_notifier.dart';
import 'package:app/core/session/sign_in_gate.dart';
import 'package:app/core/utils/constants/route_names.dart';
import 'package:app/features/auth/presentation/screens/login_screen.dart';
import 'package:app/features/home/presentation/screens/home_screen.dart';
import 'package:app/features/splash/presentation/screens/splash_screen.dart';
import 'package:app/router/page_transitions.dart';
import 'package:app/router/redirect.dart';
import 'package:app/router/router_refresh_notifier.dart';
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
    observers: [if (showDebugTools) TalkerRouteObserver(routeTalker)],
    redirect: (context, state) {
      // The logs screen (debug and UAT builds) stays reachable signed out.
      if (showDebugTools && state.matchedLocation == RouteNames.logs) {
        return null;
      }
      final session = ref.read(sessionProvider);
      return appRedirect(
        location: state.matchedLocation,
        restoring: session.isLoading,
        signedIn: session.value != null,
        handBack: ref.read(signInHandBackProvider),
      );
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        pageBuilder: (context, state) =>
            appPage(context, state, const SplashScreen()),
      ),
      GoRoute(
        path: RouteNames.home,
        pageBuilder: (context, state) =>
            appPage(context, state, const HomeScreen()),
      ),
      GoRoute(
        path: RouteNames.login,
        pageBuilder: (context, state) =>
            appPage(context, state, const LoginScreen()),
      ),
      if (showDebugTools)
        GoRoute(
          path: RouteNames.logs,
          pageBuilder: (context, state) => appPage(
            context,
            state,
            TalkerScreen(
              talker: talker,
              appBarTitle: 'Debug',
              showMonitorButton: false,
            ),
          ),
        ),
    ],
  );

  listenForSignInHandBack(ref, router);

  // Clean up when provider disposes
  ref.onDispose(refreshNotifier.dispose);
  ref.onDispose(router.dispose);

  return router;
});
