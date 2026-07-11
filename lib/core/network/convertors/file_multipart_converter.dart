import 'dart:io';
import 'package:app/core/network/clients_lib.dart';

class FileJsonConverter extends JsonConverter<File, MultipartFile> {
  const FileJsonConverter();

  @override
  File fromJson(MultipartFile json) => throw UnimplementedError();

  @override
  MultipartFile toJson(File object) => MultipartFile.fromFileSync(object.path);
}
