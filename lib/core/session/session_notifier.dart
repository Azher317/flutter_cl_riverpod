import 'dart:async';

import 'package:app/core/session/data/session_repository.dart';
import 'package:app/core/session/entities/auth_session_entity.dart';
import 'package:app/core/session/entities/user_entity.dart';
import 'package:app/core/session/session_controller.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'session_notifier.g.dart';

/// The single source of truth for the current session — a **core** concern,
/// not owned by any feature. Holds `AsyncValue<AuthSessionEntity?>`:
/// `isLoading` while restoring from cache, `null` when signed out.
///
/// A feature that authenticates (e.g. `auth`) calls [setSession] with the
/// session it produced; UI reads the session through the [SessionController]
/// interface (no token). The network layer reads the token from this provider's
/// `AsyncValue` directly, and the router watches it to drive redirects.
@Riverpod(keepAlive: true)
class Session extends _$Session implements SessionController {
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

  @override
  UserEntity? get user => state.value?.user;

  @override
  bool get isSignedIn => state.value != null;

  @override
  Future<void> logout() async {
    // Best-effort: clear in-memory state regardless of whether the disk clear
    // succeeds — "signed out" shouldn't depend on that. The router watches this
    // state and redirects to login on its own.
    await ref.read(sessionRepositoryProvider).clear();
    state = const AsyncData(null);
    // Stale caches in other providers: core cannot import feature providers to
    // invalidate them here (that would invert the dependency rule). Any
    // user-scoped provider must instead watch `sessionControllerProvider` (or
    // be autoDispose) so it rebuilds/clears when the session drops to null.
  }
}
