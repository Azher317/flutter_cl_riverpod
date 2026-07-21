# Flutter Clean Architecture + Riverpod starter

Clean Architecture (data / domain / presentation) per feature · Riverpod for DI *and* state · go_router · Dio behind a hand-written `ApiConsumer` (no Retrofit) · Freezed + json_serializable · flutter_hooks · a local `Either` (no dartz/fpdart) · Talker for logging.

Architecture, error handling, pagination and lint conventions are documented in [CLAUDE.md](CLAUDE.md).

---

## Setup checklist

Steps **A–E are required** for every new app. **F–H are optional** — do them only if that feature is actually needed.

### A. Clone and detach from the template

```bash
git clone https://github.com/Azher317/flutter_cl_riverpod.git my_app
cd my_app
rm -rf .git build .dart_tool
git init && git add . && git commit -m "chore: init from template"
git remote add origin <your new repo url>
git push -u origin main
```

The clone target (`my_app`) is the project folder name — pick the real one here. Also delete the stale IDE module files: `riverpod_structure.iml` and `android/riverpod_structure_android.iml` (regenerated on next open).

### B. Rename the app

```bash
dart run change_app_package_name:main com.company.myapp    # Android package + kotlin dirs
dart pub global activate rename
dart run rename setBundleId --value com.company.myapp --targets ios,android
dart run rename setAppName  --value "My App"          --targets ios,android
```

Then by hand:

| What | Where |
|---|---|
| `const appName` | [lib/main.dart](lib/main.dart) |
| `description:`, `version:` | [pubspec.yaml](pubspec.yaml) |
| Custom URL scheme (`CFBundleURLName` / `CFBundleURLSchemes`) | [ios/Runner/Info.plist](ios/Runner/Info.plist) — only if you use one |

**Leave `name: app` in pubspec.yaml alone.** Every import in the codebase is `package:app/...` and keeping it means zero churn. Change it only if you also find-and-replace every `package:app/` occurrence.

### C. Dependencies, codegen, lint

```bash
flutter pub get
grep -A4 '^  talker:' pubspec.lock                         # MUST show the git url — see the fork note below
dart run build_runner build --delete-conflicting-outputs   # or: bin/run.sh
dart pub global activate custom_lint && dart run custom_lint
flutter analyze && flutter test
```

Re-run `build_runner` after touching any `@riverpod`, `@freezed`, or `.arb` file. Riverpod lint rules only surface via `dart run custom_lint`, never via `flutter analyze`.

> **Talker fork:** `pubspec.yaml` pins `talker`, `talker_flutter` and `talker_dio_logger` to a patched fork via `dependency_overrides`. All three are required — `talker_flutter`/`talker_dio_logger` depend on `talker: ^5.1.17` from pub.dev rather than their sibling in the fork, so dropping the `talker` override silently pulls in the unpatched core. The fork keeps version `5.1.17`, so `pub get` output and `flutter pub deps` look identical either way; only the lockfile's `url:`/`ref:` proves it. Alternative check: `dart pub deps --json` — `talker`, `talker_flutter` and `talker_dio_logger` must each report `"source": "git"`.

### D. Configure the app

| What | Where |
|---|---|
| API base URL + media URL | [lib/core/network/api_document.dart](lib/core/network/api_document.dart) — **still points at a demo API, change it first** |
| Colors | [lib/core/theme/colors/app_colors.dart](lib/core/theme/colors/app_colors.dart), [color_schemes.dart](lib/core/theme/colors/color_schemes.dart) |
| Fonts | swap `.ttf` files in [assets/fonts/](assets/fonts/), the `fonts:` block in [pubspec.yaml](pubspec.yaml), and the constants in [lib/core/theme/app_fonts.dart](lib/core/theme/app_fonts.dart) — the family names must match character-for-character. The shipped fonts are placeholders. |
| Strings / translations | `.arb` files in [lib/core/l10n/generated/](lib/core/l10n/generated/); missing keys land in `untranslated_messages.txt` |
| Routes | [lib/router/app_router.dart](lib/router/app_router.dart) |
| Images | drop into `assets/images/png/` or `assets/images/svg/`, then `dart run app:gen_assets` to regenerate [lib/core/utils/constants/assets.dart](lib/core/utils/constants/assets.dart) |
| App icon / launch screen | `android/app/src/main/res/mipmap-*`, `ios/Runner/Assets.xcassets` |

