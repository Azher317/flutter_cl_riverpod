import 'package:app/core/feedback/app_haptics.dart';
import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:app/core/utils/formatters/ascii_digits_formatter.dart';
import 'package:app/core/widgets/animation/field_shake.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// The one-time-code field: [length] cells (6 by default), each empty,
/// active (primary ring + blinking caret), filled (secondary ring) or
/// error (error ring + [FieldShake] + [AppHaptics.error]). One hidden text
/// field does the typing, so paste and the OS one-time-code autofill work.
/// Digits always read left to right, in Arabic too; Arabic-Indic digits are
/// accepted and stored as ASCII.
///
/// A rejected code stays in the cells, in red, until the next keystroke:
/// a digit starts a new code, backspace empties the field, and a pasted or
/// autofilled code replaces it. [onCompleted] fires when the last cell is
/// filled; verify from there (no Confirm tap needed).
class OtpField extends StatefulWidget {
  const OtpField({
    super.key,
    required this.controller,
    this.length = 6,
    this.hasError = false,
    this.errorTrigger = 0,
    this.onCompleted,
    this.onChanged,
    this.enabled = true,
    this.autofocus = true,
  });

  /// Cell width / height.
  static const double cellAspectRatio = 48 / 60;

  /// How long to wait before a new code can be requested when the server
  /// doesn't say ([ResendCountdown.availableAt]).
  static const Duration resendCooldown = Duration(seconds: 45);

  final TextEditingController controller;
  final int length;
  final bool hasError;

  /// Bump on each wrong code: shakes the cells and plays
  /// [AppHaptics.error] (even under reduced motion, where the shake is
  /// skipped).
  final int errorTrigger;
  final ValueChanged<String>? onCompleted;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final bool autofocus;

  @override
  State<OtpField> createState() => _OtpFieldState();
}

class _OtpFieldState extends State<OtpField>
    with SingleTickerProviderStateMixin {
  final _focus = FocusNode();
  late final AnimationController _caret = AnimationController(
    vsync: this,
    duration: Time.blink,
  );

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_changed);
    _focus.addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (context.reduceMotion) {
      _caret.value = 0;
    } else if (!_caret.isAnimating) {
      _caret.repeat();
    }
  }

  @override
  void didUpdateWidget(OtpField old) {
    super.didUpdateWidget(old);
    if (widget.errorTrigger != old.errorTrigger && widget.errorTrigger != 0) {
      AppHaptics.error();
    }
  }

  void _changed() {
    if (!mounted) return;
    setState(() {});
    final text = widget.controller.text;
    widget.onChanged?.call(text);
    if (text.length == widget.length) widget.onCompleted?.call(text);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_changed);
    _focus.dispose();
    _caret.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colorScheme;
    final t = context.textTheme;
    final text = widget.controller.text;
    final active = _focus.hasFocus
        ? text.length.clamp(0, widget.length - 1)
        : -1;

    Widget cell(int i) {
      final filled = i < text.length;
      final isActive = i == active && text.length < widget.length;
      final Color border;
      final double width;
      Color fill = c.surfaceContainerLowest;
      if (widget.hasError) {
        border = c.error;
        width = BorderWidth.small;
        fill = c.errorContainer;
      } else if (isActive) {
        border = c.primary;
        width = BorderWidth.small;
      } else if (filled) {
        border = c.secondary;
        width = BorderWidth.small;
      } else {
        border = c.outline;
        width = BorderWidth.extraSmall;
      }
      return Expanded(
        child: AspectRatio(
          aspectRatio: OtpField.cellAspectRatio,
          child: AnimatedContainer(
            duration: Time.extraSmall,
            curve: Motion.standard,
            decoration: BoxDecoration(
              color: fill,
              borderRadius: BorderSize.extraSmallRadius,
              border: Border.all(color: border, width: width),
              boxShadow: isActive && !widget.hasError
                  ? [
                      BoxShadow(
                        spreadRadius: BorderWidth.medium,
                        color: c.primary.withValues(alpha: 0.18),
                      ),
                    ]
                  : null,
            ),
            alignment: Alignment.center,
            child: filled
                ? Text(
                    text[i],
                    style: t.headlineMedium?.copyWith(
                      height: 1,
                      color: widget.hasError ? c.onErrorContainer : null,
                    ),
                  )
                : isActive
                ? FadeTransition(
                    opacity: Tween<double>(begin: 1, end: 0).animate(
                      CurvedAnimation(parent: _caret, curve: Motion.step),
                    ),
                    child: Container(
                      width: BorderWidth.small,
                      height: IconSize.medium,
                      color: c.primary,
                    ),
                  )
                : null,
          ),
        ),
      );
    }

    return FieldShake(
      trigger: widget.errorTrigger,
      child: Semantics(
        textField: true,
        label: context.l10n.otpCodeField,
        value: text,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _focus.requestFocus,
          child: Stack(
            children: [
              // The real input: invisible, on top of the cells, so taps,
              // paste and autofill reach it.
              Positioned.fill(
                child: Opacity(
                  opacity: 0,
                  child: TextField(
                    controller: widget.controller,
                    focusNode: _focus,
                    autofocus: widget.autofocus,
                    enabled: widget.enabled,
                    keyboardType: TextInputType.number,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    showCursor: false,
                    enableInteractiveSelection: false,
                    inputFormatters: [
                      const AsciiDigitsFormatter(),
                      // A rejected code stays in red; the next keystroke
                      // starts over.
                      _StartOverFormatter(() => widget.hasError),
                      LengthLimitingTextInputFormatter(widget.length),
                    ],
                  ),
                ),
              ),
              IgnorePointer(
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Row(
                    spacing: Insets.small,
                    children: [for (var i = 0; i < widget.length; i++) cell(i)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StartOverFormatter extends TextInputFormatter {
  _StartOverFormatter(this.active);

  final bool Function() active;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final before = oldValue.text;
    final after = newValue.text;
    if (!active() || after == before) return newValue;
    // A new code pasted or autofilled over the old one is taken as is.
    if (!after.startsWith(before) && after.length >= before.length) {
      return newValue;
    }
    // A digit typed after the code starts over with it; deleting empties.
    final typed = after.length > before.length
        ? after.substring(before.length)
        : '';
    return TextEditingValue(
      text: typed,
      selection: TextSelection.collapsed(offset: typed.length),
    );
  }
}
