import 'package:app/core/session/session_controller.dart';
import 'package:app/features/auth/domain/entities/auth_session_entity.dart';
import 'package:app/features/auth/domain/entities/user_entity.dart';
import 'package:app/features/auth/di/auth_providers.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_session_provider.g.dart';

@Riverpod(keepAlive: true)
class AuthSession extends _$AuthSession implements SessionController {
  @override
  Future<AuthSessionEntity?> build() async {
    final result = await ref.watch(getCachedSessionUseCaseProvider).call();
    // Defensive: the datasource/repository already collapse cache-read
    // failures to Right(null), so Left shouldn't happen here in practice.
    return result.fold((failure) => null, (session) => session);
  }

  AuthSessionEntity? get currentSession => state.value;

  UserEntity? get user => state.value?.user;

  void setSession(AuthSessionEntity session) => state = AsyncData(session);

  @override
  String? get token => state.value?.token;

  @override
  bool get isSignedIn => state.value != null;

  @override
  Future<void> logout() async {
    final result = await ref.read(logoutUseCaseProvider).call();
    result.fold(
      (failure) => debugPrint('Logout failed: $failure'),
      (_) => null,
    );
    // Best-effort logout: clear in-memory state regardless of whether the
    // cache was actually cleared — the user experience of "signed out"
    // shouldn't depend on that succeeding. The router watches this state and
    // redirects to the login screen on its own.
    state = const AsyncData(null);
  }
}
