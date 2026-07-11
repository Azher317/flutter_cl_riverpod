import 'package:app/core/theme/sizes.dart';
import 'package:app/core/extensions/theme_extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SvgPrefixIcon extends StatelessWidget {
  const SvgPrefixIcon({super.key, required this.svg, this.size, this.color});

  final String svg;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Center(
      widthFactor: 1,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          start: Insets.medium,
          end: Insets.extraSmall,
        ),
        child: SizedBox(
          width: size ?? 24,
          height: size ?? 24,
          child: SvgPicture.asset(
            svg,
            fit: BoxFit.contain,
            color: color ?? context.colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
