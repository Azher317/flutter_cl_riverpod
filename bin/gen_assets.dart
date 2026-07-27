// bin/gen_assets.dart
import 'dart:io';

import 'package:flutter/widgets.dart';

const pngDir = 'assets/images/png';
const svgDir = 'assets/images/svg';
const outputPath = 'lib/core/utils/constants/assets.dart';

void main() {
  final pngs = _collectAssets(pngDir, '.png');
  final svgs = _collectAssets(svgDir, '.svg');

  final buffer = StringBuffer()
    ..writeln('// GENERATED FILE — do not edit by hand.')
    ..writeln('// Run: dart run app:gen_assets')
    ..writeln()
    ..writeln('abstract class PngAssets {');
  for (final name in pngs) {
    buffer.writeln("  static const ${_toCamel(name)} = '$name';");
  }
  buffer
    ..writeln('}')
    ..writeln()
    ..writeln('abstract class SvgAssets {');
  for (final name in svgs) {
    buffer.writeln("  static const ${_toCamel(name)} = '$name';");
  }
  buffer.writeln('}');

  final outFile = File(outputPath);
  outFile.parent.createSync(recursive: true);
  outFile.writeAsStringSync(buffer.toString());

  debugPrint(
    '✅ Generated ${pngs.length} PNG + ${svgs.length} SVG constants → $outputPath',
  );
}

List<String> _collectAssets(String dirPath, String extension) {
  final dir = Directory(dirPath);
  if (!dir.existsSync()) {
    debugPrint('⚠️  Directory not found: $dirPath');
    return [];
  }

  final names = <String>[];
  final skipped = <String>[];

  for (final entity in dir.listSync(recursive: true)) {
    if (entity is! File) continue;
    if (!entity.path.toLowerCase().endsWith(extension)) continue;

    final fileName = entity.uri.pathSegments.last;
    final nameWithoutExt = fileName.substring(
      0,
      fileName.length - extension.length,
    );

    if (!RegExp(r'^[a-zA-Z0-9_\-]+$').hasMatch(nameWithoutExt)) {
      skipped.add(nameWithoutExt);
      continue;
    }

    names.add(nameWithoutExt);
  }

  if (skipped.isNotEmpty) {
    debugPrint(
      '⚠️  Skipped (non-ASCII, use raw string): ${skipped.join(", ")}',
    );
  }

  names.sort();
  return names;
}

String _toCamel(String s) {
  final parts = s
      .split(RegExp(r'[_\-\s]+'))
      .where((p) => p.isNotEmpty)
      .toList();
  if (parts.isEmpty) return s;
  return parts.first.toLowerCase() +
      parts
          .skip(1)
          .map((p) => p[0].toUpperCase() + p.substring(1).toLowerCase())
          .join();
}
