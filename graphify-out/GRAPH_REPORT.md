# Graph Report - flutter_cl_riverpod  (2026-07-26)

## Corpus Check
- 207 files · ~59,572 words
- Verdict: corpus is large enough that graph structure adds value.

## Summary
- 2073 nodes · 2595 edges · 147 communities (103 shown, 44 thin omitted)
- Extraction: 99% EXTRACTED · 1% INFERRED · 0% AMBIGUOUS · INFERRED: 31 edges (avg confidence: 0.77)
- Token cost: 0 input · 0 output

## Graph Freshness
- Built from commit: `e7edeea0`
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
- Phone Number JSON Converter
- Account Avatar
- Paginated Response Model
- Paginated Dropdown Field
- Phone Number Form Field
- Theme Extensions
- Auth Session Entity
- Freezed Annotations
- Paginated State
- App Logger
- User Entity
- Custom Modal Bottom Sheet
- Freezed Models
- Pagination Hooks
- App Colors
- Color Schemes
- paginated_bottom_sheet.dart
- custom_paginated_drop_down_form_fied.dart
- Debounced Search Hook
- package:app/core/utils/extensions/common_extensions.dart
- File Multipart Converter
- JSON Serializable Annotations
- package:intl/intl.dart
- App Localizations Delegate
- Failure Messenger
- Network Converters Barrel
- Nullable DateTime Converter
- Async Screen State Pattern
- xfile_multipart_convertor.dart
- Nullable String Converter
- Nullable URI Converter
- App Text Theme
- Debounce Hook
- Localized Name
- Login Params
- Android MainActivity
- check_arch.sh (CI arch gate)
- export.sh script
- Avatar Image Composition
- CI & Dependencies
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
- android build.gradle
- settings.gradle
- Custom App Bar (fn)
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

## God Nodes (most connected - your core abstractions)
1. `Shared Widgets Catalogue` - 30 edges
2. `Win32Window` - 22 edges
3. `MessageHandler` - 12 edges
4. `Failure` - 10 edges
5. `FlutterWindow` - 10 edges
6. `Create` - 10 edges
7. `WndProc` - 10 edges
8. `MessageHandler` - 9 edges
9. `Setup Checklist (A-H)` - 8 edges
10. `AppLocalizations` - 7 edges

## Surprising Connections (you probably didn't know these)
- `l10n.yaml localization config` --conceptually_related_to--> `Shared Widgets Catalogue`  [INFERRED]
  l10n.yaml → docs/widgets.md
- `CI analyze-and-test job` --conceptually_related_to--> `flutter_riverpod dependency`  [INFERRED]
  .github/workflows/ci.yml → pubspec.yaml
- `Talker patched fork dependency_overrides` --conceptually_related_to--> `CI analyze-and-test job`  [INFERRED]
  pubspec.yaml → .github/workflows/ci.yml
- `Untranslated Messages Report` --conceptually_related_to--> `Step E: Strip the Demo Content`  [INFERRED]
  untranslated_messages.txt → README.md
- `Step H: Flutter Web on Google Cloud Storage` --conceptually_related_to--> `Flutter Web Entry (index.html)`  [INFERRED]
  README.md → web/index.html

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Two-Step Error Translation Pipeline** — claude_rules_data_layer_network_error_mapper, claude_rules_data_layer_safe_repository_call, claude_rules_data_layer_failure_messenger, claude_claude_local_either [EXTRACTED 1.00]
- **Session and Networking Token Flow** — claude_rules_session_networking_session, claude_rules_session_networking_session_controller, claude_rules_session_networking_dio_module, claude_rules_routing_router [EXTRACTED 1.00]
- **Vertical Slice Scaffolding** — claude_skills_add_feature_skill_checklist, claude_skills_add_feature_skill_clr_snippets, claude_skills_add_feature_skill_vertical_slice, claude_claude_auth_reference_slice [EXTRACTED 1.00]
- **State UI Presets Pattern** — docs_widgets_statemessage, docs_widgets_emptystate, docs_widgets_defaulterrorwidget [EXTRACTED 1.00]
- **Paginated Picker Sheet Flow** — docs_widgets_custompaginateddropdownformfield, docs_widgets_paginatedbottomsheet, docs_widgets_custommodalbottomsheet [EXTRACTED 1.00]
- **Const-First Lint Enforcement** — analysis_options_const_promotion, analysis_options_strict_language, docs_dart_style_widget_composition [INFERRED 0.75]

