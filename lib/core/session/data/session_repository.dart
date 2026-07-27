import 'dart:convert';

import 'package:app/core/network/clients_lib.dart';
import 'package:app/core/observability/app_logger.dart';
import 'package:app/core/session/data/session_cache_model.dart';
import 'package:app/core/session/entities/auth_session_entity.dart';
import 'package:app/core/storage/secure_storage_provider.dart';
import 'package:app/core/storage/storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'session_repository.g.dart';

/// Persists the current session in the encrypted, Keychain/Keystore-backed
/// store. The token must never sit in plaintext prefs, so this is the only
/// place the session is written to disk.
///
/// All operations are best-effort and self-contained: they never throw and
/// never return an `Either`. Reads collapse an absent or corrupt cache to
/// `null`; writes and clears log and swallow failures. The session notifier
/// treats "no cache" as "signed out", so a storage hiccup degrades to a
/// clean logged-out state rather than a crash.
abstract class SessionRepository {
  /// The cached session, or `null` when absent/unreadable.
  Future<AuthSessionEntity?> read();

  /// Persist [session] for the next launch.
  Future<void> persist(AuthSessionEntity session);

  /// Remove any persisted session.
  Future<void> clear();
}

class SessionRepositoryImpl implements SessionRepository {
  const SessionRepositoryImpl(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  @override
  Future<AuthSessionEntity?> read() async {
    final raw = await _secureStorage.read(key: SecureStorageKeys.authSession);
    if (raw == null) return null;
    try {
      return SessionCacheModel.fromJson(
        json.decode(raw) as Map<String, dynamic>,
      ).toEntity();
    } catch (e) {
      // Self-healing: a stale/incompatible cache shouldn't keep failing on
      // every launch, so clear it and treat the user as signed out.
      AppLogger.warning('Discarding unreadable session cache: $e');
      await clear();
      return null;
    }
  }

  @override
  Future<void> persist(AuthSessionEntity session) async {
    try {
      await _secureStorage.write(
        key: SecureStorageKeys.authSession,
        value: json.encode(SessionCacheModel.fromEntity(session).toJson()),
      );
    } catch (e) {
      AppLogger.warning('Failed to persist session: $e');
    }
  }

  @override
  Future<void> clear() async {
    try {
      await _secureStorage.delete(key: SecureStorageKeys.authSession);
    } catch (e) {
      AppLogger.warning('Failed to clear session: $e');
    }
  }
}

@Riverpod(keepAlive: true)
SessionRepository sessionRepository(Ref ref) =>
    SessionRepositoryImpl(ref.secureStorage);
