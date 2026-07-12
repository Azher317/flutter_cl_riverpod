import 'package:app/core/theme/sizes.dart';
import 'package:app/core/widgets/skelton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Network image that (a) decodes at display size to save memory instead of
/// decoding full-resolution source images into a small widget, and
/// (b) shows a shimmer placeholder + graceful error consistently app-wide.
class CachedImage extends StatelessWidget {
  const CachedImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = BorderSize.small,
    this.devicePixelRatioCap = 2.0,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;
  final double devicePixelRatioCap;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context).clamp(1.0, devicePixelRatioCap);
    // Decode target in physical pixels; null lets that axis stay intrinsic.
    final int? memW = width == null ? null : (width! * dpr).round();
    final int? memH = height == null ? null : (height! * dpr).round();

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: memW,
        memCacheHeight: memH,
        placeholder: (_, __) => CustomSkeleton(width: width, height: height, radius: radius),
        errorWidget: (context, _, __) => ColoredBox(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          child: Icon(
            Icons.broken_image_outlined,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}