## Communities (147 total, 44 thin omitted)

### Community 0 - "Kurdish Material Localizations"
Cohesion: 0.01
Nodes (177): aboutListTileTitleRaw, alertDialogLabel, anteMeridiemAbbreviation, backButtonTooltip, bottomSheetLabel, calendarModeButtonLabel, cancelButtonLabel, clearButtonTooltip (+169 more)

### Community 1 - "App Localizations (AR+EN)"
Cohesion: 0.02
Nodes (98): app_localizations_ar.dart, app_localizations_en.dart, appName, badRequest, cancel, changeLanguage, conflict, crop (+90 more)

### Community 2 - "App Localizations (English)"
Cohesion: 0.02
Nodes (88): appName, badRequest, cancel, changeLanguage, conflict, crop, darkMode, defaultErrorMessage (+80 more)

### Community 3 - "App Localizations (Arabic)"
Cohesion: 0.02
Nodes (89): app_localizations.dart, appName, badRequest, cancel, changeLanguage, conflict, crop, darkMode (+81 more)

### Community 4 - "Windows Runner Plugins (C++)"
Cohesion: 0.06
Nodes (53): PluginRegistry, Point, RECT, Size, unique_ptr, RegisterPlugins(), DartProject, HWND (+45 more)

### Community 5 - "API Consumer & Dio Exceptions"
Cohesion: 0.15
Nodes (14): SafeRepositoryCall, AuthRepositoryImpl, login, _remoteDataSource, AuthRepository, login, call, _repository (+6 more)

### Community 6 - "Kurdish Cupertino Localizations"
Cohesion: 0.07
Nodes (29): FocusNode?, build, CachedImage, _CachedImageState, cacheKey, createState, devicePixelRatioCap, _errorBox (+21 more)

### Community 7 - "API Headers"
Cohesion: 0.20
Nodes (16): Exception, BadRequestException, CacheException, ConflictException, ForbiddenException, InvalidCredentialsException, message, NetworkException (+8 more)

### Community 8 - "macOS Runner Plugins"
Cohesion: 0.04
Nodes (45): CupertinoLocalizations, GlobalCupertinoLocalizations, alertDialogLabel, anteMeridiemAbbreviation, backButtonLabel, cancelButtonLabel, clearButtonLabel, collapsedHint (+37 more)

### Community 9 - "Session Controller"
Cohesion: 0.05
Nodes (37): @immutable, accept, acceptLanguage, ApiHeaders, applicationJson, authorization, bearer, contentType (+29 more)

### Community 10 - "Phone Number Model"
Cohesion: 0.06
Nodes (29): Any, Cocoa, file_selector_macos, Flutter, flutter_secure_storage_darwin, FlutterAppDelegate, FlutterImplicitEngineBridge, FlutterImplicitEngineDelegate (+21 more)

### Community 11 - "Architecture Invariants"
Cohesion: 0.06
Nodes (40): Analyzer & Linter Configuration, Const Lint Promotion to Warning, custom_lint Analyzer Plugin, Strict Casts / Inference / Raw Types, Accessibility Guidance, Effective Dart Baseline, Dart & Flutter Style Guide, Overflow-Safe Layout (+32 more)

### Community 12 - "Form State & Layout"
Cohesion: 0.10
Nodes (19): copyWith, countryCode, _countryCodesRegex, countryISOCode, _fullPhoneNumber, initialCountryCode, iraqiPhoneNumber, iraqiPhoneNumberStarter (+11 more)

### Community 13 - "App Settings Provider"
Cohesion: 0.07
Nodes (37): auth Reference Slice, check_arch.sh CI Boundary Enforcement, Declarative Navigation on Session Change, Layer Rules (Architecture Invariants), Local sealed Either, No Feature Imports Another Feature, Riverpod Provider Naming Rule, Session as Core Concern (+29 more)

### Community 14 - "Sizing & Border Tokens"
Cohesion: 0.06
Nodes (33): AutovalidateMode?, CrossAxisAlignment, GlobalKey, FormStateX, build, children, ColumnPadded, crossAxisAlignment (+25 more)

