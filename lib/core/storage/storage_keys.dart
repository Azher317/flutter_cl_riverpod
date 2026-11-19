/// Keys for the encrypted, Keychain/Keystore-backed secure store
/// (`flutterSecureStorageProvider`). Sensitive data (tokens/session) only.
abstract class SecureStorageKeys {
  const SecureStorageKeys._();

  static const String authSession = 'authentication';
}

/// Keys for plain, unencrypted `SharedPreferences`
/// (`sharedPreferencesProvider`). Non-sensitive data only — never tokens.
abstract class PreferenceKeys {
  const PreferenceKeys._();

  static const String settings = 'settings';

  /// Written on the first launch after an install (`FreshInstallGuard`).
  /// A reinstall wipes it; the iOS Keychain does not.
  static const String installMarker = 'install_marker';
}
