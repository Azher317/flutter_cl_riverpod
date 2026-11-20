import 'package:app/core/observability/app_logger.dart';
import 'package:app/core/storage/storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Makes a reinstall start like a fresh install.
///
/// The iOS Keychain keeps secure values (the session, device tokens) after
/// the app is deleted; SharedPreferences doesn't. So when
/// [PreferenceKeys.installMarker] is missing, this is a new install: wipe the
/// secure store (signed out), then write the marker.
///
/// Best-effort like the rest of storage: failures are logged and swallowed,
/// and the marker is written anyway so a failing Keychain can't make every
/// launch sign the user out.
abstract class FreshInstallGuard {
  const FreshInstallGuard._();

  static Future<void> run(
    SharedPreferences prefs,
    FlutterSecureStorage secureStorage,
  ) async {
    if (prefs.getBool(PreferenceKeys.installMarker) ?? false) return;

    try {
      await secureStorage.deleteAll();
    } catch (e) {
      AppLogger.warning(
        'Failed to clear secure storage on a fresh install: $e',
      );
    }
    try {
      await prefs.setBool(PreferenceKeys.installMarker, true);
    } catch (e) {
      AppLogger.warning('Failed to write the install marker: $e');
    }
  }
}
