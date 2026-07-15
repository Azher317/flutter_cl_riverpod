import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class ImageSvg extends StatelessWidget {
  final String img;
  final double? size;
  final double? height;
  final double? width;
  final Color? color;
  final double borderRadius;
  final BoxFit fit;

  const ImageSvg({
    required this.img,
    this.height,
    this.size,
    this.borderRadius = 0,
    this.width,
    this.color,
    this.fit =
        BoxFit.contain, // Changed to contain as it's more common for SVGs
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SvgPicture.asset(
        'assets/images/svg/$img.svg',
        height: size ?? height,
        width: size ?? width,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      ),
    );
  }
}
