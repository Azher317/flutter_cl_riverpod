import 'dart:async';

import 'package:app/core/session/data/session_repository.dart';
import 'package:app/core/session/entities/auth_session_entity.dart';
import 'package:app/core/session/entities/user_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_notifier.g.dart';

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
@Riverpod(keepAlive: true)
class Session extends _$Session {
  @override
  Future<AuthSessionEntity?> build() =>
      ref.read(sessionRepositoryProvider).read();

  /// Establish a new authenticated session (called after a successful login).
  /// Flips in-memory state immediately so the network layer and router see the
  /// session at once; persistence for the next launch is best-effort.
  void setSession(AuthSessionEntity session) {
    state = AsyncData(session);
    unawaited(ref.read(sessionRepositoryProvider).persist(session));
  }

  /// End the session. The router watches this state and redirects to login
  /// on its own.
  Future<void> logout() async {
    // Best-effort: clear in-memory state regardless of whether the disk clear
    // succeeds — "signed out" shouldn't depend on that.
    await ref.read(sessionRepositoryProvider).clear();
    state = const AsyncData(null);
    // Core cannot import feature providers to invalidate them here (that would
    // invert the dependency rule). Any user-scoped provider must watch
    // `currentUserProvider` (or be autoDispose) so it rebuilds/clears when the
    // session drops to null.
  }
}

/// The signed-in user, or `null` when signed out or still restoring.
/// Reactive: rebuilds on login/logout. Never exposes the token.
@Riverpod(keepAlive: true)
UserEntity? currentUser(Ref ref) =>
    ref.watch(sessionProvider.select((s) => s.value?.user));

/// Whether a session exists. `false` while restoring from cache — the router
/// holds on splash using `sessionProvider.isLoading`, so screens never see
/// that ambiguous state.
@Riverpod(keepAlive: true)
bool isSignedIn(Ref ref) =>
    ref.watch(sessionProvider.select((s) => s.value != null));
