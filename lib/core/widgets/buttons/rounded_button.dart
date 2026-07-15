import 'package:app/core/constants/sizes.dart';
import 'package:app/core/extensions/theme_extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    this.size,
    this.backgroundColor,
    this.iconColor,
    this.svgPath,
    this.icon,
    this.iconSize,
    this.hasBadge = false,
    this.count,
    required this.onTap,
  });
  final double? size;
  final double? iconSize;
  final Color? backgroundColor;
  final Color? iconColor;
  final String? svgPath;
  final IconData? icon;
  final bool hasBadge;
  final int? count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final badgeColor = hasBadge
        ? context.colorScheme.primary
        : Colors.transparent;

    final Widget child = svgPath != null
        ? SvgPicture.asset(
            svgPath!,
            height: iconSize,
            width: iconSize,
            colorFilter: iconColor == null
                ? null
                : ColorFilter.mode(iconColor!, BlendMode.srcIn),
          )
        : Icon(
            icon!,
            color: iconColor ?? context.colorScheme.onPrimary,
            size: iconSize ?? IconSize.small,
          );

    return SizedBox.fromSize(
      size: Size(size ?? 56, size ?? 56),
      child: ClipOval(
        child: Material(
          color: backgroundColor ?? context.colorScheme.primary,
          child: InkWell(
            onTap: onTap,
            child: Center(
              child: count != null
                  ? Badge.count(
                      count: count!,
                      alignment: Alignment.topLeft,
                      backgroundColor: badgeColor,
                      child: child,
                    )
                  : Badge(
                      alignment: Alignment.topRight,
                      smallSize: 10,
                      backgroundColor: badgeColor,
                      child: child,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
