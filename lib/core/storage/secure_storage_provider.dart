import 'package:app/core/network/clients_lib.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'secure_storage_provider.g.dart';

@Riverpod(keepAlive: true)
FlutterSecureStorage flutterSecureStorage(Ref ref) {
  const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  const iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );
  return const FlutterSecureStorage(
    aOptions: androidOptions,
    iOptions: iosOptions,
  );
}

extension SecureStorageRefX on Ref {
  FlutterSecureStorage get secureStorage => read(flutterSecureStorageProvider);
}
