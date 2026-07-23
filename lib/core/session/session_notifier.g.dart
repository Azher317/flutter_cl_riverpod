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
/// A feature that authenticates (e.g. `auth`) calls [setSession] with the
/// session it produced; UI reads the session through the [SessionController]
/// interface (no token). The network layer reads the token from this provider's
/// `AsyncValue` directly, and the router watches it to drive redirects.

@ProviderFor(Session)
const sessionProvider = SessionProvider._();

/// The single source of truth for the current session — a **core** concern,
/// not owned by any feature. Holds `AsyncValue<AuthSessionEntity?>`:
/// `isLoading` while restoring from cache, `null` when signed out.
///
/// A feature that authenticates (e.g. `auth`) calls [setSession] with the
/// session it produced; UI reads the session through the [SessionController]
/// interface (no token). The network layer reads the token from this provider's
/// `AsyncValue` directly, and the router watches it to drive redirects.
final class SessionProvider
    extends $AsyncNotifierProvider<Session, AuthSessionEntity?> {
  /// The single source of truth for the current session — a **core** concern,
  /// not owned by any feature. Holds `AsyncValue<AuthSessionEntity?>`:
  /// `isLoading` while restoring from cache, `null` when signed out.
  ///
  /// A feature that authenticates (e.g. `auth`) calls [setSession] with the
  /// session it produced; UI reads the session through the [SessionController]
  /// interface (no token). The network layer reads the token from this provider's
  /// `AsyncValue` directly, and the router watches it to drive redirects.
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

String _$sessionHash() => r'0e428cfae23cac274e77e84834714b16ed46ce36';

/// The single source of truth for the current session — a **core** concern,
/// not owned by any feature. Holds `AsyncValue<AuthSessionEntity?>`:
/// `isLoading` while restoring from cache, `null` when signed out.
///
/// A feature that authenticates (e.g. `auth`) calls [setSession] with the
/// session it produced; UI reads the session through the [SessionController]
/// interface (no token). The network layer reads the token from this provider's
/// `AsyncValue` directly, and the router watches it to drive redirects.

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
