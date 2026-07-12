# Plan: Unified logging with Talker (final)

> Final revision. Uses the **official** `talker_dio_logger` (no forks).
> Redaction is done by suppressing request/response **bodies on the auth
> endpoint** and hiding the auth header globally.

## Context

The app currently logs through three uncoordinated mechanisms plus a dead dependency:

- `AwesomeDioInterceptor` for HTTP — `lib/core/network/dio_module.dart:107`
- `go_router`'s `debugLogDiagnostics: true` — `lib/router/app_router.dart:24`, **not gated for release**
- Scattered `dart:developer log()` / `debugPrint()` across `main.dart`, `object_preference_provider`, `pagination_controller`, `image_service`, `app_provider_observer`, `auth_session_provider`
- `logger: ^2.0.2` in `pubspec.yaml:22`, **used nowhere**

Concrete problems: full JWT tokens + passwords printed with no redaction; router diagnostics leak into release; a leftover raw-JSON log at `object_preference_provider.dart:42`; a latent bug at `pagination_controller.dart:74` (logs the stale `error` field, not the caught `e`).

**Goal:** consolidate everything behind Talker — one pipeline for HTTP, Riverpod, framework errors, and manual logs — with secret redaction and an on-device log viewer.

---

## Approach

### 1. Dependencies (`pubspec.yaml`)
- **Add:** `talker_flutter`, `talker_dio_logger`, `talker_riverpod_logger` (official packages).
- **Remove:** `logger` (dead), `awesome_dio_interceptor` (replaced).
- ⚠️ **Compatibility check first:** project is on `flutter_riverpod: ^3.0.0`. Run `flutter pub add` and confirm `talker_riverpod_logger` resolves against Riverpod 3.x. If not, keep `AppProviderObserver` (step 4b) and skip only that package.

### 2. Central Talker instance — new `lib/core/observability/app_logger.dart`
- Expose a global `final talker = TalkerFlutter.init(...)` singleton (needed by call sites without a `ref`, e.g. `PagingControllerX`).
- **Recommended:** also expose a thin `AppLogger` interface with talker inside it; have manual call sites (step 7) use `AppLogger` rather than `talker.*` directly, so a future crash-reporter swap is one file. The dio logger and riverpod observer can take the raw `Talker` (edge/detail code).
- Configure `TalkerSettings`: verbose only in `kDebugMode`; keep error/severe always on so release crashes are still captured.

### 3. HTTP — `lib/core/network/dio_module.dart`

Replace `AwesomeDioInterceptor()` (line 107) with `TalkerDioLogger`. Redaction with the official package (which offers only `hiddenHeaders` + boolean `requestFilter`/`responseFilter`):

- **Authorization header** → `hiddenHeaders: {'authorization'}` (lowercase key, regardless of how `Authenticator` casts it).
- **Password (login request body) + token (login response body)** → suppress the whole body **only on the auth endpoint** via the filters. Normal calls keep their bodies.

```dart
bool _isAuthPath(String path) => path.contains('/auth'); // match ApiDocument login path

if (kDebugMode) {
  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: TalkerDioLoggerSettings(
        hiddenHeaders: {'authorization'},
        printRequestHeaders: true,
        printResponseHeaders: true,
        requestFilter: (options) => !_isAuthPath(options.path),
        responseFilter: (response) =>
            !_isAuthPath(response.requestOptions.path),
      ),
    ),
  );
}
```

> Tradeoff accepted: this drops the *entire* auth request/response body, not just the secret field. Status codes still show, which is what you usually need. If you later miss auth bodies, revisit `talker_dio_logger_plus` for field-level masking.

⚠️ **Confirm the real login path** in `ApiDocument` so `_isAuthPath` matches it. A typo here silently leaks the token.

Also in this file:
- Replace the two `debugPrint`s in the error branch (lines 58, 61) with the logger.
- **`reject`-branch gap:** the dio logger is added last, so it only logs errors that reach it via `handler.next(e)`. The `unknown` branch does `handler.reject(...)` and returns, short-circuiting the chain — so `FormatException`/parse failures never log. Add `talker.handle(e, st)` inside that branch **before** rejecting.

### 4. Riverpod observer + framework errors — `main.dart` + `app_provider_observer.dart`
- **4a (preferred):** add `TalkerRiverpodObserver(talker: talker, settings: ...)` to `ProviderScope.observers` (`main.dart:51`). Configure settings to **log failures only** — the default floods on every provider add/update/dispose.
- **4b (fallback if 3.0 incompat):** keep `AppProviderObserver`, change its body to `talker.handle(error, stackTrace, ...)`.
- Route the three framework hooks in `main.dart` (`FlutterError.onError`, `PlatformDispatcher.instance.onError`, the `runZonedGuarded` catch) through `talker.handle(...)` so all uncaught errors land in one timeline.

### 5. Router diagnostics — `lib/router/app_router.dart:24`
- `debugLogDiagnostics: kDebugMode`.

### 6. In-app log viewer
- Add a **debug-only** `/logs` route to `TalkerScreen(talker: talker)`.
- **Guard exemption:** the router `redirect` bounces signed-out users to `/login`, so a debug tester can't reach `/logs`. Add at the top of `redirect`:
  ```dart
  if (kDebugMode && state.matchedLocation == '/logs') return null;
  ```
- Optionally add a discreet debug entry point to reach it.

### 7. Migrate remaining call sites + cleanups
Replace `log` / `debugPrint` with the appropriate level (via `AppLogger` if using step 2's wrapper):
- `object_preference_provider.dart` — catch logs at lines 33, 46, 84, 98 → error. **Delete the stray `log(raw.toString())` at line 42.** Note: this mixin is generic over `State`, so it can dump *any* stored object type, not just themeMode.
- `pagination_controller.dart:74` — switch to `handle`, and **fix the bug**: pass the caught `e`, not the stale `error` field.
- `image_service.dart:37` → error.
- `auth_session_provider.dart:36` → warning/error.

---

## Why redaction matters

Logs are plaintext, persist in Talker's in-memory history, and the share button can send them out by email/Slack. **Anything that lets someone impersonate the user must never touch a log:**
- **Password** — the user's actual secret, often reused elsewhere.
- **JWT token** — a bearer credential; possession *is* authentication until expiry. Most-forgotten one.
- **Authorization header** — carries that credential on *every* authed request, not just login.

Redaction must cover the **history and share output**, not just the console.

---

## Verification
1. `flutter pub get` resolves; confirm `talker_riverpod_logger` picks a Riverpod-3 version (else fallback 4b).
2. `dart run build_runner build --delete-conflicting-outputs` succeeds (dio provider uses codegen).
3. `flutter analyze` clean; `grep -rn "awesome_dio_interceptor\|package:logger" lib/` returns nothing.
4. Run the login flow, check console **and** `TalkerScreen`:
   - Authorization header hidden everywhere; auth request/response **bodies not printed**; normal calls still show bodies.
   - `{"themeMode":...}` raw-preference line is **gone**.
   - `[GoRouter]` diagnostics appear in debug only.
5. Force a `FormatException` (malformed response) and a thrown provider — confirm **both** appear once in the timeline with a stack trace (verifies the step-3 `reject`-branch fix).
6. Reach `/logs` while signed out in a debug build (verifies the step-6 guard exemption).
7. Build release — confirm router diagnostics and verbose HTTP logs are suppressed.