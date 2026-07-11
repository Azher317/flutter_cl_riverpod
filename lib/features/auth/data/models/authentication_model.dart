import 'package:app/core/models/_models.dart';
import 'package:app/features/auth/data/models/user_model.dart';
import 'package:app/features/auth/domain/entities/auth_session_entity.dart';

part 'authentication_model.freezed.dart';
part 'authentication_model.g.dart';

@freezed
abstract class AuthenticationModel with _$AuthenticationModel {
  const AuthenticationModel._();

  @jsonSerializable
  const factory AuthenticationModel({
    required String token,
    required UserModel user,
  }) = _AuthenticationModel;

  factory AuthenticationModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationModelFromJson(json);

  factory AuthenticationModel.fromUserModel(UserModel user) =>
      AuthenticationModel(token: user.token, user: user);

  AuthSessionEntity toEntity() =>
      AuthSessionEntity(token: token, user: user.toEntity());
}
