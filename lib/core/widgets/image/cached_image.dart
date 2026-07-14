import 'package:app/core/constants/sizes.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CachedImage extends StatefulWidget {
  const CachedImage(
    this.url, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.radius = BorderSize.small,
    this.devicePixelRatioCap = 2.0,
    this.cacheKey,
    this.semanticLabel,
  });

  final String? url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double radius;
  final double devicePixelRatioCap;

  /// Pass a stable key when [url] carries expiring/signed query params, so the
  /// same asset maps to one cache entry instead of re-downloading each time.
  final String? cacheKey;

  final String? semanticLabel;

  @override
  State<CachedImage> createState() => _CachedImageState();
}

class _CachedImageState extends State<CachedImage> {
  int _retryCount = 0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderRadius = BorderRadius.circular(widget.radius);

    // Null/blank URL never touches the network — show the error box directly.
    final resolved = widget.url?.trim();
    if (resolved == null || resolved.isEmpty) {
      return ClipRRect(borderRadius: borderRadius, child: _errorBox(scheme));
    }

    final dpr = MediaQuery.devicePixelRatioOf(
      context,
    ).clamp(1.0, widget.devicePixelRatioCap);
    final int? memCacheWidth = widget.width == null
        ? null
        : (widget.width! * dpr).round();
    final int? memCacheHeight = widget.height == null
        ? null
        : (widget.height! * dpr).round();

    return ClipRRect(
      borderRadius: borderRadius,
      child: Semantics(
        image: true,
        label: widget.semanticLabel,
        child: CachedNetworkImage(
          key: ValueKey(_retryCount),
          imageUrl: resolved,
          cacheKey: widget.cacheKey,
          width: widget.width,
          height: widget.height,
          fit: widget.fit,
          memCacheWidth: memCacheWidth,
          memCacheHeight: memCacheHeight,
          fadeInDuration: Duration.zero,
          placeholderFadeInDuration: Duration.zero,
          placeholder: (context, _) => _skeleton(),
          errorWidget: (context, _, _) =>
              _errorBox(scheme, onRetry: () => setState(() => _retryCount++)),
        ),
      ),
    );
  }

  Widget _errorBox(ColorScheme scheme, {VoidCallback? onRetry}) => ColoredBox(
    color: scheme.surfaceContainerHighest,
    child: Center(
      child: GestureDetector(
        onTap: onRetry,
        child: Icon(
          Icons.broken_image_outlined,
          color: scheme.onSurfaceVariant,
        ),
      ),
    ),
  );

  Widget _skeleton() => Skeletonizer(
    enabled: true,
    child: LayoutBuilder(
      builder: (context, constraints) => Bone(
        width: constraints.hasBoundedWidth
            ? constraints.maxWidth
            : widget.width ?? 74,
        height: constraints.hasBoundedHeight
            ? constraints.maxHeight
            : widget.height ?? 74,
        borderRadius: BorderRadius.circular(widget.radius),
      ),
    ),
  );
}
