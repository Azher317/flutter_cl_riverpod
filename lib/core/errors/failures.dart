// Domain failures — *returned* (inside a `Left`), never thrown. This is the
// only error vocabulary the domain/presentation layers see. Each mirrors an
// exception from `exceptions.dart` 1:1; `SafeRepositoryCall.guard` does the
// translation. `Failure` is `sealed` so the UI can exhaustively `switch` on it
// (see `FailureX.localizeFailure`).

sealed class Failure {
  const Failure(this.message);
  final String message;
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class BadRequestFailure extends Failure {
  const BadRequestFailure(super.message);
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure(super.message);
}

class ForbiddenFailure extends Failure {
  const ForbiddenFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

class ConflictFailure extends Failure {
  const ConflictFailure(super.message);
}

class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
