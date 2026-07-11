// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:app/core/models/json_types.dart';
import 'package:app/core/network/paginated.dart';
import 'package:json_annotation/json_annotation.dart';

part "paginated_response.g.dart";

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class PaginatedResponse<T> implements Paginated<T> {
  const PaginatedResponse({
    required this.result,
    required this.count,
    required this.pageNumber,
    required this.pageSize,
    required this.totalPages,
  });

  @override
  @JsonKey(name: 'items')
  final List<T> result;

  @JsonKey(name: 'totalCount')
  final int count;

  final int? pageNumber;
  final int? pageSize;
  final int? totalPages;

  factory PaginatedResponse.fromJson(
          Map<String, dynamic> json, FromJsonT<T> fromJsonT) =>
      _$PaginatedResponseFromJson<T>(json, fromJsonT);

  PaginatedResponse<T> copyWith({
    List<T>? result,
    int? count,
    int? pageNumber,
    int? pageSize,
    int? totalPages,
  }) {
    return PaginatedResponse<T>(
      result: result ?? this.result,
      count: count ?? this.count,
      pageNumber: pageNumber ?? this.pageNumber,
      pageSize: pageSize ?? this.pageSize,
      totalPages: totalPages ?? this.totalPages,
    );
  }

  @override
  int get total => count;
}
