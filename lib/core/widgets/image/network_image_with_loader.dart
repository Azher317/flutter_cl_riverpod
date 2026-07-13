//TODO this widget need refactoring

import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/network/api_document.dart';
import 'package:app/core/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class NetworkImageLoader extends StatefulWidget {
  const NetworkImageLoader({
    super.key,
    this.url,
    this.onLoading,
    this.fit,
    this.borderRadius,
    this.height,
    this.width,
    this.expand = false,
    this.onLoadingStateChanged,
    this.onError,
  });

  final String? url;
  final Widget? onLoading;
  final BoxFit? fit;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;

  /// When true and [height]/[width] are null, fills parent (e.g. list cards).
  final bool expand;
  final void Function(bool isLoading)? onLoadingStateChanged;
  final void Function(bool onError)? onError;

  @override
  State<NetworkImageLoader> createState() => _NetworkImageLoaderState();
}

class _NetworkImageLoaderState extends State<NetworkImageLoader> {
  bool _isLoaded = false;
  bool _onError = false;
  String? _listeningUrl;
  ImageStream? _imageStream;
  ImageStreamListener? _streamListener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _attachStreamIfNeeded();
  }

  @override
  void didUpdateWidget(NetworkImageLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _detachStream();
      _attachStreamIfNeeded();
    }
  }

  void _attachStreamIfNeeded() {
    final resolved = ApiDocument.resolveMediaPath(widget.url);
    if (resolved == _listeningUrl && _imageStream != null) return;

    _detachStream();
    _listeningUrl = resolved;

    if (resolved == null) {
      widget.onLoadingStateChanged?.call(false);
      widget.onError?.call(true);
      if (mounted) {
        setState(() {
          _isLoaded = false;
          _onError = true;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLoaded = false;
        _onError = false;
      });
    }

    widget.onLoadingStateChanged?.call(true);

    final provider = NetworkImage(resolved);
    final stream = provider.resolve(createLocalImageConfiguration(context));
    _streamListener = ImageStreamListener(
      (ImageInfo image, bool synchronousCall) {
        if (!mounted) return;
        setState(() => _isLoaded = true);
        widget.onLoadingStateChanged?.call(false);
      },
      onError: (Object error, StackTrace? stackTrace) {
        widget.onError?.call(true);
        if (!mounted) return;
        setState(() {
          _isLoaded = false;
          _onError = true;
        });
        widget.onLoadingStateChanged?.call(false);
      },
    );
    stream.addListener(_streamListener!);
    _imageStream = stream;
  }

  void _detachStream() {
    if (_imageStream != null && _streamListener != null) {
      _imageStream!.removeListener(_streamListener!);
    }
    _imageStream = null;
    _streamListener = null;
  }

  @override
  void dispose() {
    _detachStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = context.colorScheme;
    final resolved = ApiDocument.resolveMediaPath(widget.url);

    final h = widget.height;
    final w = widget.width;
    final useExpand = widget.expand && h == null && w == null;

    final box = Container(
      height: h ?? (useExpand ? null : 74),
      width: w ?? (useExpand ? null : 74),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: widget.borderRadius ?? BorderSize.fullRadius,
      ),
      clipBehavior: Clip.antiAlias,
      child: _buildChild(context, scheme, resolved, useExpand),
    );

    if (useExpand) {
      return SizedBox.expand(child: box);
    }
    return box;
  }

  Widget _buildChild(
    BuildContext context,
    ColorScheme scheme,
    String? resolved,
    bool useExpand,
  ) {
    if (resolved != null && _isLoaded && !_onError) {
      return ClipRRect(
        borderRadius: widget.borderRadius ?? BorderSize.fullRadius,
        child: Image.network(
          resolved,
          fit: widget.fit ?? BoxFit.cover,
          height: useExpand ? double.infinity : widget.height,
          width: useExpand ? double.infinity : widget.width,
        ),
      );
    }

    if (_onError || resolved == null) {
      return ColoredBox(
        color: scheme.surfaceContainerHighest,
        child: Icon(
          Icons.image_not_supported_outlined,
          color: scheme.onSurfaceVariant,
        ),
      );
    }

    return Skeletonizer(
      enabled: true,
      child:
          widget.onLoading ??
          LayoutBuilder(
            builder: (context, constraints) {
              return Bone(
                width: constraints.hasBoundedWidth
                    ? constraints.maxWidth
                    : widget.width ?? 74,
                height: constraints.hasBoundedHeight
                    ? constraints.maxHeight
                    : widget.height ?? 74,
                borderRadius: widget.borderRadius ?? BorderSize.smallRadius,
              );
            },
          ),
    );
  }
}

/// Small avatar / thumbnail with rounded corners (legacy API).
class NetworkImageWithLoader extends StatelessWidget {
  const NetworkImageWithLoader(
    this.src, {
    super.key,
    this.fit = BoxFit.cover,
    this.radius = BorderSize.small,
  });

  final String src;
  final BoxFit fit;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return NetworkImageLoader(
      url: src,
      fit: fit,
      borderRadius: BorderRadius.all(Radius.circular(radius)),
    );
  }
}

/// Full-bleed image for cards and stacks; uses [NetworkImageLoader] + skeleton.
class CachedNetworkCover extends StatelessWidget {
  const CachedNetworkCover({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  final String imageUrl;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return NetworkImageLoader(
      url: imageUrl,
      fit: fit,

      expand: true,
      borderRadius: borderRadius ?? BorderRadius.zero,
    );
  }
}
