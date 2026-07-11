// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthenticationModel _$AuthenticationModelFromJson(Map<String, dynamic> json) =>
    _AuthenticationModel(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthenticationModelToJson(
  _AuthenticationModel instance,
) => <String, dynamic>{'token': instance.token, 'user': instance.user.toJson()};
