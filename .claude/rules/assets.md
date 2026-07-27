---
paths:
  - "assets/**"
  - "lib/core/utils/constants/assets.dart"
---

# Assets

Images live in `assets/images/png/` and `assets/images/svg/` and are referenced
through generated constants in
[assets.dart](../../lib/core/utils/constants/assets.dart) (produced by the standalone
[bin/gen_assets.dart](../../bin/gen_assets.dart), not `flutter_gen_runner`). Constants hold
the **bare filename only**; the widgets add directory and extension.

```dart
ImageSvg(img: SvgAssets.search01, color: context.colorScheme.primary)
ImagePng(img: PngAssets.someImage)
```

Regenerate after adding, renaming, or removing an asset:

```bash
dart run app:gen_assets
```

Non-ASCII filenames (e.g. Arabic) are skipped by the generator — reference those
with raw strings. `assets.dart` is committed.
