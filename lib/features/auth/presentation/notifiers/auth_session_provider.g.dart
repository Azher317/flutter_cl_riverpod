// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AuthSession)
const authSessionProvider = AuthSessionProvider._();

final class AuthSessionProvider
    extends $AsyncNotifierProvider<AuthSession, AuthSessionEntity?> {
  const AuthSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionHash();

  @$internal
  @override
  AuthSession create() => AuthSession();
}

String _$authSessionHash() => r'1d9a769d4bf00d2dda28e95622ec37690d9359d8';

abstract class _$AuthSession extends $AsyncNotifier<AuthSessionEntity?> {
  FutureOr<AuthSessionEntity?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<AuthSessionEntity?>, AuthSessionEntity?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthSessionEntity?>, AuthSessionEntity?>,
              AsyncValue<AuthSessionEntity?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
