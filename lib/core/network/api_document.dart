import 'package:flutter/foundation.dart';

/// Where the backend lives. Every run and every build names its server with
/// one of the files in `env/`:
///
/// ```bash
/// flutter run --dart-define-from-file=env/uat.json
/// bin/build_release.sh prod appbundle   # wraps --dart-define-from-file=env/prod.json
/// ```
///
/// There is no default on purpose: a build that names no server stops at
/// launch ([assertConfigured]) instead of quietly talking to a test server.
abstract class ApiDocument {
  const ApiDocument._();

  /// `dev`, `uat` or `prod`. Empty when no env file was passed.
  static const String env = String.fromEnvironment('API_ENV');

  /// Scheme + host, no trailing slash, e.g. `https://api.example.com`.
  static const String host = String.fromEnvironment('API_HOST');

  /// Every endpoint in `Endpoints` is appended to this.
  static const String baseUrl = '$host/api/user';

  /// Relative media paths from the API are resolved against this.
  static const String mediaUrl = '$host/';

  static const _envs = {'dev', 'uat', 'prod'};

  /// Stops the app at launch, in every build mode, when the build named no
  /// server, a server that is still a placeholder, or a host that ends with
  /// `/`. Called first in `main`.
  static void assertConfigured() => check(env: env, host: host);

  /// The rules behind [assertConfigured], taking the values as arguments so a
  /// test can try each case (the real ones are fixed at compile time).
  @visibleForTesting
  static void check({required String env, required String host}) {
    if (!_envs.contains(env)) {
      throw StateError(
        'No server chosen. Run or build with '
        '--dart-define-from-file=env/<dev|uat|prod>.json '
        '(API_ENV was "$env").',
      );
    }
    final uri = Uri.tryParse(host);
    if (uri == null || !uri.hasScheme || host.endsWith('.invalid')) {
      throw StateError(
        'API_ENV=$env but API_HOST is not set: fill env/$env.json '
        '(API_HOST was "$host").',
      );
    }
    if (host.endsWith('/')) {
      throw StateError(
        'API_HOST in env/$env.json ends with "/", which doubles the slash in '
        'every request (\$host/api/user). Remove the trailing slash '
        '(API_HOST was "$host").',
      );
    }
  }

  static String? resolveMediaPath(String? path) {
    if (path == null || path.trim().isEmpty) return null;
    final t = path.trim();
    if (t.startsWith('http://') || t.startsWith('https://')) return t;
    final base = Uri.parse(mediaUrl);
    final relative = t.startsWith('/') ? t.substring(1) : t;
    if (relative.isEmpty) return null;
    return base.resolve(relative).toString();
  }
}
