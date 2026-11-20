---
paths:
  - "lib/features/**/presentation/**"
  - "lib/shared/**"
  - "lib/core/layout/**"
  - "lib/core/widgets/layout/**"
---

# Tablets (this app supports them)

`bin/new_app.sh` deletes this file, `lib/core/layout/`, `ContentBox` and
`TwoPane` for phone-only apps.

- **Every plan covers both sizes.** For each screen, say how it looks on a phone
  and on a tablet before writing code.
- **Decide from the window width, never the device:** `context.window.isTablet`,
  `context.window.twoPane`, `context.window.columns(...)`.
- **Side margins:** wrap a screen's scroll view in `ContentBox` and use the
  padding it gives (16 on a phone, 24 on a tablet, more past 1040). Never add the
  screen margin again inside it.
- **List and details, form and summary:** `TwoPane`. Below 720 only `start`
  shows, so put the phone layout there.
- **Bottom navigation:** `AppShell` already switches to a side rail from 600.
- **Test overflow at every size:** `testAtScreenSizes(..., tablets: true)` from
  `test/helpers/screen_sizes.dart`.
