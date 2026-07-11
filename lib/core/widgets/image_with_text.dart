import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/theme/sizes.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ImageWithText extends StatelessWidget {
  const ImageWithText(
      {super.key, required this.imagePath, required this.text, this.textColor, this.fontSize = 14, this.fontWeight = FontWeight.w400});

  final String imagePath, text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, fit: BoxFit.contain),
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
