import 'package:app/core/models/json_types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default_response.g.dart';

@JsonSerializable(
  createToJson: false,
  explicitToJson: true,
  genericArgumentFactories: true,
)
class DefaultResponse<T> {
  // "message": "تم بنجاح",
  final String? msg;
  // "result": {},
  final T data;
  // "statusCode": 200
  final double statusCode;

  const DefaultResponse({
    this.msg,
    required this.data,
    required this.statusCode,
  });

  factory DefaultResponse.fromJson(
          Map<String, dynamic> json, FromJsonT<T> fromJsonT) =>
      _$DefaultResponseFromJson<T>(json, fromJsonT);

  DefaultResponse<T> copyWith({
    final String? msg,
    // "data": {},
    final T? data,
    // "error": true
    final double? statusCode,
  }) {
    return DefaultResponse<T>(
        msg: msg ?? this.msg,
        data: data ?? this.data,
        statusCode: statusCode ?? this.statusCode);
  }
}

@JsonEnum(alwaysCreate: true)
enum Role {
  @JsonValue("Supervisor")
  supervisor,
  unknown;

  String toJson() => _$RoleEnumMap[this]!;
}
