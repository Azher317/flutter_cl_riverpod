# Graph Report - flutter_cl_riverpod  (2026-09-30)

## Corpus Check
- 225 files · ~73,197 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2256 nodes · 2732 edges · 179 communities (113 shown, 66 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 29 edges (avg confidence: 0.77)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `9705794e`
- Run `git rev-parse HEAD` and compare to check if the graph is stale.
- Run `graphify update .` after code changes (no API cost).

## Community Hubs (Navigation)
- Kurdish Material Localizations
- App Localizations (AR+EN)
- App Localizations (English)
- App Localizations (Arabic)
- Windows Runner Plugins (C++)
- API Consumer & Dio Exceptions
- Kurdish Cupertino Localizations
- API Headers
- macOS Runner Plugins
- Session Controller
- Phone Number Model
- Architecture Invariants
- Form State & Layout
- App Settings Provider
- Sizing & Border Tokens
- Component Themes
- Linux Runner (GTK)
- SafeRepositoryCall & UseCase
- Kurdish Widget Localizations
- Break Line Widget
- Custom Text Form Field
- App Messenger / Snackbar
- Localization Extensions
- Session Cache Model
- Login Request Model
- User Model
- Home Screen
- Network DI Providers
- Pagination Controller Hook
- Session Repository
- Custom Text Widget
- Auth Remote Data Source
- Asset Generation Script
- App Entry (main)
- Custom Date Picker Field
- Default Error Widget
- Custom App Bar
- Cached Image
- App Root Widget
- Shared Widgets Catalogue
- Password Text Form Field
- Form Validator Locale
- Login Screen
- Secure Storage Provider
- Filled Loading Button
- Api Document Config
- App Theme
- Shared Preferences Provider
- Dio Module & Logout
- Image Form Field
- Custom Dropdown Button
- Image PNG Widget
- Default Response Model
- Image SVG Widget
- Windows Native (C++)
- Failure Types
- Login Notifier
- Status Colors Extension
- Rounded Button
- Object Preference Provider
- App Router
- Dio Authenticator Interceptor
- Paginated Bottom Sheet
- Auth Providers & Usecases
- Web Manifest
- package:freezed_annotation/freezed_annotation.dart
- Account Avatar
- Paginated Response Model
- Paginated Dropdown Field
- Phone Number Form Field
- Theme Extensions
- Auth Session Entity
- route_names.dart
- Paginated State
- App Logger
- User Entity
- Custom Modal Bottom Sheet
- Freezed Models
- Pagination Hooks
- App Colors
- Color Schemes
- package:app/core/observability/app_logger.dart
- package:flutter/foundation.dart
- Debounced Search Hook
- break_line.dart
- nullable_uri_convertor.dart
- rounded_button.dart
- user_entity.dart
- Network Converters Barrel
- Nullable DateTime Converter
- route_names.dart
- package:app/core/utils/extensions/common_extensions.dart
- Nullable URI Converter
- App Text Theme
- Login Params
- check_arch.sh (CI arch gate)
- export.sh script
- Avatar Image Composition
- jsonSerializable
- setup-hooks.sh
- Annotations Barrel
- Assets Rule
- deep_link.sh script
- rename.sh script
- run.sh script
- uninstall.sh script
- SVG Prefix Icon
- pre-commit
- Kurdish Material Delegate (impl)
- json_serializable.dart
- String Extensions
- app build.gradle
- android build.gradle
- settings.gradle
- Custom App Bar (fn)
- Custom Date Picker
- Custom Dialog
- Custom Time Picker
- Directional Icon
- Image Form Field (widget)
- Image PNG
- Rounded Button (widget)
- iOS Bridging Header
- Generated fromJson
- Generated Member
- Generated build
- Generated fromJson
- Generated toJson
- Generated Member
- Generated build
- Generated Member
- Generated fromJson
- Generated Member
- Generated fromJson
- Generated Member
- Generated build
- sessionControllerProvider
- sessionProvider
- sessionRepositoryProvider
- settingsProvider
- Nullable String Param
- Commands cheatsheet
- AppSettings
- package:app/core/utils/annotations/json_serializable.dart
- LocaleDirectionX
- IraqiPhoneX
- fromJson
- Implementing Flutter Integration Tests
- Implementing Adaptive Layouts
- either.dart
- Analyzing and Fixing Dart Code
- package:flutter/widgets.dart
- architecture-auditor.md
- _
- app_logger.dart
- KurdishCupertinoLocalizationsDelegate
- auth Reference Slice
- Shared Freezed/JsonSerializable Annotation Presets
- KurdishCupertinoLocalizations
- DartProject
- HWND
- LPARAM
- LRESULT
- UINT
- WPARAM
- DartProject
- string
- wchar_t
- HWND
- LPARAM
- LRESULT
- UINT
- wchar_t
- WPARAM
- HWND

## God Nodes (most connected - your core abstractions)
1. `Shared Widgets Catalogue` - 30 edges
2. `Win32Window` - 20 edges
3. `Failure` - 10 edges
4. `Create` - 10 edges
5. `FlutterWindow` - 8 edges
6. `Managing Dart Dependencies` - 8 edges
7. `2. Syntax Reference` - 8 edges
8. `Implementing Flutter Integration Tests` - 8 edges
9. `Implementing Adaptive Layouts` - 8 edges
10. `Setup Checklist (A-H)` - 8 edges

## Surprising Connections (you probably didn't know these)
- `l10n.yaml localization config` --conceptually_related_to--> `Shared Widgets Catalogue`  [INFERRED]
  l10n.yaml → docs/widgets.md
- `_FakeSessionRepository` --implements--> `SessionRepository`  [EXTRACTED]
  test/core/session/session_providers_test.dart → lib/core/session/data/session_repository.dart
- `CI analyze-and-test job` --conceptually_related_to--> `flutter_riverpod dependency`  [INFERRED]
  .github/workflows/ci.yml → pubspec.yaml
- `Talker patched fork dependency_overrides` --conceptually_related_to--> `CI analyze-and-test job`  [INFERRED]
  pubspec.yaml → .github/workflows/ci.yml
- `Untranslated Messages Report` --conceptually_related_to--> `Step E: Strip the Demo Content`  [INFERRED]
  untranslated_messages.txt → README.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Two-Step Error Translation Pipeline** — claude_rules_data_layer_network_error_mapper, claude_rules_data_layer_safe_repository_call, claude_rules_data_layer_failure_messenger, claude_claude_local_either [EXTRACTED 1.00]
- **Session and Networking Token Flow** — claude_rules_session_networking_session, claude_rules_session_networking_session_controller, claude_rules_session_networking_dio_module, claude_rules_routing_router [EXTRACTED 1.00]
- **State UI Presets Pattern** — docs_widgets_statemessage, docs_widgets_emptystate, docs_widgets_defaulterrorwidget [EXTRACTED 1.00]
- **Paginated Picker Sheet Flow** — docs_widgets_custompaginateddropdownformfield, docs_widgets_paginatedbottomsheet, docs_widgets_custommodalbottomsheet [EXTRACTED 1.00]
- **Const-First Lint Enforcement** — analysis_options_const_promotion, analysis_options_strict_language, docs_dart_style_widget_composition [INFERRED 0.75]

## Communities (179 total, 66 thin omitted)

### Community 0 - "Kurdish Material Localizations"
Cohesion: 0.01
Nodes (177): ScriptCategory get, TimeOfDayFormat get, aboutListTileTitleRaw, alertDialogLabel, anteMeridiemAbbreviation, backButtonTooltip, bottomSheetLabel, calendarModeButtonLabel (+169 more)

### Community 1 - "App Localizations (AR+EN)"
Cohesion: 0.02
Nodes (98): app_localizations_ar.dart, app_localizations_en.dart, appName, badRequest, cancel, changeLanguage, conflict, crop (+90 more)

### Community 2 - "App Localizations (English)"
Cohesion: 0.02
Nodes (89): app_localizations.dart, appName, badRequest, cancel, changeLanguage, conflict, crop, darkMode (+81 more)

### Community 3 - "App Localizations (Arabic)"
Cohesion: 0.02
Nodes (88): appName, badRequest, cancel, changeLanguage, conflict, crop, darkMode, defaultErrorMessage (+80 more)

### Community 4 - "Windows Runner Plugins (C++)"
Cohesion: 0.06
Nodes (45): _In_, _In_opt_, PluginRegistry, Point, RECT, Size, unique_ptr, RegisterPlugins() (+37 more)

### Community 5 - "API Consumer & Dio Exceptions"
Cohesion: 0.12
Nodes (16): authRemoteDataSourceProvider, class AuthRemoteDataSourceProvider, package:app/core/network/api_consumer.dart, package:app/core/network/endpoints.dart, package:app/features/auth/data/models/login_request_model.dart, package:app/features/auth/data/models/user_model.dart, _, _api (+8 more)

### Community 6 - "Kurdish Cupertino Localizations"
Cohesion: 0.05
Nodes (34): AlignmentGeometry, BoxFit, package:flutter_svg/svg.dart, TextStyle?, alignment, build, CustomDropdownButtonFormField, fillColor (+26 more)

### Community 7 - "API Headers"
Cohesion: 0.08
Nodes (23): 1. Overview, 2.1 Basic Class Header Syntax, 2.2 Declaring, Initializing, and Plain Parameters, 2.3 Constant Primary Constructors, 2.4 Extension Types, 2.5 Empty Body Semicolon Shorthand (`;`), 2.6 The In-Body Part of a Primary Constructor (`this ...`), 2.7 Abbreviated Concise Constructor Syntax (+15 more)

### Community 8 - "macOS Runner Plugins"
Cohesion: 0.05
Nodes (41): package:flutter_localizations/flutter_localizations.dart, package:intl/date_symbol_data_custom.dart, package:intl/date_symbols.dart, alertDialogLabel, anteMeridiemAbbreviation, backButtonLabel, cancelButtonLabel, clearButtonLabel (+33 more)

### Community 9 - "Session Controller"
Cohesion: 0.05
Nodes (37): @immutable, static const AppFontScheme, static const String, _, accept, acceptLanguage, ApiHeaders, applicationJson (+29 more)

### Community 10 - "Phone Number Model"
Cohesion: 0.06
Nodes (28): Any, Cocoa, file_selector_macos, Flutter, flutter_secure_storage_darwin, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate (+20 more)

### Community 11 - "Architecture Invariants"
Cohesion: 0.06
Nodes (40): Analyzer & Linter Configuration, Const Lint Promotion to Warning, custom_lint Analyzer Plugin, Strict Casts / Inference / Raw Types, Accessibility Guidance, Effective Dart Baseline, Dart & Flutter Style Guide, Overflow-Safe Layout (+32 more)

### Community 12 - "Form State & Layout"
Cohesion: 0.25
Nodes (7): ChangeNotifier, package:flutter/foundation.dart, package:flutter_riverpod/flutter_riverpod.dart, ProviderSubscription, dispose, RouterRefreshNotifier, _sub

### Community 13 - "App Settings Provider"
Cohesion: 0.08
Nodes (32): check_arch.sh CI Boundary Enforcement, Declarative Navigation on Session Change, Layer Rules (Architecture Invariants), Local sealed Either, No Feature Imports Another Feature, Riverpod Provider Naming Rule, Session as Core Concern, Usecase Provider Seam (+24 more)

### Community 14 - "Sizing & Border Tokens"
Cohesion: 0.06
Nodes (32): AutovalidateMode?, CrossAxisAlignment, GlobalKey, MainAxisAlignment, MainAxisSize, package:app/core/widgets/controlled_height_screen.dart, TextBaseline?, TextDirection? (+24 more)

### Community 15 - "Component Themes"
Cohesion: 0.06
Nodes (33): AppSettings, _, AppSettings, build, fromJson, toJson, Locale? get, package:app/core/storage/object_preference_provider.dart (+25 more)

### Community 16 - "Linux Runner (GTK)"
Cohesion: 0.06
Nodes (30): static const double, static const Duration, _, BorderSize, BorderWidth, extraLarge, extraLargeAll, extraLargeRadius (+22 more)

### Community 17 - "SafeRepositoryCall & UseCase"
Cohesion: 0.07
Nodes (27): static const BorderRadius, static const EdgeInsets, _, appBar, AppComponentThemes, _AppShapes, bottomSheet, button (+19 more)

### Community 18 - "Kurdish Widget Localizations"
Cohesion: 0.11
Nodes (17): class _PagingControllerHookState, _PageRequestHandler, appendPageFrom, appendPageFromEither, build, _controller, createState, debugLabel (+9 more)

### Community 19 - "Break Line Widget"
Cohesion: 0.10
Nodes (20): FlPluginRegistry, GApplication, gboolean, gchar, GObject, GtkApplication, MyApplicationClass, fl_register_plugins() (+12 more)

### Community 20 - "Custom Text Form Field"
Cohesion: 0.09
Nodes (21): static const LocalizationsDelegate, TextDirection get, copyButtonLabel, cutButtonLabel, delegate, isSupported, load, lookUpButtonLabel (+13 more)

### Community 21 - "App Messenger / Snackbar"
Cohesion: 0.11
Nodes (22): package:app/core/errors/exceptions.dart, package:app/core/errors/failures.dart, package:app/core/errors/safe_repository_call.dart, package:app/core/session/entities/auth_session_entity.dart, package:app/core/usecase/usecase.dart, package:app/core/utils/either.dart, package:app/features/auth/data/datasources/auth_remote_data_source.dart, package:app/features/auth/domain/params/login_params.dart (+14 more)

### Community 22 - "Localization Extensions"
Cohesion: 0.05
Nodes (41): int? maxLines,, OutlineInputBorder?, package:flutter/services.dart, RegExp, TextInputAction?, TextInputType?, copyWith, countryCode (+33 more)

### Community 23 - "Session Cache Model"
Cohesion: 0.09
Nodes (21): ItemType, package:app/core/utils/extensions/theme_extentions.dart, package:app/core/widgets/state_ui/empty_state.dart, package:app/core/widgets/state_ui/state_message.dart, package:app/core/widgets/text.dart, package:infinite_scroll_pagination/infinite_scroll_pagination.dart, ScaffoldMessengerState, StackTrace (+13 more)

### Community 24 - "Login Request Model"
Cohesion: 0.14
Nodes (13): List, package:app/core/widgets/buttons/filled_loading_button.dart, package:app/core/widgets/column_padded.dart, package:go_router/go_router.dart, build, items, label, LabeledField (+5 more)

### Community 25 - "User Model"
Cohesion: 0.12
Nodes (16): _, fromJson, class, fromEntity, hashCode, identical, null, operator (+8 more)

### Community 26 - "Home Screen"
Cohesion: 0.11
Nodes (19): _, fromJson, _LoginRequestModel, LoginRequestModel, String phoneNumber, String, class, hashCode, identical (+11 more)

### Community 27 - "Network DI Providers"
Cohesion: 0.11
Nodes (18): _, fromJson, _UserModel, UserModel, class, hashCode, identical, null (+10 more)

### Community 28 - "Pagination Controller Hook"
Cohesion: 0.17
Nodes (11): DateTime, package:timeago/timeago.dart, TimeOfDay?, DateTimeX, format, format24Hour, formatDate, formatDOW (+3 more)

### Community 29 - "Session Repository"
Cohesion: 0.13
Nodes (14): class SessionRepositoryProvider, package:app/core/session/data/session_cache_model.dart, package:app/core/storage/secure_storage_provider.dart, package:app/core/storage/storage_keys.dart, _, clear, create, debugGetCreateSourceHash (+6 more)

### Community 30 - "Custom Text Widget"
Cohesion: 0.11
Nodes (17): FontWeight?, TextAlign, TextDecoration?, TextOverflow, build, color, decoration, fontSize (+9 more)

### Community 31 - "Auth Remote Data Source"
Cohesion: 0.13
Nodes (18): build, child, _ComponentGallery, _DetailPreview, _OverlayGallery, room, _RoomCard, _Section (+10 more)

### Community 32 - "Asset Generation Script"
Cohesion: 0.11
Nodes (20): AppLocalizations get, BuildContext, double get, AppLocalizationsExtension, DeviceHeight, DeviceWidth, height, iraqiPhoneNumber (+12 more)

### Community 33 - "App Entry (main)"
Cohesion: 0.12
Nodes (15): 1. Add Dependencies, 1. Run Tests with VM Service, 2. Collect Coverage and Generate LCOV, 2. Collect Raw Coverage, 3. Feedback Loop: Validate Output, 3. Format to LCOV, Contents, Coverage Directives (+7 more)

### Community 34 - "Custom Date Picker Field"
Cohesion: 0.07
Nodes (32): dart:async, DateTime? firstDate,, HookConsumerWidget, package:app/core/utils/extensions/date_time_extensions.dart, package:app/core/widgets/form_fields/custom_text_form_field.dart, package:app/core/widgets/overlay/custom_modal_bottom_sheet.dart, package:app/core/widgets/overlay/paginated_bottom_sheet.dart, package:flutter_hooks/flutter_hooks.dart (+24 more)

### Community 35 - "Default Error Widget"
Cohesion: 0.05
Nodes (46): apiConsumerProvider, dart:io, Dio, Exception, File, MultipartFile, package:app/core/errors/network_error_mapper.dart, package:app/core/network/clients_lib.dart (+38 more)

### Community 36 - "Custom App Bar"
Cohesion: 0.15
Nodes (12): ConsumerWidget, HomeScreen, package:app/core/l10n/generated/app_localizations.dart, package:app/core/l10n/kurdish/kurdish_cupertino_localization_delegate.dart, package:app/core/l10n/kurdish/kurdish_material_localization_delegate.dart, package:app/core/l10n/kurdish/kurdish_widget_localization_delegate.dart, package:app/core/settings/app_settings_provider.dart, package:app/main.dart (+4 more)

### Community 37 - "Cached Image"
Cohesion: 0.07
Nodes (29): FocusNode?, package:cached_network_image/cached_network_image.dart, package:skeletonizer/skeletonizer.dart, State, StatefulWidget, build, CachedImage, _CachedImageState (+21 more)

### Community 38 - "App Root Widget"
Cohesion: 0.18
Nodes (10): Interceptor, Authenticator, onRequest, _ref, DioRefX, package:app/core/network/api_headers.dart, package:app/core/session/session_notifier.dart, Ref (+2 more)

### Community 39 - "Shared Widgets Catalogue"
Cohesion: 0.12
Nodes (15): class FlutterSecureStorageProvider, FlutterSecureStorage, FlutterSecureStorage get, flutterSecureStorageProvider, package:flutter_secure_storage/flutter_secure_storage.dart, _, androidOptions, create (+7 more)

### Community 40 - "Password Text Form Field"
Cohesion: 0.12
Nodes (13): package:flutter/material.dart, static const Color, _, AppColors, brand, info, success, warning (+5 more)

### Community 41 - "Form Validator Locale"
Cohesion: 0.18
Nodes (10): dart:convert, String get, firstBuild, fromJson, jsonDecode, jsonEncode, key, ObjectPreferenceProvider (+2 more)

### Community 42 - "Login Screen"
Cohesion: 0.12
Nodes (15): return, buffer, _collectAssets, dir, main, names, outFile, outputPath (+7 more)

### Community 43 - "Secure Storage Provider"
Cohesion: 0.14
Nodes (12): static const, _, ApiDocument, baseUrl, mediaUrl, resolveMediaPath, calender, cameraplus (+4 more)

### Community 44 - "Filled Loading Button"
Cohesion: 0.18
Nodes (12): package:app/core/theme/app_text_theme.dart, package:app/core/theme/app_theme.dart, package:app/core/theme/colors/color_schemes.dart, package:app/core/theme/component_themes.dart, package:app/core/theme/extra_colors.dart, package:app/core/theme/theme_change.dart, package:app/core/theme/theme_mode.dart, _ (+4 more)

### Community 45 - "Api Document Config"
Cohesion: 0.20
Nodes (9): appName, enableDriverExtension, main, runZonedGuarded, package:app/app.dart, package:app/core/storage/shared_preferences_provider.dart, package:flutter_driver/driver_extension.dart, package:shared_preferences/shared_preferences.dart (+1 more)

### Community 46 - "App Theme"
Cohesion: 0.22
Nodes (8): package:app/core/session/entities/user_entity.dart, AuthSessionEntity, hashCode, operator, token, toString, user, UserEntity

### Community 47 - "Shared Preferences Provider"
Cohesion: 0.14
Nodes (13): FormValidatorLocale, package:flutter/cupertino.dart, AppFormValidatorLocale, context, email, ip, ipv6, maxLength (+5 more)

### Community 48 - "Dio Module & Logout"
Cohesion: 0.14
Nodes (13): CroppedFile?, package:app/core/media/image_service.dart, build, height, hintText, icon, image, ImageFormField (+5 more)

### Community 49 - "Image Form Field"
Cohesion: 0.14
Nodes (13): Algebraic Data Types (Sealed Classes), Contents, Core Pattern Implementations, Examples, Feedback Loop: Exhaustiveness Checking, Guard Clauses and Logical-or, Implementing Dart Patterns, JSON Validation and Destructuring (+5 more)

### Community 50 - "Custom Dropdown Button"
Cohesion: 0.15
Nodes (12): Contents, Core Concepts & Guidelines, Error Handling, Example: Fixing Dynamic List Assignments, Example: Fixing Method Overrides (Contravariance), Example: Fixing Null Safety with `late`, Examples, Null Safety (+4 more)

### Community 51 - "Image PNG Widget"
Cohesion: 0.17
Nodes (11): ThemeData, AppStatusColorsX, copyWith, info, lerp, of, onInfo, onSuccess (+3 more)

### Community 52 - "Default Response Model"
Cohesion: 0.18
Nodes (10): package:app/core/l10n/locale.dart, package:country_code_picker/country_code_picker.dart, package:form_validator/form_validator.dart, build, controller, focusNode, onChanged, onCountryCodeChanged (+2 more)

### Community 53 - "Image SVG Widget"
Cohesion: 0.17
Nodes (12): Step F: Deep Links / App Links, Step A: Clone and Detach from Template, Step H: Flutter Web on Google Cloud Storage, Handy Scripts (bin/), Flutter Clean Architecture + Riverpod Starter, Step G: Release Signing, Step B: Rename the App, Setup Checklist (A-H) (+4 more)

### Community 54 - "Windows Native (C++)"
Cohesion: 0.17
Nodes (11): Contents, Examples, Execution and Profiling, Host Driver Script (`test_driver/integration_test.dart`), Implementing Flutter Integration Tests, Interactive Exploration via MCP, Performance Profiling Driver Script (`test_driver/perf_driver.dart`), Project Setup and Dependencies (+3 more)

### Community 55 - "Failure Types"
Cohesion: 0.22
Nodes (8): createdAt, id, name, operator, phone, profileImg, role, toString

### Community 56 - "Login Notifier"
Cohesion: 0.17
Nodes (11): Basic Preview, Contents, Creating a Widget Preview, Custom Preview with Runtime Transformation, Examples, Handling Limitations, Interacting with Previews, MultiPreview Implementation (+3 more)

### Community 57 - "Status Colors Extension"
Cohesion: 0.29
Nodes (8): Hook, HookState, PagingController, PaginatedExtension, _PagingControllerHook, _PagingControllerHookState, PagingControllerX, PagingListDelegateX

### Community 58 - "Rounded Button"
Cohesion: 0.30
Nodes (11): BadRequestFailure, CacheFailure, ConflictFailure, Failure, ForbiddenFailure, InvalidCredentialsFailure, message, NetworkFailure (+3 more)

### Community 59 - "Object Preference Provider"
Cohesion: 0.25
Nodes (7): package:app/core/utils/hooks/use_debounce.dart, TextEditingController, controller, debounced, DebouncedSearch, useDebouncedSearch, value

### Community 60 - "App Router"
Cohesion: 0.20
Nodes (12): _, @riverpod, dioProvider, isSignedInProvider, dio, sessionProvider, isSignedIn, Session (+4 more)

### Community 61 - "Dio Authenticator Interceptor"
Cohesion: 0.17
Nodes (11): class SharedPreferencesProvider, SharedPreferences, SharedPreferences get, sharedPreferencesProvider, _, create, debugGetCreateSourceHash, extends (+3 more)

### Community 62 - "Paginated Bottom Sheet"
Cohesion: 0.12
Nodes (15): double size,, package:app/core/utils/constants/sizes.dart, package:app/core/widgets/image/cached_image.dart, RouteNames.home, AccountAvatar, build, _cameraPlaceholder, _framed (+7 more)

### Community 63 - "Auth Providers & Usecases"
Cohesion: 0.20
Nodes (9): int?, package:app/core/network/paginated.dart, count, fromJson, pageNumber, pageSize, result, total (+1 more)

### Community 64 - "Web Manifest"
Cohesion: 0.15
Nodes (12): authRepositoryProvider, loginUseCaseProvider, package:app/features/auth/data/repositories/auth_repository_impl.dart, package:app/features/auth/domain/usecases/login_usecase.dart, _, authRepository, AuthRepositoryProvider, create (+4 more)

### Community 65 - "package:freezed_annotation/freezed_annotation.dart"
Cohesion: 0.08
Nodes (25): class, JsonConverter, package:app/core/models/phone_number.dart, package:app/core/utils/extensions/string_extensions.dart, package:freezed_annotation/freezed_annotation.dart, static const List, fromJson, NullableDateTimeConvertor (+17 more)

### Community 66 - "Account Avatar"
Cohesion: 0.22
Nodes (8): AppStatusColors get, ColorScheme get, TextTheme get, ThemeData get, appStatusColors, colorScheme, textTheme, theme

### Community 67 - "Paginated Response Model"
Cohesion: 0.29
Nodes (6): NumberFormat, package:intl/intl.dart, TextInputFormatter, formatEditUpdate, _formatter, PriceFormatter

### Community 68 - "Paginated Dropdown Field"
Cohesion: 0.18
Nodes (10): Contents, Core Concepts, Examples, Managing Dart Dependencies, Surgical Lockfile Removal, Tightening Constraints, Version Constraints, Workflow: Auditing Dependencies (+2 more)

### Community 69 - "Phone Number Form Field"
Cohesion: 0.22
Nodes (8): int get, addItems, defaultLimitSize, firstPage, Paginated, PaginatedResponse, result, total

### Community 70 - "Theme Extensions"
Cohesion: 0.17
Nodes (11): @JsonEnum, package:app/core/models/json_types.dart, supervisor,, copyWith, data, fromJson, message, RoleDto (+3 more)

### Community 71 - "Auth Session Entity"
Cohesion: 0.50
Nodes (4): sessionRepositoryProvider, _FakeSessionRepository, SessionRepository, SessionRepositoryImpl

### Community 73 - "Paginated State"
Cohesion: 0.18
Nodes (10): Adaptive Layout using LayoutBuilder, Constraining Width on Large Screens, Contents, Device and Orientation Behaviors, Examples, Implementing Adaptive Layouts, Space Measurement Guidelines, Widget Sizing and Constraints (+2 more)

### Community 74 - "App Logger"
Cohesion: 0.17
Nodes (11): Completer, Dio get, pendingLogout, package:app/core/network/api_document.dart, package:app/core/network/authenticator.dart, package:talker_dio_logger/talker_dio_logger.dart, _, create (+3 more)

### Community 75 - "User Entity"
Cohesion: 0.22
Nodes (8): build, package:app/features/auth/di/auth_providers.dart, _, create, debugGetCreateSourceHash, login, LoginNotifierProvider, runBuild

### Community 76 - "Custom Modal Bottom Sheet"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 77 - "Freezed Models"
Cohesion: 0.20
Nodes (9): Analysis Configuration, Analyzing and Fixing Dart Code, Comprehensive `analysis_options.yaml`, Contents, Diagnostic Suppression, Examples, Inline Diagnostic Suppression, Workflow: Applying Automated Fixes (+1 more)

### Community 78 - "Pagination Hooks"
Cohesion: 0.20
Nodes (9): Contents, Core Components, Examples, High-Fidelity Widget Test Implementation, Interaction & State Management, Setup & Configuration, Task Progress, Workflow: Implementing a Widget Test (+1 more)

### Community 79 - "App Colors"
Cohesion: 0.20
Nodes (9): Constraint Violation Diagnostics, Contents, Examples, Fixing RenderFlex Overflow, Fixing Unbounded Height (ListView in Column), Fixing Unbounded Width (TextField in Row), Layout Error Resolution Workflow, Resolving Flutter Layout Errors (+1 more)

### Community 80 - "Color Schemes"
Cohesion: 0.25
Nodes (7): package:app/core/theme/colors/app_colors.dart, _, AppColorSchemes, brand, info, success, warning

### Community 81 - "package:app/core/observability/app_logger.dart"
Cohesion: 0.50
Nodes (3): package:app/core/observability/app_logger.dart, package:image_cropper/image_cropper.dart, cropImage

### Community 82 - "package:flutter/foundation.dart"
Cohesion: 0.14
Nodes (13): currentUserProvider, currentUser, build, logout, setSession, _, create, CurrentUserProvider (+5 more)

### Community 83 - "Debounced Search Hook"
Cohesion: 0.09
Nodes (20): EdgeInsets?, IconData, build, child, ControlledHeightScreen, padding, action, build (+12 more)

### Community 84 - "break_line.dart"
Cohesion: 0.10
Nodes (20): Color?, double?, package:app/core/widgets/image/image_svg.dart, borderRadius, BreakLine, build, color, height (+12 more)

### Community 87 - "rounded_button.dart"
Cohesion: 0.11
Nodes (17): build, child, FilledLoadingButton, isLoading, onPressed, backgroundColor, build, count (+9 more)

### Community 89 - "user_entity.dart"
Cohesion: 0.17
Nodes (11): package:app/core/session/data/session_repository.dart, package:flutter_test/flutter_test.dart, cached, clear, clearCalls, main, persist, read (+3 more)

### Community 90 - "Network Converters Barrel"
Cohesion: 0.33
Nodes (5): package:app/core/network/convertors/nullable_date_time_convertor.dart, package:app/core/network/convertors/nullable_phone_number_convertor.dart, package:app/core/network/convertors/nullable_string_convertor.dart, package:app/core/network/convertors/nullable_uri_convertor.dart, package:app/core/network/convertors/xfile_multipart_convertor.dart

### Community 91 - "Nullable DateTime Converter"
Cohesion: 0.29
Nodes (6): `.claude/` documentation, Code changes, Done when, Goal, Tests, Why (for your understanding only — do not write this history anywhere)

### Community 93 - "route_names.dart"
Cohesion: 0.29
Nodes (6): ARB entry shape, Consume in a widget, Ground truth (verify before editing), Hard rule (CLAUDE.md rule 11), Localization (this project), Workflow: add or edit a string

### Community 94 - "package:app/core/utils/extensions/common_extensions.dart"
Cohesion: 0.16
Nodes (13): AsyncValue, ConsumerState, package:app/core/messaging/failure_messenger.dart, package:app/core/utils/validation/validation_regex.dart, package:app/core/widgets/form_body.dart, package:app/features/auth/presentation/notifiers/login_notifier.dart, package:app/features/auth/presentation/widgets/password_text_form_field.dart, StatefulHookConsumerWidget (+5 more)

### Community 95 - "Nullable URI Converter"
Cohesion: 0.40
Nodes (4): package:app/core/theme/app_fonts.dart, _, AppTextTheme, build

### Community 96 - "App Text Theme"
Cohesion: 0.50
Nodes (4): Monstera Plant Photo (monstera.jpeg), Sunlit Minimalist Interior Corner, Large Leafy Potted Houseplant, Cylindrical Wooden Planter Pot

### Community 101 - "check_arch.sh (CI arch gate)"
Cohesion: 0.40
Nodes (4): Codegen / build, Commands cheatsheet, Git hooks, graphify (knowledge graph)

### Community 102 - "export.sh script"
Cohesion: 0.67
Nodes (3): CI analyze-and-test job, flutter_riverpod dependency, Talker patched fork dependency_overrides

### Community 104 - "jsonSerializable"
Cohesion: 0.29
Nodes (6): Deep linking, Ground truth (verify before editing), Hard rule (CLAUDE.md rule 15), Nested navigation (shells), Routing (this project), Workflow: add a route

### Community 105 - "setup-hooks.sh"
Cohesion: 0.67
Nodes (4): AppLocalizations, AppLocalizationsAr, AppLocalizationsEn, of

### Community 106 - "Annotations Barrel"
Cohesion: 0.50
Nodes (3): localized, localizedName, name

### Community 107 - "Assets Rule"
Cohesion: 0.50
Nodes (3): LoginParams, password, phone

### Community 108 - "deep_link.sh script"
Cohesion: 0.08
Nodes (24): package:app/core/l10n/localized_name.dart, package:app/core/pagination/pagination_controller.dart, package:app/core/pagination/paging_list_delegate.dart, package:app/core/utils/extensions/common_extensions.dart, package:app/core/utils/hooks/use_debounced_search.dart, package:app/core/widgets/break_line.dart, package:app/core/widgets/svg_prefix_icon.dart, ThemeMode (+16 more)

### Community 115 - "json_serializable.dart"
Cohesion: 0.29
Nodes (6): DefaultResponse, filedRename, jsonEnum, jsonSerializableRequest, jsonSerializableResponse, jsonSerializableResponseGeneric

### Community 130 - "Generated Member"
Cohesion: 0.33
Nodes (5): Adding a feature, Catalogue, Conventions, Files — one per layer, mirroring `lib/features/<feature>/`, Snippets (VS Code)

### Community 148 - "AppSettings"
Cohesion: 0.28
Nodes (9): @freezed, SessionCacheModel, _SessionCacheModel, _AppSettings, LoginRequestModel, UserModel, SessionCacheModel, SessionCacheModelPatterns (+1 more)

### Community 151 - "IraqiPhoneX"
Cohesion: 0.17
Nodes (11): GoRouter, NavigatorState, package:app/core/utils/constants/route_names.dart, package:app/features/auth/presentation/screens/login_screen.dart, package:app/features/home/presentation/screens/home_screen.dart, package:app/features/splash/presentation/screens/splash_screen.dart, package:app/router/router_refresh_notifier.dart, refreshNotifier (+3 more)

### Community 158 - "either.dart"
Cohesion: 0.26
Nodes (11): bool get, L, R, Either, hashCode, isLeft, isRight, Left (+3 more)

### Community 160 - "Analyzing and Fixing Dart Code"
Cohesion: 0.25
Nodes (6): package:app/core/network/convertors/convertors_lib.dart, package:app/core/network/default_response.dart, package:app/core/network/http_lib.dart, package:app/core/network/paginated_response.dart, package:app/core/utils/annotations/annotations_lib.dart, package:riverpod_annotation/riverpod_annotation.dart

### Community 163 - "package:flutter/widgets.dart"
Cohesion: 0.33
Nodes (5): package:app/core/messaging/snackbar.dart, package:flutter/widgets.dart, FailureX, localizeFailure, showFailure

### Community 164 - "architecture-auditor.md"
Cohesion: 0.50
Nodes (3): How to audit, How to report, Project conventions to enforce

### Community 166 - "app_logger.dart"
Cohesion: 0.22
Nodes (8): package:talker_flutter/talker_flutter.dart, _, AppLogger, error, handle, routeTalker, talker, warning

### Community 168 - "KurdishCupertinoLocalizationsDelegate"
Cohesion: 0.29
Nodes (7): CupertinoLocalizations, LocalizationsDelegate, _AppLocalizationsDelegate, KurdishCupertinoLocalizationsDelegate, _KurdishMaterialLocalizationsDelegate, KurdishWidgetLocalizations, WidgetsLocalizations

## Knowledge Gaps
- **1429 isolated node(s):** `deep_link.sh script`, `pngDir`, `svgDir`, `outputPath`, `pngs` (+1424 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **66 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `AuthRemoteDataSource` connect `API Consumer & Dio Exceptions` to `App Router`, `App Messenger / Snackbar`?**
  _High betweenness centrality (0.009) - this node is a cross-community bridge._
- **Why does `KurdishCupertinoLocalizations` connect `KurdishCupertinoLocalizations` to `macOS Runner Plugins`?**
  _High betweenness centrality (0.008) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Shared Widgets Catalogue` (e.g. with `Widget Composition Over Inheritance` and `l10n.yaml localization config`) actually correct?**
  _`Shared Widgets Catalogue` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `deep_link.sh script`, `pngDir`, `svgDir` to the rest of the system?**
  _1429 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Kurdish Material Localizations` be split into smaller, more focused modules?**
  _Cohesion score 0.011235955056179775 - nodes in this community are weakly interconnected._
- **Should `App Localizations (AR+EN)` be split into smaller, more focused modules?**
  _Cohesion score 0.020202020202020204 - nodes in this community are weakly interconnected._
- **Should `App Localizations (English)` be split into smaller, more focused modules?**
  _Cohesion score 0.022222222222222223 - nodes in this community are weakly interconnected._