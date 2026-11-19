import 'package:app/core/config/app_config.dart';
import 'package:app/core/session/session_notifier.dart';
import 'package:app/core/session/sign_in_gate.dart';
import 'package:app/core/utils/constants/route_names.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Where the router sends the user, or `null` to stay. Pure, so it is
/// tested on its own (test/router/redirect_test.dart).
String? appRedirect({
  required String location,
  required bool restoring,
  required bool signedIn,
  required bool handBack,
  SignInMode mode = AppConfig.signIn,
}) {
  // Session still restoring from cache: hold on the splash screen.
  if (restoring) {
    return location == RouteNames.splash ? null : RouteNames.splash;
  }

  if (!signedIn) {
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
