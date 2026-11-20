import 'package:app/core/storage/fresh_install_guard.dart';
import 'package:app/core/storage/storage_keys.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A Keychain/Keystore that fails every call.
class _ThrowingStorage extends Fake implements FlutterSecureStorage {
  @override
  Future<void> deleteAll({
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async => throw Exception('keychain unavailable');
}

void main() {
  const secure = FlutterSecureStorage();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({
      SecureStorageKeys.authSession: '{"token":"old"}',
      'device_token': 'old-device',
    });
  });

  test(
    'first launch after install: wipes secure storage, writes the marker',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await FreshInstallGuard.run(prefs, secure);

      expect(await secure.readAll(), isEmpty);
      expect(prefs.getBool(PreferenceKeys.installMarker), isTrue);
    },
  );

  test('later launches: deletes nothing', () async {
    SharedPreferences.setMockInitialValues({
      PreferenceKeys.installMarker: true,
    });
    final prefs = await SharedPreferences.getInstance();

    await FreshInstallGuard.run(prefs, secure);

    expect(
      await secure.read(key: SecureStorageKeys.authSession),
      '{"token":"old"}',
    );
  });

  test(
    'secure storage throws: completes and still writes the marker',
    () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      await expectLater(
        FreshInstallGuard.run(prefs, _ThrowingStorage()),
        completes,
      );
      expect(prefs.getBool(PreferenceKeys.installMarker), isTrue);
    },
  );
}