### Community 15 - "Component Themes"
Cohesion: 0.06
Nodes (33): AppSettings, AppSettings, build, fromJson, toJson, _, key, locale (+25 more)

### Community 16 - "Linux Runner (GTK)"
Cohesion: 0.06
Nodes (30): BorderSize, BorderWidth, extraLarge, extraLargeAll, extraLargeRadius, extraSmall, extraSmallAll, extraSmallRadius (+22 more)

### Community 17 - "SafeRepositoryCall & UseCase"
Cohesion: 0.07
Nodes (27): appBar, AppComponentThemes, _AppShapes, bottomSheet, button, card, checkbox, container (+19 more)

### Community 18 - "Kurdish Widget Localizations"
Cohesion: 0.09
Nodes (25): class _PagingControllerHookState, Hook, HookState, PaginatedExtension, appendPageFrom, appendPageFromEither, build, _controller (+17 more)

### Community 19 - "Break Line Widget"
Cohesion: 0.10
Nodes (20): FlPluginRegistry, GApplication, gboolean, gchar, GObject, GtkApplication, fl_register_plugins(), main() (+12 more)

### Community 20 - "Custom Text Form Field"
Cohesion: 0.09
Nodes (24): copyButtonLabel, cutButtonLabel, delegate, isSupported, _KurdishMaterialLocalizationsDelegate, KurdishWidgetLocalizations, load, lookUpButtonLabel (+16 more)

### Community 21 - "App Messenger / Snackbar"
Cohesion: 0.10
Nodes (20): Color?, double?, borderRadius, BreakLine, build, color, height, width (+12 more)

### Community 22 - "Localization Extensions"
Cohesion: 0.09
Nodes (22): int? maxLines,, build, contentPadding, controller, enabledBorder, fillColor, focusedBorder, focusNode (+14 more)

### Community 23 - "Session Cache Model"
Cohesion: 0.08
Nodes (26): ItemType, AppMessenger, key, MessageType, show, defaultListDelegate, _pageLoader, build (+18 more)

### Community 24 - "Login Request Model"
Cohesion: 0.08
Nodes (26): bool get, class SessionControllerProvider, isSignedIn, logout, SessionController, user, build, isSignedIn (+18 more)

### Community 25 - "User Model"
Cohesion: 0.12
Nodes (16): fromJson, _, fromEntity, toEntity, class, hashCode, identical, null (+8 more)

### Community 26 - "Home Screen"
Cohesion: 0.11
Nodes (19): fromJson, _, _LoginRequestModel, LoginRequestModel, String phoneNumber, String, class, hashCode, identical (+11 more)

### Community 27 - "Network DI Providers"
Cohesion: 0.11
Nodes (18): fromJson, _, _UserModel, toEntity, UserModel, class, hashCode, identical (+10 more)

### Community 28 - "Pagination Controller Hook"
Cohesion: 0.11
Nodes (20): _, @riverpod, authRepositoryProvider, dioProvider, flutterSecureStorageProvider, dio, sessionProvider, Session (+12 more)

### Community 29 - "Session Repository"
Cohesion: 0.12
Nodes (17): class SessionRepositoryProvider, clear, sessionRepositoryProvider, persist, read, _secureStorage, SessionRepository, SessionRepositoryImpl (+9 more)

### Community 30 - "Custom Text Widget"
Cohesion: 0.11
Nodes (17): FontWeight?, build, color, decoration, fontSize, fontWeight, height, maxChars (+9 more)

### Community 31 - "Auth Remote Data Source"
Cohesion: 0.14
Nodes (17): CustomTextFormField, CustomText, build, child, _ComponentGallery, _DetailPreview, _OverlayGallery, room (+9 more)

### Community 32 - "Asset Generation Script"
Cohesion: 0.11
Nodes (20): AppLocalizations get, BuildContext, double get, AppLocalizationsExtension, DeviceHeight, DeviceWidth, height, iraqiPhoneNumber (+12 more)

### Community 33 - "App Entry (main)"
Cohesion: 0.13
Nodes (14): buffer, _collectAssets, dir, main, names, outFile, outputPath, parts (+6 more)

### Community 34 - "Custom Date Picker Field"
Cohesion: 0.11
Nodes (20): DateTime? firstDate,, HookConsumerWidget, ValueNotifierUpdated, build, CustomDatePickerFormField, labelText, lastDate, selectedDateNotifier (+12 more)

