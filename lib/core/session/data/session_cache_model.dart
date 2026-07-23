import 'package:app/core/session/entities/auth_session_entity.dart';
import 'package:app/core/session/entities/user_entity.dart';
import 'package:app/core/utils/annotations/json_serializable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'session_cache_model.freezed.dart';
part 'session_cache_model.g.dart';

/// The on-device persistence shape of a session.
///
/// Deliberately independent of the auth feature's login-response `UserModel`:
/// the session cache is a core concern and must not depend on any feature's
/// wire format. It mirrors [AuthSessionEntity] / [UserEntity] flatly and owns
/// its own JSON, so the persisted format is stable regardless of how any
/// feature happens to authenticate.
@freezed
abstract class SessionCacheModel with _$SessionCacheModel {
  const SessionCacheModel._();

  @jsonSerializable
  const factory SessionCacheModel({
    required String token,
    required String userId,
    required int role,
    required String name,
    required String phone,
    String? profileImg,
    required String createdAt,
  }) = _SessionCacheModel;

  factory SessionCacheModel.fromJson(Map<String, dynamic> json) =>
      _$SessionCacheModelFromJson(json);

  factory SessionCacheModel.fromEntity(AuthSessionEntity session) =>
      SessionCacheModel(
        token: session.token,
        userId: session.user.id,
        role: session.user.role,
        name: session.user.name,
        phone: session.user.phone,
        profileImg: session.user.profileImg,
        createdAt: session.user.createdAt,
      );

  AuthSessionEntity toEntity() => AuthSessionEntity(
    token: token,
    user: UserEntity(
      id: userId,
      role: role,
      name: name,
      phone: phone,
      profileImg: profileImg,
      createdAt: createdAt,
    ),
  );
}
