import 'package:app/features/auth/domain/entities/user_entity.dart';

/// An authenticated session: the [token] and the [user] it belongs to.
///
/// The token is a session concern, so it lives here rather than on
/// [UserEntity], which models the user's identity independent of any session.
class AuthSessionEntity {
  const AuthSessionEntity({required this.token, required this.user});

  final String token;
  final UserEntity user;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthSessionEntity &&
          runtimeType == other.runtimeType &&
          token == other.token &&
          user == other.user;

  @override
  int get hashCode => Object.hash(token, user);

  @override
  String toString() => 'AuthSessionEntity(token: $token, user: $user)';
}