### Community 35 - "Default Error Widget"
Cohesion: 0.09
Nodes (20): EdgeInsets?, IconData, build, child, ControlledHeightScreen, padding, action, build (+12 more)

### Community 36 - "Custom App Bar"
Cohesion: 0.15
Nodes (12): ConsumerWidget, App, build, HomeScreen, routerProvider, package:app/core/l10n/generated/app_localizations.dart, package:app/core/l10n/kurdish/kurdish_cupertino_localization_delegate.dart, package:app/core/l10n/kurdish/kurdish_material_localization_delegate.dart (+4 more)

### Community 37 - "Cached Image"
Cohesion: 0.14
Nodes (13): FormValidatorLocale, AppFormValidatorLocale, context, email, ip, ipv6, maxLength, minLength (+5 more)

### Community 38 - "App Root Widget"
Cohesion: 0.14
Nodes (12): AsyncValue, FailureX, localizeFailure, showFailure, createState, package:app/core/messaging/failure_messenger.dart, package:app/core/messaging/snackbar.dart, package:app/core/utils/validation/validation_regex.dart (+4 more)

### Community 39 - "Shared Widgets Catalogue"
Cohesion: 0.14
Nodes (13): class FlutterSecureStorageProvider, FlutterSecureStorage, FlutterSecureStorage get, androidOptions, iosOptions, secureStorage, package:flutter_secure_storage/flutter_secure_storage.dart, _ (+5 more)

### Community 40 - "Password Text Form Field"
Cohesion: 0.14
Nodes (13): CroppedFile?, build, height, hintText, icon, image, ImageFormField, imgheight (+5 more)

### Community 41 - "Form Validator Locale"
Cohesion: 0.18
Nodes (10): dart:convert, firstBuild, fromJson, jsonDecode, jsonEncode, key, ObjectPreferenceProvider, toJson (+2 more)

### Community 42 - "Login Screen"
Cohesion: 0.12
Nodes (15): apiConsumerProvider, Dio, ApiConsumer, delete, _dio, DioConsumer, post, put (+7 more)

### Community 43 - "Secure Storage Provider"
Cohesion: 0.14
Nodes (12): ApiDocument, baseUrl, mediaUrl, resolveMediaPath, calender, cameraplus, hugeicons3drotate, PngAssets (+4 more)

### Community 44 - "Filled Loading Button"
Cohesion: 0.18
Nodes (12): AppTheme, _build, dark, light, package:app/core/theme/app_text_theme.dart, package:app/core/theme/app_theme.dart, package:app/core/theme/colors/color_schemes.dart, package:app/core/theme/component_themes.dart (+4 more)

### Community 45 - "Api Document Config"
Cohesion: 0.15
Nodes (12): Completer, Dio get, pendingLogout, package:app/core/network/api_document.dart, package:app/core/network/authenticator.dart, package:app/core/session/session_provider.dart, package:talker_dio_logger/talker_dio_logger.dart, _ (+4 more)

### Community 46 - "App Theme"
Cohesion: 0.15
Nodes (12): alignment, build, CustomDropdownButtonFormField, fillColor, hintStyle, hintText, items, onChanged (+4 more)

### Community 47 - "Shared Preferences Provider"
Cohesion: 0.17
Nodes (11): @JsonEnum, copyWith, data, fromJson, message, RoleDto, statusCode, toJson (+3 more)

### Community 48 - "Dio Module & Logout"
Cohesion: 0.12
Nodes (16): authRemoteDataSourceProvider, class AuthRemoteDataSourceProvider, _api, AuthRemoteDataSource, AuthRemoteDataSourceImpl, login, package:app/core/network/api_consumer.dart, package:app/core/network/endpoints.dart (+8 more)

### Community 49 - "Image Form Field"
Cohesion: 0.24
Nodes (9): _In_, _In_opt_, vector, wWinMain(), string, wchar_t, CreateAndAttachConsole(), GetCommandLineArguments() (+1 more)

### Community 50 - "Custom Dropdown Button"
Cohesion: 0.30
Nodes (11): BadRequestFailure, CacheFailure, ConflictFailure, Failure, ForbiddenFailure, InvalidCredentialsFailure, message, NetworkFailure (+3 more)

