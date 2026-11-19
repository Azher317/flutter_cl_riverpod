import 'package:app/core/session/session_notifier.dart';
import 'package:app/core/utils/constants/route_names.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_gate.g.dart';

/// True while a screen is waiting for the user to sign in so it can finish
/// what it started (see [RequireSignIn.requireSignIn]). The router keeps
/// the sign-in screen open while this is set, and closes it on success.
// keepAlive: lives across the push to the sign-in screen and back.
@Riverpod(keepAlive: true)
class SignInHandBack extends _$SignInHandBack {
  @override
  bool build() => false;

  void start() => state = true;

  void finish() => state = false;
}

extension RequireSignIn on WidgetRef {
  /// Runs [then] now if the user is signed in. Otherwise opens the sign-in
  /// screen on top of the current one and runs [then] after a successful
  /// sign-in, back on the same screen with everything the user typed still
  /// there. Backing out of sign-in runs nothing.
  ///
  /// For guest-mode apps only (`AppConfig.signIn == SignInMode.guest`); in a
  /// sign-in-required app every screen is already signed in.
  ///
  /// ```dart
  /// onPressed: () => ref.requireSignIn(context, () => notifier.send(draft)),
  /// ```
  Future<void> requireSignIn(
    BuildContext context,
    Future<void> Function() then,
  ) async {
    if (read(isSignedInProvider)) return then();
    read(signInHandBackProvider.notifier).start();
    try {
      await context.push<void>(RouteNames.login);
    } finally {
      read(signInHandBackProvider.notifier).finish();
    }
    if (read(isSignedInProvider)) await then();
  }
}
