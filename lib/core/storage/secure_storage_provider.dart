import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Hand-written provider, not @riverpod-generated: this repo has no
// build_runner/codegen pipeline (see CLAUDE.md) to produce the matching
// .g.dart part file, so this mirrors what that generator would emit.
final flutterSecureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  const androidOptions = AndroidOptions(encryptedSharedPreferences: true);
  const iosOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );
  return const FlutterSecureStorage(
    aOptions: androidOptions,
    iOptions: iosOptions,
  );
});

extension SecureStorageRefX on Ref {
  FlutterSecureStorage get secureStorage => read(flutterSecureStorageProvider);
}
