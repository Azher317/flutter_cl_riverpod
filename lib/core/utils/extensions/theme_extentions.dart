import 'package:app/core/theme/extra_colors.dart';
import 'package:flutter/material.dart';

extension ThemeExtension on BuildContext {
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;

  TextTheme get textTheme => theme.textTheme;

  AppStatusColors get appStatusColors => theme.appStatusColors;
}
