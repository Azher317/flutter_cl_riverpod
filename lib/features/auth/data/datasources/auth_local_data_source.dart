import 'dart:convert';

import 'package:app/core/errors/exceptions.dart';
import 'package:app/core/storage/shared_preferences_provider.dart';
import 'package:app/features/auth/data/models/authentication_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_local_data_source.g.dart';

const _kAuthSessionKey = 'authentication';

abstract class AuthLocalDataSource {
  Future<void> cacheSession(AuthenticationModel session);
  AuthenticationModel? getCachedSession();
  Future<void> clearSession();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<void> cacheSession(AuthenticationModel session) async {
    try {
      await _sharedPreferences.setString(
        _kAuthSessionKey,
        json.encode(session.toJson()),
      );
    } catch (e) {
      throw CacheException('Failed to cache session: $e');
    }
  }

  @override
  AuthenticationModel? getCachedSession() {
    final raw = _sharedPreferences.getString(_kAuthSessionKey);
    if (raw == null) return null;
    try {
      return AuthenticationModel.fromJson(
        json.decode(raw) as Map<String, dynamic>,
      );
    } catch (e) {
      // Self-healing: a stale/incompatible cache shouldn't keep failing on
      // every launch, so clear it before surfacing the exception.
      _sharedPreferences.remove(_kAuthSessionKey);
      throw CacheException('Failed to read cached session: $e');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await _sharedPreferences.remove(_kAuthSessionKey);
    } catch (e) {
      throw CacheException('Failed to clear session: $e');
    }
  }
}

@riverpod
AuthLocalDataSource authLocalDataSource(Ref ref) =>
    AuthLocalDataSourceImpl(ref.sharedPreferences);
