// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_cache_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SessionCacheModel _$SessionCacheModelFromJson(Map<String, dynamic> json) =>
    _SessionCacheModel(
      token: json['token'] as String,
      userId: json['userId'] as String,
      role: (json['role'] as num).toInt(),
      name: json['name'] as String,
      phone: json['phone'] as String,
      profileImg: json['profileImg'] as String?,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$SessionCacheModelToJson(_SessionCacheModel instance) =>
    <String, dynamic>{
      'token': instance.token,
      'userId': instance.userId,
      'role': instance.role,
      'name': instance.name,
      'phone': instance.phone,
      'profileImg': instance.profileImg,
      'createdAt': instance.createdAt,
    };
