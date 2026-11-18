import 'dart:async';

import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// "Resend code in 00:45", one step per [Time.tick]; then the Resend
/// button fades in. [availableAt] comes from the server when it says
/// (`resend_available_in` / `retry_after`), else now +
/// [OtpField.resendCooldown].
class ResendCountdown extends HookWidget {
  const ResendCountdown({
    super.key,
    required this.availableAt,
    required this.enabled,
    required this.onResend,
  });

  final DateTime? availableAt;
  final bool enabled;
  final VoidCallback onResend;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final secondary = context.colorScheme.onSurfaceVariant;
    final t = context.textTheme;
    final now = useState(DateTime.now());
    useEffect(() {
      final timer = Timer.periodic(
        Time.tick,
        (_) => now.value = DateTime.now(),
      );
      return timer.cancel;
    }, const []);

    final left = availableAt?.difference(now.value) ?? Duration.zero;
    final waiting = left > Duration.zero;
    final seconds = waiting ? left.inSeconds + 1 : 0;
    final mmss =
        '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';

    return AnimatedSwitcher(
      duration: context.reduceMotion ? Time.none : Time.small,
      child: waiting
          // Wraps rather than overflows with large text (130%).
          ? Wrap(
              key: const ValueKey('countdown'),
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: Insets.extraSmall,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: IconSize.small,
                  color: secondary,
                ),
                Text(
                  l10n.otpResendIn,
                  style: t.bodyMedium?.copyWith(color: secondary),
                ),
                Text(
                  mmss,
                  style: t.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                  textDirection: TextDirection.ltr,
                ),
              ],
            )
          : Center(
              key: const ValueKey('resend'),
              child: TextButton.icon(
                icon: const Icon(Icons.refresh),
                label: Text(l10n.otpResend),
                onPressed: enabled ? onResend : null,
              ),
            ),
    );
  }
}
