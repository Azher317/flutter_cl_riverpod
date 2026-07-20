import 'package:app/core/utils/annotations/json_serializable.dart';
import 'package:app/features/auth/domain/entities/user_entity.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
abstract class UserModel with _$UserModel {
  const UserModel._();

  @jsonSerializable
  const factory UserModel({
    required String token,
    required String phoneNumber,
    String? image,
    required String id,
    required String fullName,
    required int role,
    @JsonKey(name: 'creationDate') required String createdAt,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  UserEntity toEntity() => UserEntity(
    id: id,
    role: role,
    name: fullName,
    phone: phoneNumber,
    profileImg: image,
    createdAt: createdAt,
  );
}