### Community 51 - "Image PNG Widget"
Cohesion: 0.17
Nodes (11): AppStatusColorsX, copyWith, info, lerp, of, onInfo, onSuccess, onWarning (+3 more)

### Community 52 - "Default Response Model"
Cohesion: 0.17
Nodes (11): AlignmentGeometry, alignment, borderRadius, build, fit, height, ImagePng, img (+3 more)

### Community 53 - "Image SVG Widget"
Cohesion: 0.17
Nodes (12): Step F: Deep Links / App Links, Step A: Clone and Detach from Template, Step H: Flutter Web on Google Cloud Storage, Handy Scripts (bin/), Flutter Clean Architecture + Riverpod Starter, Step G: Release Signing, Step B: Rename the App, Setup Checklist (A-H) (+4 more)

### Community 54 - "Windows Native (C++)"
Cohesion: 0.17
Nodes (11): BoxFit, borderRadius, build, color, fit, height, ImageSvg, img (+3 more)

### Community 55 - "Failure Types"
Cohesion: 0.17
Nodes (11): GoRouter, refreshNotifier, _rootNavigatorKey, router, _shellNavigatorKey, NavigatorState, package:app/features/auth/presentation/screens/login_screen.dart, package:app/features/home/presentation/screens/home_screen.dart (+3 more)

### Community 56 - "Login Notifier"
Cohesion: 0.18
Nodes (10): Interceptor, Authenticator, onRequest, _ref, DioRefX, SecureStorageRefX, SharedPreferencesRefX, package:app/core/network/api_headers.dart (+2 more)

### Community 57 - "Status Colors Extension"
Cohesion: 0.26
Nodes (11): L, Either, hashCode, isLeft, isRight, Left, operator, Right (+3 more)

### Community 58 - "Rounded Button"
Cohesion: 0.18
Nodes (10): UseCase, LoginUseCase, package:app/features/auth/data/repositories/auth_repository_impl.dart, package:app/features/auth/domain/usecases/login_usecase.dart, _, AuthRepositoryProvider, create, debugGetCreateSourceHash (+2 more)

### Community 59 - "Object Preference Provider"
Cohesion: 0.18
Nodes (10): background_color, description, display, icons, name, orientation, prefer_related_applications, short_name (+2 more)

### Community 60 - "App Router"
Cohesion: 0.18
Nodes (11): class, File, JsonConverter, FileJsonConvertor, fromJson, NullablePhoneNumberConvertor, PhoneNumberConvertor, toJson (+3 more)

### Community 61 - "Dio Authenticator Interceptor"
Cohesion: 0.18
Nodes (10): class SharedPreferencesProvider, package:shared_preferences/shared_preferences.dart, SharedPreferences, SharedPreferences get, _, create, debugGetCreateSourceHash, extends (+2 more)

### Community 62 - "Paginated Bottom Sheet"
Cohesion: 0.20
Nodes (9): double size,, AccountAvatar, build, _cameraPlaceholder, _framed, imageUrl, isEditiable, verifiedSize (+1 more)

### Community 63 - "Auth Providers & Usecases"
Cohesion: 0.20
Nodes (9): int?, count, fromJson, pageNumber, pageSize, result, total, totalPages (+1 more)

### Community 64 - "Web Manifest"
Cohesion: 0.17
Nodes (10): dart:async, debounced, controller, debounced, DebouncedSearch, useDebouncedSearch, value, package:app/core/utils/hooks/use_debounce.dart (+2 more)

### Community 65 - "Phone Number JSON Converter"
Cohesion: 0.18
Nodes (10): build, controller, focusNode, onChanged, onCountryCodeChanged, PhoneNumberFormField, package:app/core/l10n/locale.dart, package:country_code_picker/country_code_picker.dart (+2 more)

### Community 66 - "Account Avatar"
Cohesion: 0.22
Nodes (8): AppStatusColors get, ColorScheme get, appStatusColors, colorScheme, textTheme, theme, TextTheme get, ThemeData get

### Community 67 - "Paginated Response Model"
Cohesion: 0.17
Nodes (11): DateTime, DateTimeX, format, format24Hour, formatDate, formatDOW, formatTime, formatTimeago (+3 more)

