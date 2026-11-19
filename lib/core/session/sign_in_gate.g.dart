// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_gate.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// True while a screen is waiting for the user to sign in so it can finish
/// what it started (see [RequireSignIn.requireSignIn]). The router keeps
/// the sign-in screen open while this is set, and closes it on success.
// keepAlive: lives across the push to the sign-in screen and back.

@ProviderFor(SignInHandBack)
const signInHandBackProvider = SignInHandBackProvider._();

/// True while a screen is waiting for the user to sign in so it can finish
/// what it started (see [RequireSignIn.requireSignIn]). The router keeps
/// the sign-in screen open while this is set, and closes it on success.
// keepAlive: lives across the push to the sign-in screen and back.
final class SignInHandBackProvider
    extends $NotifierProvider<SignInHandBack, bool> {
  /// True while a screen is waiting for the user to sign in so it can finish
  /// what it started (see [RequireSignIn.requireSignIn]). The router keeps
  /// the sign-in screen open while this is set, and closes it on success.
  // keepAlive: lives across the push to the sign-in screen and back.
  const SignInHandBackProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInHandBackProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInHandBackHash();

  @$internal
  @override
  SignInHandBack create() => SignInHandBack();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$signInHandBackHash() => r'1c50f65313c70ac4133a679b65b2b41083ebbc18';

/// True while a screen is waiting for the user to sign in so it can finish
/// what it started (see [RequireSignIn.requireSignIn]). The router keeps
/// the sign-in screen open while this is set, and closes it on success.
// keepAlive: lives across the push to the sign-in screen and back.

abstract class _$SignInHandBack extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
