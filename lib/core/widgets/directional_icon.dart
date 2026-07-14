import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/constants/sizes.dart';
import 'package:app/core/widgets/image/image_svg.dart';
import 'package:flutter/material.dart';

class DirectionalIcon extends StatelessWidget {
  const DirectionalIcon({
    super.key,
    this.icon,
    this.iconColor,
    required this.iconSize,
    this.img,
  });

  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final String? img;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Directionality.of(context) == TextDirection.ltr
          ? Matrix4.rotationY(3.1416)
          : Matrix4.identity(),
      child: img != null
          ? ImageSvg(
              img: img!,
              height: iconSize,
              width: iconSize,
              color: iconColor ?? context.colorScheme.primary,
            )
          : Icon(
              icon!,
              color: iconColor ?? context.colorScheme.onPrimary,
              size: iconSize ?? IconSize.large,
            ),
    );
  }
}
