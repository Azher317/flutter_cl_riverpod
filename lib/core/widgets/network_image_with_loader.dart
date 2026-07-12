import 'package:app/core/theme/sizes.dart';
import 'package:app/core/widgets/cached_image.dart';
import 'package:flutter/material.dart';

class NetworkImageWithLoader extends StatelessWidget {
  final BoxFit fit;

  const NetworkImageWithLoader(
    this.src, {
    super.key,
    this.fit = BoxFit.cover,
    this.radius = BorderSize.small,
    this.width,
    this.height,
  });

  final String src;
  final double radius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CachedImage(
      src,
      fit: fit,
      radius: radius,
      width: width,
      height: height,
    );
  }
}
