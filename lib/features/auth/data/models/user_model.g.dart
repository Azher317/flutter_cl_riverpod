// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserModel _$UserModelFromJson(Map<String, dynamic> json) => _UserModel(
  token: json['token'] as String,
  phoneNumber: json['phoneNumber'] as String,
  image: json['image'] as String?,
  id: json['id'] as String,
  fullName: json['fullName'] as String,
  role: (json['role'] as num).toInt(),
  createdAt: json['creationDate'] as String,
);

Map<String, dynamic> _$UserModelToJson(_UserModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'phoneNumber': instance.phoneNumber,
      'image': instance.image,
      'id': instance.id,
      'fullName': instance.fullName,
      'role': instance.role,
      'creationDate': instance.createdAt,
    };
