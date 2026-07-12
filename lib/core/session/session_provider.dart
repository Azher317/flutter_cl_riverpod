import 'package:app/core/session/session_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// `core/` defines this interface but deliberately has no concrete session
/// implementation of its own — `core` must never import from `features/`.
/// The `auth` feature supplies the real implementation
/// (`AuthSession` in `features/auth/presentation/notifiers/auth_session_provider.dart`),
/// wired in via a provider override at the composition root (`main.dart`):
///
/// ```dart
/// ProviderScope(
///   overrides: [
///     sessionControllerProvider.overrideWith(
///       (ref) => ref.watch(authSessionProvider.notifier),
///     ),
///   ],
///   ...
/// )
/// ```
///
/// Any test that exercises Dio (`dioProvider`) or anything downstream of it
/// must supply the same override, or this provider throws
/// [UnimplementedError] — there's no default/no-op session to fall back to.
final sessionControllerProvider = Provider<SessionController>((ref) {
  throw UnimplementedError(
    'Override sessionControllerProvider with a feature-specific implementation',
  );
});
