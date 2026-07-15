import 'package:app/core/constants/sizes.dart';
import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/widgets/image/image_svg.dart';
import 'package:flutter/material.dart';

class SvgPrefixIcon extends StatelessWidget {
  const SvgPrefixIcon({super.key, required this.img, this.size, this.color});

  final String img;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 1,
      child: Padding(
        padding: const EdgeInsetsDirectional.only(
          start: Insets.medium,
          end: Insets.extraSmall,
        ),
        child: SizedBox(
          width: size ?? 24,
          height: size ?? 24,
          child: ImageSvg(
            img: img,
            color: color ?? context.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
