// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_cache_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SessionCacheModel {

 String get token; String get userId; int get role; String get name; String get phone; String? get profileImg; String get createdAt;
/// Create a copy of SessionCacheModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionCacheModelCopyWith<SessionCacheModel> get copyWith => _$SessionCacheModelCopyWithImpl<SessionCacheModel>(this as SessionCacheModel, _$identity);

  /// Serializes this SessionCacheModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionCacheModel&&(identical(other.token, token) || other.token == token)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.profileImg, profileImg) || other.profileImg == profileImg)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,userId,role,name,phone,profileImg,createdAt);

@override
String toString() {
  return 'SessionCacheModel(token: $token, userId: $userId, role: $role, name: $name, phone: $phone, profileImg: $profileImg, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $SessionCacheModelCopyWith<$Res>  {
  factory $SessionCacheModelCopyWith(SessionCacheModel value, $Res Function(SessionCacheModel) _then) = _$SessionCacheModelCopyWithImpl;
@useResult
$Res call({
 String token, String userId, int role, String name, String phone, String? profileImg, String createdAt
});




}
/// @nodoc
class _$SessionCacheModelCopyWithImpl<$Res>
    implements $SessionCacheModelCopyWith<$Res> {
  _$SessionCacheModelCopyWithImpl(this._self, this._then);

  final SessionCacheModel _self;
  final $Res Function(SessionCacheModel) _then;

/// Create a copy of SessionCacheModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? token = null,Object? userId = null,Object? role = null,Object? name = null,Object? phone = null,Object? profileImg = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,profileImg: freezed == profileImg ? _self.profileImg : profileImg // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionCacheModel].
extension SessionCacheModelPatterns on SessionCacheModel {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionCacheModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionCacheModel() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionCacheModel value)  $default,){
final _that = this;
switch (_that) {
case _SessionCacheModel():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionCacheModel value)?  $default,){
final _that = this;
switch (_that) {
case _SessionCacheModel() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String token,  String userId,  int role,  String name,  String phone,  String? profileImg,  String createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionCacheModel() when $default != null:
return $default(_that.token,_that.userId,_that.role,_that.name,_that.phone,_that.profileImg,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String token,  String userId,  int role,  String name,  String phone,  String? profileImg,  String createdAt)  $default,) {final _that = this;
switch (_that) {
case _SessionCacheModel():
return $default(_that.token,_that.userId,_that.role,_that.name,_that.phone,_that.profileImg,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String token,  String userId,  int role,  String name,  String phone,  String? profileImg,  String createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SessionCacheModel() when $default != null:
return $default(_that.token,_that.userId,_that.role,_that.name,_that.phone,_that.profileImg,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc

@jsonSerializable
class _SessionCacheModel extends SessionCacheModel {
  const _SessionCacheModel({required this.token, required this.userId, required this.role, required this.name, required this.phone, this.profileImg, required this.createdAt}): super._();
  factory _SessionCacheModel.fromJson(Map<String, dynamic> json) => _$SessionCacheModelFromJson(json);

@override final  String token;
@override final  String userId;
@override final  int role;
@override final  String name;
@override final  String phone;
@override final  String? profileImg;
@override final  String createdAt;

/// Create a copy of SessionCacheModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionCacheModelCopyWith<_SessionCacheModel> get copyWith => __$SessionCacheModelCopyWithImpl<_SessionCacheModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionCacheModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionCacheModel&&(identical(other.token, token) || other.token == token)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.role, role) || other.role == role)&&(identical(other.name, name) || other.name == name)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.profileImg, profileImg) || other.profileImg == profileImg)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,token,userId,role,name,phone,profileImg,createdAt);

@override
String toString() {
  return 'SessionCacheModel(token: $token, userId: $userId, role: $role, name: $name, phone: $phone, profileImg: $profileImg, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SessionCacheModelCopyWith<$Res> implements $SessionCacheModelCopyWith<$Res> {
  factory _$SessionCacheModelCopyWith(_SessionCacheModel value, $Res Function(_SessionCacheModel) _then) = __$SessionCacheModelCopyWithImpl;
@override @useResult
$Res call({
 String token, String userId, int role, String name, String phone, String? profileImg, String createdAt
});




}
/// @nodoc
class __$SessionCacheModelCopyWithImpl<$Res>
    implements _$SessionCacheModelCopyWith<$Res> {
  __$SessionCacheModelCopyWithImpl(this._self, this._then);

  final _SessionCacheModel _self;
  final $Res Function(_SessionCacheModel) _then;

/// Create a copy of SessionCacheModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? token = null,Object? userId = null,Object? role = null,Object? name = null,Object? phone = null,Object? profileImg = freezed,Object? createdAt = null,}) {
  return _then(_SessionCacheModel(
token: null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,phone: null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,profileImg: freezed == profileImg ? _self.profileImg : profileImg // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
