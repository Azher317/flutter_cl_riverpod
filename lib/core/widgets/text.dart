import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final int? maxChars;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final TextDecoration? decoration;
  final double? height;

  const CustomText(
    this.text, {
    super.key,

    this.style,
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
  ///
  /// Derived from the theme's `bodyMedium` rather than naming a font family, so
  /// the body face follows the active locale (see `AppFontScheme`).
  static TextStyle textStyle(
    BuildContext context, {
    TextStyle? base,
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height = 1,
    TextDecoration? decoration,
  }) {
    final b = base ?? context.textTheme.bodyMedium ?? const TextStyle();

    return b.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
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
        context,
        base: style,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
        height: height,
      ),
    );
  }
}
