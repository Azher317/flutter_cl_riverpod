import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImageWithText extends StatelessWidget {
  const ImageWithText({
    super.key,
    required this.imagePath,
    required this.text,
    this.textColor,
    this.fontSize = 14,
    this.fontWeight = FontWeight.w400,
    this.imageSize = 120,
  });

  final String imagePath, text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final double imageSize;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context).clamp(1.0, 2.0);
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            fit: BoxFit.contain,
            width: imageSize,
            height: imageSize,
            cacheWidth: (imageSize * dpr).round(),
            cacheHeight: (imageSize * dpr).round(),
          ),
          const Gap(Insets.medium),
          Text(
            text,
            style: context.textTheme.bodyMedium?.copyWith(
              color: textColor ?? context.colorScheme.onSurface,
              fontSize: fontSize,
              fontWeight: fontWeight,
            ),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
