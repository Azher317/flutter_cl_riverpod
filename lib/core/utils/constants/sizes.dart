import 'dart:math' as math;

import 'package:flutter/material.dart';

class IconSize {
  const IconSize._();

  static const double extraSmall = 8.0;
  static const double small = 16.0;
  static const double medium = 24.0;
  static const double large = 32.0;
  static const double extraLarge = 48.0;
}

class BorderSize {
  const BorderSize._();

  static const double none = 0;
  static const double xxs = 4.0;
  static const double extraSmall = 8.0;
  static const double small = 16.0;
  static const double medium = 24.0;
  static const double large = 32.0;
  static const double extraLarge = 48.0;
  static const double full = 100.0;

  static const BorderRadius noneRadius = BorderRadius.all(
    Radius.circular(none),
  );
  static const BorderRadius xxsRadius = BorderRadius.all(Radius.circular(xxs));
  static const BorderRadius extraSmallRadius = BorderRadius.all(
    Radius.circular(extraSmall),
  );
  static const BorderRadius smallRadius = BorderRadius.all(
    Radius.circular(small),
  );
  static const BorderRadius mediumRadius = BorderRadius.all(
    Radius.circular(medium),
  );
  static const BorderRadius largeRadius = BorderRadius.all(
    Radius.circular(large),
  );
  static const BorderRadius extraLargeRadius = BorderRadius.all(
    Radius.circular(extraLarge),
  );
  static const BorderRadius fullRadius = BorderRadius.all(
    Radius.circular(full),
  );
}

class Insets {
  const Insets._();

  static const double none = 0.0;
  static const double extraSmall = 4.0;
  static const double small = 8.0;
  static const double medium = 16.0;
  static const double large = 24.0;
  static const double extraLarge = 32.0;

  static const EdgeInsets noneAll = EdgeInsets.all(none);
  static const EdgeInsets extraSmallAll = EdgeInsets.all(extraSmall);
  static const EdgeInsets smallAll = EdgeInsets.all(small);
  static const EdgeInsets mediumAll = EdgeInsets.all(medium);
  static const EdgeInsets largeAll = EdgeInsets.all(large);
  static const EdgeInsets extraLargeAll = EdgeInsets.all(extraLarge);
}

class BorderWidth {
  const BorderWidth._();

  static const double none = 0.0;
  static const double extraSmall = 1.0;
  static const double small = 2.0;
  static const double medium = 4.0;
  static const double large = 8.0;
  static const double extraLarge = 16.0;
}

class Time {
  const Time._();

  static const Duration none = Duration.zero;
  static const Duration extraSmall = Duration(milliseconds: 100);
  static const Duration small = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 500);
  static const Duration large = Duration(milliseconds: 700);
  static const Duration extraLarge = Duration(seconds: 1);

  /// The theme / language circular reveal ([ThemeRevealHost]).
  static const Duration reveal = Duration(milliseconds: 700);

  /// Sheets slide up over this…
  static const Duration sheetEnter = Duration(milliseconds: 350);

  /// …and down over this.
  static const Duration sheetExit = Duration(milliseconds: 250);

  /// Content entering ([StaggeredEnter]).
  static const Duration enter = Duration(milliseconds: 300);

  /// The delay between two staggered items.
  static const Duration stagger = Duration(milliseconds: 50);

  /// One loop of the skeleton shimmer.
  static const Duration shimmer = Duration(milliseconds: 1200);

  /// The in-app splash stays at least this long, so it never flickers.
  static const Duration splashMinimum = Duration(milliseconds: 600);

  /// The splash's exit over the first screen.
  static const Duration splashExit = Duration(milliseconds: 400);

  /// Page push / pop ([FadeThroughPage]).
  static const Duration page = Duration(milliseconds: 300);

  /// A field's error shake ([FieldShake]).
  static const Duration shake = Duration(milliseconds: 350);

  /// The OTP caret blink period.
  static const Duration blink = Duration(seconds: 1);

  /// One step of a countdown (resend code).
  static const Duration tick = Duration(seconds: 1);

  /// The shortest gap between two haptics of the same kind ([AppHaptics]),
  /// so fast repeated taps don't stack.
  static const Duration hapticGap = Duration(milliseconds: 100);
}

/// Curves and motion constants. Pair a curve with a [Time]; never write a
/// `Cubic` inline in a widget.
class Motion {
  const Motion._();

  static const Curve standard = Easing.standard;

  /// Entering: sheets, dialogs, snackbars.
  static const Curve emphasizedDecelerate = Easing.emphasizedDecelerate;

  /// Leaving.
  static const Curve emphasizedAccelerate = Easing.emphasizedAccelerate;
  static const Curve linear = Curves.linear;

  /// A hard on/off step (the OTP caret blink).
  static const Curve step = Threshold(0.5);

  /// How far the screen behind an open bottom sheet leans back (3°, in
  /// radians): its bottom edge recedes, the top edge stays.
  static const double sheetLeanTilt = 3 * math.pi / 180;

  /// The perspective depth of that lean (the `Matrix4` w-per-z entry).
  static const double sheetLeanPerspective = 0.001;
}

/// Fixed layout measures.
class Layout {
  const Layout._();

  /// A window at least this wide is laid out as a tablet: sheets don't
  /// lean the screen behind them there.
  static const double tabletBreakpoint = 600;

  /// The splash logo, in the native splash and the in-app splash alike.
  static const double splashLogoSize = 120;
}
