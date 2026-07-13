import 'dart:io';

import 'package:flutter/widgets.dart';

class ImagePng extends StatelessWidget {
  final String img;
  final double? size;
  final double? height;
  final double? width;
  final double borderRadius;
  final AlignmentGeometry alignment;
  final BoxFit fit;
  final bool isFileImage;

  const ImagePng({
    required this.img,
    this.height,
    this.size,
    this.borderRadius = 0,
    this.width,
    this.alignment = Alignment.center,
    this.fit = BoxFit.fitHeight,
    this.isFileImage = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: isFileImage
          ? Image.file(
              File(img),
              height: size ?? height,
              width: size ?? width,
              fit: fit,
              alignment: alignment,
            )
          : Image.asset(
              "assets/images/png/$img.png",
              height: size ?? height,
              width: size ?? width,
              fit: fit,
              alignment: alignment,
            ),
    );
  }
}
