import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class DirectionalIcon extends StatelessWidget {
  const DirectionalIcon({
    super.key,
    this.icon,
    this.iconColor,
    required this.iconSize,
    this.svg,
  });

  final IconData? icon;
  final Color? iconColor;
  final double? iconSize;
  final String? svg;

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Directionality.of(context) == TextDirection.ltr
          ? Matrix4.rotationY(3.1416)
          : Matrix4.identity(),
      child: svg != null
          ? SvgPicture.asset(
              svg!,
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
