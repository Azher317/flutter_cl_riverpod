# Haptics

The single source of truth for vibration feedback. Code:
[lib/core/feedback/app_haptics.dart](../lib/core/feedback/app_haptics.dart).

## The rule

A haptic **confirms something the user can also see**. It is never decoration, never the
only signal, and never repeated for the same thing. If you're unsure whether something
deserves one, it doesn't.

- Call `AppHaptics.selection()` / `.light()` / `.success()` / `.error()`. **Never** call
  `HapticFeedback.*` or a vibration plugin directly; `bin/check_arch.sh` fails the build
  if you do.
- Each kind has **one meaning** across the whole app (table below). Don't pick a kind
  because it "feels stronger".
- Play it **once, at the moment the state changes**, from the place that changes it
  (the widget's `onChanged`, or right after the notifier returns a result). Not in
  `build`, not on every rebuild, not on both tap-down and tap-up.
- There is **no in-app setting**: the phone's System Haptics / Touch feedback switch
  decides. Reduce motion does **not** silence haptics (they help users who can't rely
  on motion).
- The same kind within `Time.hapticGap` (100 ms) is dropped automatically, so fast
  repeated taps don't buzz continuously.

## Which kind, when

| Kind | Means | Use it for | Already wired |
|---|---|---|---|
| `selection` | A choice changed | Tab / segment / chip / radio / switch changed; stepper +/−; picker value snapped; theme or language picked | `ref.changeThemeMode`, `ref.changeLocale` |
| `light` | Something was added or saved | Favourite toggled on, added to cart, item saved, pull-to-refresh triggered | — |
| `success` | A flow finished well | Signed in, order placed, payment done, form submitted and accepted | — |
| `error` | The user's own input was rejected | Wrong OTP, form submitted with invalid fields, a limit reached (max quantity) | `OtpField` on each wrong code; login submit with invalid fields |

## Never vibrate for

- Plain button taps, list-row taps, navigation (push/pop/back). The pressed state and the
  transition are the feedback.
- Opening or closing sheets and dialogs.
- Scrolling, page swipes, pull-to-refresh *progress* (only the trigger moment).
- Network / server errors, timeouts, "no connection". The user did nothing wrong; show
  the message only.
- Anything that happens without the user acting: push notifications arriving, timers
  ending, background refresh, the system theme changing.
- Every keystroke in a text field.
- Success for routine saves that happen constantly (auto-save, settings toggles: those
  are `selection`).

## Adding a new kind

Don't, unless a new *meaning* appears that none of the four covers. If it does: add it to
`HapticKind` with a one-line meaning, map it in `_play`, add a row to the table above and
a test in `test/core/feedback/app_haptics_test.dart`.

## Testing

`recordHaptics(tester)` ([test/helpers/haptics.dart](../test/helpers/haptics.dart))
records every haptic sent and fails on any that isn't one of the four kinds:

```dart
final haptics = recordHaptics(tester);
await tester.tap(find.text('Add'));
expect(haptics, [HapticKind.light]);
```
