// App exceptions — thrown *inside the data layer only* and translated into a
// [Failure] by the repository (see `SafeRepositoryCall`). They are the app's
// own vocabulary: no `DioException` ever escapes the data layer. The generic
// transport -> exception mapping lives in one place, `NetworkErrorMapper`.

// --- Transport ---------------------------------------------------------------

/// Couldn't complete the round-trip (offline, timeout, DNS, socket error).
class NetworkException implements Exception {
  const NetworkException(this.message);
  final String message;
}

// --- HTTP status ------------------------------------------------------------
// One type per status the UI may reasonably branch on. `NetworkErrorMapper`
// produces these from a `DioException`'s response status code.

/// 400 — the request was rejected as malformed/invalid.
class BadRequestException implements Exception {
  const BadRequestException(this.message);
  final String message;
}

/// 401 — not authenticated / session expired. NOTE: on the login endpoint a
/// 401 means "wrong credentials" instead; that reinterpretation lives in the
/// auth data source, which catches this and throws [InvalidCredentialsException].
class UnauthorizedException implements Exception {
  const UnauthorizedException(this.message);
  final String message;
}

/// 403 — authenticated but not allowed.
class ForbiddenException implements Exception {
  const ForbiddenException(this.message);
  final String message;
}

/// 404 — resource not found.
class NotFoundException implements Exception {
  const NotFoundException(this.message);
  final String message;
}

/// 409 — conflict with current server state (duplicate, version clash, …).
class ConflictException implements Exception {
  const ConflictException(this.message);
  final String message;
}

/// 5xx, unclassified 4xx, or a non-Dio failure (e.g. a JSON parse error).
class ServerException implements Exception {
  const ServerException(this.message);
  final String message;
}

// --- Feature-specific -------------------------------------------------------

/// Login-only: a 401 on the sign-in endpoint means wrong phone/password, not an
/// expired session. The auth data source maps [UnauthorizedException] → this.
class InvalidCredentialsException implements Exception {
  const InvalidCredentialsException(this.message);
  final String message;
}

// --- Local storage ----------------------------------------------------------

/// A secure-storage read/write/delete failed.
class CacheException implements Exception {
  const CacheException(this.message);
  final String message;
}
