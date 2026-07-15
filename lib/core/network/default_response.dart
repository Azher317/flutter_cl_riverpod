import 'package:app/core/annotations/annotations_lib.dart';
import 'package:app/core/models/json_types.dart';
import 'package:json_annotation/json_annotation.dart';

part 'default_response.g.dart';

@jsonSerializableResponseGeneric
class DefaultResponse<T> {
  // Deserialized from the JSON key "msg".
  final String? msg;
  // Deserialized from the JSON key "data".
  final T data;
  // Deserialized from the JSON key "statusCode".
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
    final T? data,
    final double? statusCode,
  }) {
    return DefaultResponse<T>(
        msg: msg ?? this.msg,
        data: data ?? this.data,
        statusCode: statusCode ?? this.statusCode);
  }
}

// A string-keyed ("Supervisor") role representation. Currently unused —
// UserModel.role is a raw int from a different, undocumented wire format,
// so this isn't wired to it; kept for whichever endpoint/DTO actually
// sends a string-keyed role.
@JsonEnum(alwaysCreate: true)
enum RoleDto {
  @JsonValue('Supervisor')
  supervisor,
  unknown;

  String toJson() => _$RoleDtoEnumMap[this]!;
}
