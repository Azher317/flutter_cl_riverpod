import 'dart:convert';

import 'package:app/core/errors/exceptions.dart';
import 'package:app/core/storage/secure_storage_provider.dart';
import 'package:app/core/storage/storage_keys.dart';
import 'package:app/features/auth/data/models/authentication_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_local_data_source.g.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheSession(AuthenticationModel session);
  Future<AuthenticationModel?> getCachedSession();
  Future<void> clearSession();
}

// The session (including the bearer token) is stored via FlutterSecureStorage
// (Keychain/Keystore-backed) rather than SharedPreferences — tokens must not
// sit in plaintext, unencrypted app storage.
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._secureStorage);

  final FlutterSecureStorage _secureStorage;

  @override
  Future<void> cacheSession(AuthenticationModel session) async {
    try {
      await _secureStorage.write(
        key: SecureStorageKeys.authSession,
        value: json.encode(session.toJson()),
      );
    } catch (e) {
      throw CacheException('Failed to cache session: $e');
    }
  }

  @override
  Future<AuthenticationModel?> getCachedSession() async {
    final raw = await _secureStorage.read(key: SecureStorageKeys.authSession);
    if (raw == null) return null;
    try {
      return AuthenticationModel.fromJson(
        json.decode(raw) as Map<String, dynamic>,
      );
    } catch (e) {
      // Self-healing: a stale/incompatible cache shouldn't keep failing on
      // every launch, so clear it before surfacing the exception.
      await _secureStorage.delete(key: SecureStorageKeys.authSession);
      throw CacheException('Failed to read cached session: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await _secureStorage.delete(key: SecureStorageKeys.authSession);
    } catch (e) {
      throw CacheException('Failed to clear session: $e');
    }
  }
}

@riverpod
AuthLocalDataSource authLocalDataSource(Ref ref) =>
    AuthLocalDataSourceImpl(ref.secureStorage);
