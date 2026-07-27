import 'package:app/core/session/entities/user_entity.dart';

abstract class SessionController {
  bool get isSignedIn;

  /// The currently authenticated user, or `null` when signed out.
  ///
  /// This is the UI-facing view of the session — screens read the user and
  /// [isSignedIn], never the raw [token] (which exists only for the network
  /// layer to attach a bearer header).
  UserEntity? get user;

  Future<void> logout();
}
