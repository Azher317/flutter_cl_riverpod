// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(sessionController)
const sessionControllerProvider = SessionControllerProvider._();

final class SessionControllerProvider
    extends
        $FunctionalProvider<
          SessionController,
          SessionController,
          SessionController
        >
    with $Provider<SessionController> {
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

String _$sessionControllerHash() => r'0039bd475c509d99ae14fa735937f9e454aa6b22';
