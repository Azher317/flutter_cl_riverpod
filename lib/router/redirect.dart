import 'package:app/core/config/app_config.dart';
import 'package:app/core/session/session_notifier.dart'; // new_app:guest
import 'package:app/core/session/sign_in_gate.dart'; // new_app:guest
import 'package:app/core/utils/constants/route_names.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // new_app:guest
import 'package:go_router/go_router.dart'; // new_app:guest

/// Where the router sends the user, or `null` to stay. Pure, so it is
/// tested on its own (test/router/redirect_test.dart).
String? appRedirect({
  required String location,
  required bool restoring,
  required bool signedIn,
  bool handBack = false,
  SignInMode mode = AppConfig.signIn,
}) {
  // Session still restoring from cache: hold on the splash screen.
  if (restoring) {
    return location == RouteNames.splash ? null : RouteNames.splash;
  }

  if (!signedIn) {
    // No sign-in at all: everyone uses the app as is.
    if (mode == SignInMode.none) {
      return location == RouteNames.splash ? RouteNames.home : null;
    }
    if (mode == SignInMode.required) {
      return location == RouteNames.login ? null : RouteNames.login;
    }
    // Guest mode: browse freely, except screens that need an account.
    if (location == RouteNames.splash) return RouteNames.home;
    if (RouteNames.signedInOnly.contains(location)) return RouteNames.login;
    return null;
  }

  // Signed in. A sign-in opened by requireSignIn is closed by the router's
  // hand-back listener (back to the screen that asked), so stay put.
  if (location == RouteNames.login) return handBack ? null : RouteNames.home;
  if (location == RouteNames.splash) return RouteNames.home;
  return null;
}

// new_app:guest-start
/// Sign-in hand-back (guest mode): once a sign-in opened by
/// `requireSignIn` succeeds, close it, so the screen that asked is back on
/// top and finishes its action.
void listenForSignInHandBack(Ref ref, GoRouter router) {
  ref.listen(isSignedInProvider, (_, signedIn) {
    if (signedIn && ref.read(signInHandBackProvider) && router.canPop()) {
      router.pop();
    }
  });
}

// new_app:guest-end
