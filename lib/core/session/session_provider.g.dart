// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// UI-facing view of the session: the user, auth-status and logout — never the
/// token. Delegates to the core [Session] notifier ([sessionProvider]). The
/// network layer reads the token from `sessionProvider` directly instead.

@ProviderFor(sessionController)
const sessionControllerProvider = SessionControllerProvider._();

/// UI-facing view of the session: the user, auth-status and logout — never the
/// token. Delegates to the core [Session] notifier ([sessionProvider]). The
/// network layer reads the token from `sessionProvider` directly instead.

final class SessionControllerProvider
    extends
        $FunctionalProvider<
          SessionController,
          SessionController,
          SessionController
        >
    with $Provider<SessionController> {
  /// UI-facing view of the session: the user, auth-status and logout — never the
  /// token. Delegates to the core [Session] notifier ([sessionProvider]). The
  /// network layer reads the token from `sessionProvider` directly instead.
  const SessionControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionControllerHash();

  @$internal
  @override
  $ProviderElement<SessionController> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SessionController create(Ref ref) {
    return sessionController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SessionController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SessionController>(value),
    );
  }
}

String _$sessionControllerHash() => r'9c26932746ac885170ebbebb8c4e338f16471eab';
