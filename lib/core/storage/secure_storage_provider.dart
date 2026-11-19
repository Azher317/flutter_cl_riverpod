import 'package:app/core/network/clients_lib.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'secure_storage_provider.g.dart';

/// The one secure store configuration. `main` uses it directly (before the
/// `ProviderScope` exists) for `FreshInstallGuard`.
FlutterSecureStorage createSecureStorage() {
  const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  const iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );
  return const FlutterSecureStorage(
    aOptions: androidOptions,
    iOptions: iosOptions,
  );
}

// keepAlive: App-lifetime service: storage.
@Riverpod(keepAlive: true)
FlutterSecureStorage flutterSecureStorage(Ref ref) => createSecureStorage();

extension SecureStorageRefX on Ref {
  FlutterSecureStorage get secureStorage => read(flutterSecureStorageProvider);
}
