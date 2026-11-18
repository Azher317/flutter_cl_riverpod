// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The single source of truth for the current session — a **core** concern,
/// not owned by any feature. Holds `AsyncValue<AuthSessionEntity?>`:
/// `isLoading` while restoring from cache, `null` when signed out.
///
/// - Features **read** the session through [currentUserProvider] and
///   [isSignedInProvider] — reactive, and token-free.
/// - Features **write** only through `sessionProvider.notifier`
///   ([setSession] after login, [logout]).
/// - Only `core/network` (the token) and `lib/router` (the redirect) read this
///   provider's state directly.
// keepAlive: App-lifetime service: session.

@ProviderFor(Session)
const sessionProvider = SessionProvider._();

/// The single source of truth for the current session — a **core** concern,
/// not owned by any feature. Holds `AsyncValue<AuthSessionEntity?>`:
/// `isLoading` while restoring from cache, `null` when signed out.
///
/// - Features **read** the session through [currentUserProvider] and
///   [isSignedInProvider] — reactive, and token-free.
/// - Features **write** only through `sessionProvider.notifier`
///   ([setSession] after login, [logout]).
/// - Only `core/network` (the token) and `lib/router` (the redirect) read this
///   provider's state directly.
// keepAlive: App-lifetime service: session.
final class SessionProvider
    extends $AsyncNotifierProvider<Session, AuthSessionEntity?> {
  /// The single source of truth for the current session — a **core** concern,
  /// not owned by any feature. Holds `AsyncValue<AuthSessionEntity?>`:
  /// `isLoading` while restoring from cache, `null` when signed out.
  ///
  /// - Features **read** the session through [currentUserProvider] and
  ///   [isSignedInProvider] — reactive, and token-free.
  /// - Features **write** only through `sessionProvider.notifier`
  ///   ([setSession] after login, [logout]).
  /// - Only `core/network` (the token) and `lib/router` (the redirect) read this
  ///   provider's state directly.
  // keepAlive: App-lifetime service: session.
  const SessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sessionHash();

  @$internal
  @override
  Session create() => Session();
}

String _$sessionHash() => r'6496fc1e8e6df6c54e6d9db6fbe0a23d130d7525';

/// The single source of truth for the current session — a **core** concern,
/// not owned by any feature. Holds `AsyncValue<AuthSessionEntity?>`:
/// `isLoading` while restoring from cache, `null` when signed out.
///
/// - Features **read** the session through [currentUserProvider] and
///   [isSignedInProvider] — reactive, and token-free.
/// - Features **write** only through `sessionProvider.notifier`
///   ([setSession] after login, [logout]).
/// - Only `core/network` (the token) and `lib/router` (the redirect) read this
///   provider's state directly.
// keepAlive: App-lifetime service: session.

abstract class _$Session extends $AsyncNotifier<AuthSessionEntity?> {
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

/// The signed-in user, or `null` when signed out or still restoring.
/// Reactive: rebuilds on login/logout. Never exposes the token.
// keepAlive: App-lifetime service: session.

@ProviderFor(currentUser)
const currentUserProvider = CurrentUserProvider._();

/// The signed-in user, or `null` when signed out or still restoring.
/// Reactive: rebuilds on login/logout. Never exposes the token.
// keepAlive: App-lifetime service: session.

final class CurrentUserProvider
    extends $FunctionalProvider<UserEntity?, UserEntity?, UserEntity?>
    with $Provider<UserEntity?> {
  /// The signed-in user, or `null` when signed out or still restoring.
  /// Reactive: rebuilds on login/logout. Never exposes the token.
  // keepAlive: App-lifetime service: session.
  const CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $ProviderElement<UserEntity?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UserEntity? create(Ref ref) {
    return currentUser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserEntity? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserEntity?>(value),
    );
  }
}

String _$currentUserHash() => r'a9e866e444a13094de996ae860a777d9a12367a8';

/// Whether a session exists. `false` while restoring from cache — the router
/// holds on splash using `sessionProvider.isLoading`, so screens never see
/// that ambiguous state.
// keepAlive: App-lifetime service: session.

@ProviderFor(isSignedIn)
const isSignedInProvider = IsSignedInProvider._();

/// Whether a session exists. `false` while restoring from cache — the router
/// holds on splash using `sessionProvider.isLoading`, so screens never see
/// that ambiguous state.
// keepAlive: App-lifetime service: session.

final class IsSignedInProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Whether a session exists. `false` while restoring from cache — the router
  /// holds on splash using `sessionProvider.isLoading`, so screens never see
  /// that ambiguous state.
  // keepAlive: App-lifetime service: session.
  const IsSignedInProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isSignedInProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isSignedInHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isSignedIn(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isSignedInHash() => r'0c98504d84e2719fdc333a6d3f8420f2f1294a29';
