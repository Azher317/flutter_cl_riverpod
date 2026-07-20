import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/widgets/column_padded.dart';
import 'package:app/core/widgets/controlled_height_screen.dart';
import 'package:flutter/material.dart';

/// Scaffold body for a scrollable form screen.
///
/// Wrap form fields in [children] and buttons in [actions]; give it your own
/// [formKey] to validate/save. Tapping outside a field dismisses the keyboard.
/// Use as the `body:` of a Scaffold, e.g. on the login/signup screens.
///
/// ```dart
/// FormBody(
///   formKey: _formKey,
///   children: [emailField, passwordField],
///   actions: [submitButton],
/// )
/// ```
class FormBody extends StatelessWidget {
  const FormBody({
    super.key,
    required this.formKey,
    required this.children,
    this.centered = false,
    this.actions = const [],
    this.spacing,
    this.safeArea = true,
    this.padding = const EdgeInsets.all(16.0),
    this.mainAxisAlign = MainAxisAlignment.center,
    this.crossAxisAlign = CrossAxisAlignment.stretch,
    this.mainAxisSize = MainAxisSize.min,
    this.autovalidateMode,
  });

  /// Form fields, stacked vertically with [gap] between them.
  final List<Widget> children;

  /// Buttons pinned to the bottom; each is Expanded to share the row width.
  /// Empty = no bottom bar.
  final List<Widget> actions;

  /// Padding around [children] (not the [actions] bar, which has its own 16px).
  final EdgeInsets padding;

  /// Vertical spacing between [children].
  final double? spacing;

  /// Your Form key — used to validate()/save() the fields.
  final GlobalKey<FormState> formKey;

  /// Vertical alignment of [children] within the scroll view.
  final MainAxisAlignment mainAxisAlign;

  /// Horizontal alignment of [children] (default: stretch to full width).
  final CrossAxisAlignment crossAxisAlign;

  final MainAxisSize mainAxisSize;

  /// Vertically center [children] in the viewport (good for short login forms).
  final bool centered;

  /// Wrap in SafeArea to avoid notches/system bars.
  final bool safeArea;

  /// When to auto-run validators (e.g. onUserInteraction). Null = manual only.
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    // Scrollable fields column (keyboard/overflow safe).
    Widget current = ControlledHeightScreen(
      padding: padding,
      child: ColumnPadded(
        spacing: spacing ?? Insets.medium,
        mainAxisAlignment: mainAxisAlign,
        crossAxisAlignment: crossAxisAlign,
        mainAxisSize: mainAxisSize,
        children: children,
      ),
    );
    // Vertically center the scroll content when asked.
    current = GestureDetector(
      behavior: HitTestBehavior.opaque,
      // Tap-outside dismisses the keyboard.
      onTap: FocusScope.of(context).unfocus,
      child: Form(
        key: formKey,
        autovalidateMode: autovalidateMode,
        // No actions → fields only. Otherwise fields fill the space and
        // the actions row is pinned at the bottom.
        child: actions.isEmpty
            ? current
            : Column(
                children: [
                  Expanded(child: current),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      spacing: Insets.small,
                      children: [
                        // Actions share the row width equally.
                        for (final action in actions) Expanded(child: action),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );

    if (safeArea) current = SafeArea(child: current);

    return current;
  }
}