### E. Strip the demo content

The template ships a preview home screen so a fresh clone runs. Delete it and its asset:

- [lib/features/home/presentation/screens/home_screen.dart](lib/features/home/presentation/screens/home_screen.dart) — replace with your own screen
- `assets/images/jpeg/monstera.jpeg` and the `- assets/images/jpeg/` line in [pubspec.yaml](pubspec.yaml)

---

### F. Optional — deep links / app links

Deep links let a tapped web URL (`https://myshop.com/order/12`) open your app instead of the browser. **Most apps don't need this.** There is no Dart code involved — go_router picks up incoming URIs automatically once the platform config below is enabled, so turning it on or off is entirely a matter of platform files.

<details>
<summary><b>Not using deep links? Delete these (recommended — leaving them wired to <code>example.com</code> is worse than removing them)</b></summary>

1. **[android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml)** — delete the whole `<!-- Deep linking -->` block: the `flutter_deeplinking_enabled` `<meta-data>` line *and* the `<intent-filter android:autoVerify="false">` that follows it (the one containing the `http`/`https` `<data>` lines). Keep the *first* intent-filter with `MAIN`/`LAUNCHER` — that one is your app's launcher icon.
2. **[ios/Runner/Info.plist](ios/Runner/Info.plist)** — delete the `FlutterDeepLinkingEnabled` key with its `<true/>`, and the `CFBundleURLTypes` key with its whole `<array>…</array>` (that's the custom `starter://` scheme).
3. **Delete the hosting files** at the repo root: `assetslinks.json` and `apple-app-site-association.json`.
4. **Delete `bin/deep_link.sh`** and its line from the *Handy scripts* section below.

Nothing else references them — no imports to fix, no code to touch. Then `flutter run` to confirm the app still launches.

Keep the custom URL scheme (step 2's `CFBundleURLTypes`) only if some other flow relies on it, e.g. an OAuth/payment provider redirecting back to `starter://callback`.

</details>

If you *do* want them, both platforms need the same thing: a file hosted on your domain that names your app.

**Android** — in [android/app/src/main/AndroidManifest.xml](android/app/src/main/AndroidManifest.xml), set your host in the `<!-- Deep linking -->` intent-filter (both `http` and `https`) and flip `android:autoVerify` to `"true"`. Get the signing fingerprint:

```bash
keytool -list -v -alias androiddebugkey -keystore ~/.android/debug.keystore   # debug
keytool -list -v -alias <your-key-name> -keystore <path-to-release-keystore>  # release
```

Put both `SHA256` values and your package name into [assetslinks.json](assetslinks.json), then host it at `https://<host>/.well-known/assetlinks.json` — real HTTPS, `application/json`, no redirects. Guide: [Deploy assetlinks.json in minutes](https://medium.com/androiddevelopers/android-app-links-deploy-assetlinks-json-in-minutes-d7082dffcac).

**iOS** — open `ios/Runner.xcworkspace` in Xcode → Runner target → *Signing & Capabilities* → **+ Capability** → **Associated Domains** → add `applinks:<host>` (this creates `Runner.entitlements`). Put your `TEAMID.bundleid` into [apple-app-site-association.json](apple-app-site-association.json) and host it at `https://<host>/.well-known/apple-app-site-association` (no file extension, `application/json`).

Test an installed build:

```bash
bin/deep_link.sh <host> <application-id>      # e.g. bin/deep_link.sh myshop.com com.company.myapp
```

### G. Optional — release signing (needed to publish on Android)

Release builds currently sign with the **debug** key (see the `buildTypes.release` TODO in [android/app/build.gradle](android/app/build.gradle)) — the Play Store rejects that. Generate an upload keystore and wire up `android/key.properties` following the official guide: <https://docs.flutter.dev/deployment/android>.

### H. Optional — Flutter Web on Google Cloud Storage

Only if assets are served from a GCS bucket:

```bash
gcloud init
gsutil cors set cors.json gs://<your-bucket>
```

---

## Handy scripts

```bash
bin/run.sh                                  # build_runner build --delete-conflicting-outputs
bin/rename.sh <bundle-id> "<App Name>"      # rename bundle id + app name on both platforms
bin/uninstall.sh <application-id>           # remove the app from booted simulator + connected device
bin/deep_link.sh <host> <application-id>    # fire a test deep link at the Android device
dart run app:gen_assets                     # regenerate asset constants
```
