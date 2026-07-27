import 'package:app/core/errors/failures.dart';
import 'package:app/core/messaging/snackbar.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:flutter/widgets.dart';

/// Central `Failure` → user-facing message presentation. This is the UI-side
/// twin of `NetworkErrorMapper`: one place that turns a domain [Failure] into a
/// localized sentence, so every screen renders errors identically instead of
/// re-writing the switch. The network layer stays UI-free — nothing here is
/// called from an interceptor.
extension FailureX on BuildContext {
  /// The localized, user-facing message for [failure].
  ///
  /// For the "content" failures (bad request / conflict / not found / forbidden
  /// / server) the backend's own message is preferred when it sent one, falling
  /// back to a localized default. The generic transport/auth failures are always
  /// localized by type. The `switch` is exhaustive because [Failure] is sealed.
  String localizeFailure(Failure failure) {
    String pick(String serverMessage, String fallback) =>
        serverMessage.trim().isEmpty ? fallback : serverMessage;

    return switch (failure) {
      NetworkFailure() => l10n.noConnection,
      InvalidCredentialsFailure() => l10n.invalidCredentials,
      UnauthorizedFailure() => l10n.sessionExpired,
      ForbiddenFailure() => pick(failure.message, l10n.forbidden),
      NotFoundFailure() => pick(failure.message, l10n.notFound),
      BadRequestFailure() => pick(failure.message, l10n.badRequest),
      ConflictFailure() => pick(failure.message, l10n.conflict),
      ServerFailure() => pick(failure.message, l10n.serverError),
      CacheFailure() => l10n.defaultErrorMessage,
    };
  }

  /// Shows [failure] as a snackbar via [AppMessenger].
  void showFailure(Failure failure, {MessageType type = MessageType.error}) =>
      AppMessenger.show(localizeFailure(failure), type: type);
}