### Community 68 - "Paginated Dropdown Field"
Cohesion: 0.25
Nodes (7): AuthSessionEntity, hashCode, operator, token, toString, user, UserEntity

### Community 69 - "Phone Number Form Field"
Cohesion: 0.17
Nodes (11): backgroundColor, build, count, hasBadge, icon, iconColor, iconSize, onTap (+3 more)

### Community 70 - "Theme Extensions"
Cohesion: 0.17
Nodes (10): freezedRequest, freezedResponse, package:app/core/network/convertors/convertors_lib.dart, package:app/core/network/default_response.dart, package:app/core/network/http_lib.dart, package:app/core/network/paginated_response.dart, package:app/core/utils/annotations/annotations_lib.dart, package:dio/dio.dart (+2 more)

### Community 71 - "Auth Session Entity"
Cohesion: 0.20
Nodes (9): int get, addItems, defaultLimitSize, firstPage, Paginated, PaginatedResponse, result, total (+1 more)

### Community 72 - "Freezed Annotations"
Cohesion: 0.22
Nodes (8): AppLogger, error, handle, routeTalker, talker, warning, package:talker_flutter/talker_flutter.dart, _

### Community 73 - "Paginated State"
Cohesion: 0.22
Nodes (8): createdAt, id, name, operator, phone, profileImg, role, toString

### Community 74 - "App Logger"
Cohesion: 0.22
Nodes (8): context, customModalBottomSheet, isDismissible, isScrollControlled, showDragHandle, showModalBottomSheet, true, package:app/core/widgets/break_line.dart

### Community 75 - "User Entity"
Cohesion: 0.13
Nodes (14): ConsumerState, build, login, build, LoginScreen, _LoginScreenState, package:app/features/auth/di/auth_providers.dart, StatefulHookConsumerWidget (+6 more)

### Community 76 - "Custom Modal Bottom Sheet"
Cohesion: 0.13
Nodes (14): ChangeNotifier, appName, main, runZonedGuarded, dispose, RouterRefreshNotifier, _sub, package:app/app.dart (+6 more)

### Community 77 - "Freezed Models"
Cohesion: 0.28
Nodes (9): @freezed, SessionCacheModel, _SessionCacheModel, _AppSettings, jsonSerializable, LoginRequestModel, UserModel, SessionCacheModel (+1 more)

### Community 79 - "App Colors"
Cohesion: 0.12
Nodes (13): AppColors, brand, info, success, warning, getOppositeThemeMode, ThemeX, build (+5 more)

### Community 80 - "Color Schemes"
Cohesion: 0.25
Nodes (7): AppColorSchemes, brand, info, success, warning, package:app/core/theme/colors/app_colors.dart, _

### Community 81 - "paginated_bottom_sheet.dart"
Cohesion: 0.18
Nodes (9): build, customItems, pagingController, titleText, package:app/core/l10n/localized_name.dart, package:app/core/pagination/pagination_controller.dart, package:app/core/pagination/paging_list_delegate.dart, package:app/core/utils/hooks/use_debounced_search.dart (+1 more)

### Community 82 - "custom_paginated_drop_down_form_fied.dart"
Cohesion: 0.20
Nodes (9): build, customItems, hintText, labelText, pagingController, prefixIcon, valueNotifier, package:app/core/widgets/overlay/custom_modal_bottom_sheet.dart (+1 more)

### Community 83 - "Debounced Search Hook"
Cohesion: 0.09
Nodes (20): build, child, FilledLoadingButton, isLoading, onPressed, customAppBar, isElevated, LeadingButton (+12 more)

### Community 84 - "package:app/core/utils/extensions/common_extensions.dart"
Cohesion: 0.29
Nodes (7): isDark, isLight, localize, ThemeModeCheck, ThemeModeL10n, package:app/core/utils/extensions/common_extensions.dart, ThemeMode

### Community 85 - "File Multipart Converter"
Cohesion: 0.18
Nodes (9): messageFrom, NetworkErrorMapper, toException, call, NoParamsUseCase, package:app/core/errors/exceptions.dart, package:app/core/errors/failures.dart, package:app/core/utils/either.dart (+1 more)

### Community 86 - "JSON Serializable Annotations"
Cohesion: 0.29
Nodes (6): DefaultResponse, filedRename, jsonEnum, jsonSerializableRequest, jsonSerializableResponse, jsonSerializableResponseGeneric

