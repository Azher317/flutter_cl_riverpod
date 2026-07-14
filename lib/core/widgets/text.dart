import 'package:app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxChars;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final TextDecoration? decoration;
  final double? height;

  const CustomText({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.maxChars,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.start,
    this.decoration,
    this.height,
  });

  /// Same typography as [CustomText] for [TextField], [InputDecoration.hintStyle], etc.
  static TextStyle textStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height = 1,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontFamily: AppTheme.fontFamily,
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.w500,
      color: color,
      decoration: decoration,
      height: height,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      maxChars != null
          ? text.length > maxChars!
                ? text.substring(0, maxChars)
                : text
          : text,
      textAlign: textAlign,
      textHeightBehavior: const TextHeightBehavior(
        applyHeightToFirstAscent: false,
      ),
      softWrap: true,
      maxLines: maxLines ?? 100,
      overflow: overflow,
      style: CustomText.textStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        height: height,
      ),
    );
  }
}