### Community 87 - "package:intl/intl.dart"
Cohesion: 0.29
Nodes (6): formatEditUpdate, _formatter, PriceFormatter, NumberFormat, package:intl/intl.dart, TextInputFormatter

### Community 88 - "App Localizations Delegate"
Cohesion: 0.40
Nodes (6): AppLocalizations, _AppLocalizationsDelegate, AppLocalizationsAr, AppLocalizationsEn, of, LocalizationsDelegate

### Community 89 - "Failure Messenger"
Cohesion: 0.40
Nodes (4): dart:io, fromJson, toJson, package:app/core/network/clients_lib.dart

### Community 90 - "Network Converters Barrel"
Cohesion: 0.33
Nodes (5): package:app/core/network/convertors/nullable_date_time_convertor.dart, package:app/core/network/convertors/nullable_phone_number_convertor.dart, package:app/core/network/convertors/nullable_string_convertor.dart, package:app/core/network/convertors/nullable_uri_convertor.dart, package:app/core/network/convertors/xfile_multipart_convertor.dart

### Community 91 - "Nullable DateTime Converter"
Cohesion: 0.20
Nodes (8): fromJson, NullableDateTimeConvertor, nullData, toJson, fromJson, nullData, toJson, package:app/core/utils/extensions/string_extensions.dart

### Community 92 - "Async Screen State Pattern"
Cohesion: 0.40
Nodes (4): cropImage, package:app/core/observability/app_logger.dart, package:image_cropper/image_cropper.dart, package:image_picker/image_picker.dart

### Community 93 - "xfile_multipart_convertor.dart"
Cohesion: 0.40
Nodes (4): fromJson, toJson, XFileMultipartConvertor, package:json_annotation/json_annotation.dart

### Community 94 - "Nullable String Converter"
Cohesion: 0.33
Nodes (5): fromJson, NullableUriConvertor, nullData, toJson, static const List

### Community 95 - "Nullable URI Converter"
Cohesion: 0.40
Nodes (4): AppTextTheme, build, package:app/core/theme/app_fonts.dart, _

### Community 96 - "App Text Theme"
Cohesion: 0.50
Nodes (4): Monstera Plant Photo (monstera.jpeg), Sunlit Minimalist Interior Corner, Large Leafy Potted Houseplant, Cylindrical Wooden Planter Pot

### Community 97 - "Debounce Hook"
Cohesion: 0.50
Nodes (3): localized, localizedName, name

### Community 98 - "Localized Name"
Cohesion: 0.50
Nodes (3): LoginParams, password, phone

### Community 102 - "export.sh script"
Cohesion: 0.67
Nodes (3): CI analyze-and-test job, flutter_riverpod dependency, Talker patched fork dependency_overrides

## Knowledge Gaps
- **1299 isolated node(s):** `deep_link.sh script`, `pngDir`, `svgDir`, `outputPath`, `pngs` (+1294 more)
  These have ≤1 connection - possible missing edges or undocumented components.
- **44 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `LoginScreen` connect `User Entity` to `App Root Widget`?**
  _High betweenness centrality (0.009) - this node is a cross-community bridge._
- **Why does `Settings` connect `Pagination Controller Hook` to `Component Themes`?**
  _High betweenness centrality (0.005) - this node is a cross-community bridge._
- **Are the 2 inferred relationships involving `Shared Widgets Catalogue` (e.g. with `Widget Composition Over Inheritance` and `l10n.yaml localization config`) actually correct?**
  _`Shared Widgets Catalogue` has 2 INFERRED edges - model-reasoned connections that need verification._
- **What connects `deep_link.sh script`, `pngDir`, `svgDir` to the rest of the system?**
  _1299 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Kurdish Material Localizations` be split into smaller, more focused modules?**
  _Cohesion score 0.011235955056179775 - nodes in this community are weakly interconnected._
- **Should `App Localizations (AR+EN)` be split into smaller, more focused modules?**
  _Cohesion score 0.020202020202020204 - nodes in this community are weakly interconnected._
- **Should `App Localizations (English)` be split into smaller, more focused modules?**
  _Cohesion score 0.02247191011235955 - nodes in this community are weakly interconnected._