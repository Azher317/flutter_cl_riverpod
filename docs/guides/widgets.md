# Shared widgets

Catalogue of [lib/core/widgets/](../../lib/core/widgets/) — reusable widgets that wrap common
customizations so you don't rebuild them per screen. Behavioural rules for *authoring*
widgets live in [.claude/rules/presentation.md](../../.claude/rules/presentation.md).

## Top level

| Widget | What it is | Notes |
|---|---|---|
| [`CustomText`](../../lib/core/widgets/text.dart) | `Text` wrapper deriving a style from `bodyMedium` (`fontSize ?? 14`, `w500`, ellipsis, `maxLines ?? 100`). | `CustomText.textStyle(context, ...)` gives a ready style for `TextField`/`hintStyle`. |
| [`customAppBar(...)`](../../lib/core/widgets/custom_app_bar.dart) | Function returning an `AppBar` with a themed back button; falls back to `go(RouteNames.home)` when it can't pop. | For the standard back affordance; plain `AppBar` is fine otherwise (`appBarTheme` styles it). Required `leading:` — `LeadingButton.flatIcon` or `.elevatedIcon`. |
| [`FormBody`](../../lib/core/widgets/form_body.dart) | Scaffold `body:` for a scrollable form — `Form` + tap-to-dismiss-keyboard + scrollable fields + pinned action row. | Required `formKey`, `children`. Optional `actions` (each `Expanded` in a bottom row), `padding` (16), `spacing` (`Insets.medium`), `safeArea` (true), `crossAxisAlign` (stretch), `autovalidateMode`. |
| [`ColumnPadded`](../../lib/core/widgets/column_padded.dart) | `Column` with `spacing` defaulting to `Insets.medium`. | For consistently gapped stacks. A plain `Column(spacing: ...)` is equivalent when you pass an explicit gap anyway. |
| [`ControlledHeightScreen`](../../lib/core/widgets/controlled_height_screen.dart) | `SingleChildScrollView` whose child is forced to at least viewport height (`IntrinsicHeight`). | For content that must fill the screen but still scroll under a keyboard. `FormBody` already wraps it — don't nest a second one. |
| [`DirectionalIcon`](../../lib/core/widgets/directional_icon.dart) | Mirrors an `IconData` **or** an SVG horizontally: `Matrix4.rotationY(π)` in **LTR**, identity in RTL. | For arrows/chevrons authored RTL-first. Pass exactly one of `icon:` / `img:`; `iconSize` is required (nullable). Prefer Flutter's `*Directional` icons where they exist. |
| [`BreakLine`](../../lib/core/widgets/break_line.dart) | Rounded pill used as a bottom-sheet grab handle. | For a sheet handle; use `Divider` for separators (already themed).|
| [`AccountAvatar`](../../lib/core/widgets/account_avatar.dart) | Circular avatar: `CachedImage` when `imageUrl != null`, camera placeholder otherwise, optional edit badge. | For user avatars. `size` 56, `verifiedSize` 20, `isEditiable` false, `onTap`. |
| [`SvgPrefixIcon`](../../lib/core/widgets/svg_prefix_icon.dart) | 24×24 SVG sized and directionally padded for use as a field `prefixIcon`. | For `CustomTextFormField(prefixIcon: ...)`. Defaults to `colorScheme.primary`. |

## `animation/`

| Widget | What it is | Notes |
|---|---|---|
| [`ReduceMotionScope`](../../lib/core/widgets/animation/reduce_motion_scope.dart) | Makes iOS Reduce Motion (and Android "Remove animations") reach `context.reduceMotion`, live. | Already above `MaterialApp` in `app.dart`. Don't add another. |
| [`StaggeredEnter`](../../lib/core/widgets/animation/staggered_enter.dart) | Fades and slides an item in, delayed by its `index`. | Wrap each item of a list that just loaded; not for later pages. Instant with reduced motion. |
| [`TabSwitcher`](../../lib/core/widgets/animation/tab_switcher.dart) | The body under a tab bar: each tab is built the first time it is chosen (its data loads then) and kept alive; switching slides, mirrored in RTL. | Sized to the current tab, so it works inside a scrolling column. Instant with reduced motion. |
| [`PullStretch`](../../lib/core/widgets/layout/pull_stretch.dart) | A header whose background stretches into the gap when the page is pulled down, so no white strip shows. | First item of the scroll view. |
| [`FieldShake`](../../lib/core/widgets/animation/field_shake.dart) | Shakes its child once each time `trigger` changes to a new non-zero value. | Bump an error counter on each rejected submit. Skipped under reduced motion. |

## Appearance (theme / language)

| API | What it is | Notes |
|---|---|---|
| [`ref.changeThemeMode` / `ref.toggleThemeMode` / `ref.changeLocale`](../../lib/core/settings/appearance_actions.dart) | The only way UI changes theme or language: circular reveal from `origin` + `selection` haptic. | Wrap the control in `TapOrigin(builder: (context, origin) => …)` and pass `origin: origin()`. |
| [`ThemeRevealHost`](../../lib/core/theme/theme_reveal.dart) | Screenshots the old frame and uncovers the new theme/locale under a growing circle. | Already in `MaterialApp.builder`. |

## `buttons/`

| Widget | What it is | Notes |
|---|---|---|
| [`FilledLoadingButton`](../../lib/core/widgets/buttons/filled_loading_button.dart) | `FilledButton` that swaps its child for a spinner and disables itself while `isLoading`. | Drive `isLoading` from `asyncValue.isLoading`. `onPressed` is non-nullable — use `isLoading` to disable. |
| [`RoundedButton`](../../lib/core/widgets/buttons/rounded_button.dart) | Circular icon button on a `Material` fill, optional badge/count. | For FAB-like circular affordances. ⚠️ Takes a full `svgPath` and calls `SvgPicture.asset` directly, unlike every other SVG site. |

## `form_fields/`

`inputDecorationTheme` ([component_themes.dart](../../lib/core/theme/component_themes.dart))
supplies fill, borders, hint style and content padding for **all** of these.

| Widget | What it is | Notes |
|---|---|---|
| [`PhoneFormField`](../../lib/core/widgets/form_fields/phone_form_field.dart) | Every phone field. Iraqi-only (`07XX XXX XXXX`, live grouping, Arabic digits, pasted `+964` handled) or international (country picker), per `AppConfig.phoneFormat`. | Send `PhoneFormField.valueOf(text)`. Flags a wrong number only when complete or unfocused. Prefill with `PhoneFormField.initialText(saved)`. |
| [`OtpField`](../../lib/core/widgets/form_fields/otp_field.dart) | N-cell one-time-code field (6 by default) on one hidden `TextField`: paste and OS code autofill work; Arabic digits accepted. | `onCompleted` verifies; set `hasError` and bump `errorTrigger` on a wrong code (shake + error haptic; next keystroke starts over). |
| [`ResendCountdown`](../../lib/core/widgets/form_fields/resend_countdown.dart) | "Resend code in 00:45", then a Resend button. | `availableAt` from the server, else now + `OtpField.resendCooldown` (45 s). |
| [`AppSearchField`](../../lib/core/widgets/form_fields/app_search_field.dart) | The search box: keeps its pill shape on focus, closes the keyboard on a tap elsewhere, clear button while it has text. | Pair with `useDebouncedSearch()`. |
| [`CustomTextFormField`](../../lib/core/widgets/form_fields/custom_text_form_field.dart) | The one text field; every other field is built on it. Text sits on the layout's start side, also when `textDirection` forces LTR (phones, prices). | Required `hintText`. Missing an option? Add a parameter here; `check_arch.sh` blocks a raw `TextFormField` in features. |
| [`PasswordFormField`](../../lib/core/widgets/form_fields/password_form_field.dart) | Password field with a show/hide button. | Built on `CustomTextFormField`. |
| [`CustomDropdownButtonFormField<T>`](../../lib/core/widgets/form_fields/custom_drop_down_button.dart) | Themed `DropdownButtonFormField`, `autovalidateMode` fixed to `onUserInteraction`. | For a small static option list. |
| [`CustomPaginatedDropdownFormField<T>`](../../lib/core/widgets/form_fields/custom_paginated_drop_down_form_fied.dart) | Read-only field that opens a searchable paged picker sheet and writes the choice into a `ValueNotifier<T?>`. | For server-backed lookups. Required `pagingController`, `hintText`, `valueNotifier`. Pass `labelBuilder` for type safety — the fallback is the `dynamic` [`localizedName`](../../lib/core/l10n/localized_name.dart). |
| [`CustomDatePickerFormField`](../../lib/core/widgets/form_fields/custom_date_picker_form_field.dart) | Read-only field opening `showDatePicker`, bound to a `ValueNotifier<DateTime?>`. | Required `labelText` (localized). `check_arch.sh` blocks a raw `showDatePicker` in features. |
| [`CustomTimePickerFormField`](../../lib/core/widgets/form_fields/custom_time_picker_form_field.dart) | Same, for `TimeOfDay` via `showTimePicker`. | `labelText` is required — pass a localized string. |
| [`ImageFormField`](../../lib/core/widgets/form_fields/image_form_field.dart) | Pick + crop an image (`cropImage` from [image_service.dart](../../lib/core/media/image_service.dart)) with `FormField` validation. | `ImageFormField.notifier(myNotifier, ...)` binds a `ValueNotifier<CroppedFile?>` directly. |
| [`LabeledField`](../../lib/core/widgets/form_fields/labeled_field.dart) | Bold label above a group of widgets. | For a field group needing a caption that `labelText` can't express. |

## `image/`

Asset constants store the **bare filename** — no directory, no extension
([assets.dart](../../lib/core/utils/constants/assets.dart)). `ImageSvg`/`ImagePng`
interpolate `assets/images/svg/$img.svg` / `assets/images/png/$img.png` themselves.

| Widget | What it is | Notes |
|---|---|---|
| [`ImageSvg`](../../lib/core/widgets/image/image_svg.dart) | Bundled SVG by bare name; `color` applies a `srcIn` filter. | `size` overrides `height`/`width`. |
| [`ImagePng`](../../lib/core/widgets/image/image_png.dart) | Bundled PNG by bare name, or a device file when `isFileImage: true`. | For bundled raster art. |
| [`CachedImage`](../../lib/core/widgets/image/cached_image.dart) | Network image: skeleton placeholder, error box with tap-to-retry, `memCache*` sized from DPR, rounded. | Positional `url` (nullable; blank never hits the network). Pass `cacheKey` when the URL carries signed/expiring params. |

## `overlay/`

| Widget | What it is | Notes |
|---|---|---|
| [`customModalBottomSheet(...)`](../../lib/core/widgets/overlay/custom_modal_bottom_sheet.dart) | `showModalBottomSheet` with root navigator, safe area, 75%-height default, optional drag handle. | Surface/shape/clip come from `bottomSheetTheme`; only sizing and behaviour are arguments. |
| [`PaginatedBottomSheet<T>`](../../lib/core/widgets/overlay/paginated_bottom_sheet.dart) | Searchable, paginated picker list (debounced search + `RefreshIndicator` + `defaultListDelegate`). | Pass as the `child:` of `customModalBottomSheet`. It does **not** create the controller — the caller owns it. |
| [`showAppDialog` / `showConfirmDialog`](../../lib/core/widgets/overlay/app_dialog.dart) | The one way to open a dialog; `showConfirmDialog` returns `true` only on confirm. | `check_arch.sh` blocks a raw `showDialog` in features. |
| [`CustomDialog`](../../lib/core/widgets/overlay/custom_dialog.dart) | Title + any content + localized Add / Cancel row. | For a form inside a dialog. Open it with `showAppDialog`. |

`AlertDialog` is themed via `dialogTheme`:

```dart
showAppDialog<void>(
  context,
  builder: (BuildContext context) => AlertDialog(
    title: Text(context.l10n.someTitle),
    content: Text(context.l10n.someBody),
    actions: <Widget>[
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(context.l10n.cancel),
      ),
    ],
  ),
);
```

## `state_ui/`

| Widget | What it is | Notes |
|---|---|---|
| [`AppSkeleton`](../../lib/core/widgets/state_ui/app_skeleton.dart) | The loading look: the real widgets drawn as shimmering bones while `enabled`. | Feed the real widgets placeholder data; see "Loading states" in presentation.md. |
| [`StateMessage`](../../lib/core/widgets/state_ui/state_message.dart) | Base layout: centred icon + title (+ optional message + action). | Use directly for a state the two presets don't cover. |
| [`EmptyState`](../../lib/core/widgets/state_ui/empty_state.dart) | Preset: `Icons.inbox_outlined` + title. | The empty-list state. Required `title` — e.g. `context.l10n.noItemsFoundError`. |
| [`DefaultErrorWidget`](../../lib/core/widgets/state_ui/default_error_widget.dart) | Preset: error icon in `colorScheme.error` + localized generic message + optional retry. | The whole-screen error state. Takes `(error, stackTrace)` positionally so it drops straight into `AsyncValue.when`; shows the localized generic message rather than `error.toString()`. |

## Snippets (the non-obvious ones)

**Async screen — loading / error / empty pattern**

```dart
final state = ref.watch(itemsProvider);

return state.when(
  // The real list, fed placeholders, drawn as bones (presentation.md).
  loading: () => AppSkeleton(
    enabled: true,
    child: ItemsList(items: ItemEntity.placeholders(6)),
  ),
  error: (error, stackTrace) => DefaultErrorWidget(
    error,
    stackTrace,
    onRetry: () => ref.invalidate(itemsProvider),
  ),
  data: (items) => items.isEmpty
      ? EmptyState(title: context.l10n.noItemsFoundError)
      : ItemsList(items: items),
);
```

**Transient action failure — snackbar, not a full-screen error**
(from [login_screen.dart](../../lib/features/auth/presentation/screens/login_screen.dart))

```dart
ref.listen<AsyncValue<void>>(loginProvider, (previous, next) {
  if (next is AsyncError) {
    final error = next.error;
    if (error is Failure) {
      context.showFailure(error);                       // localized, central switch
    } else {
      AppMessenger.show(context.l10n.defaultErrorMessage, type: MessageType.error);
    }
  }
});
```

`DefaultErrorWidget` when the screen's *content* failed to load; `context.showFailure(failure)`
when an *action* failed on a screen that still renders. `AppMessenger.show(String, type:, action:)` is
the escape hatch for non-`Failure` messages.

**Paged list**

```dart
class ItemsScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final search = useDebouncedSearch();
    final controller = usePagingControllerEither<ItemEntity>(
      listen: (page) => ref.read(getItemsUseCaseProvider).call(
        ItemsParams(page: page, query: search.debounced, limit: defaultLimitSize),
      ),
      keys: [search.debounced],          // recreate + reset when the query changes
    );

    return PagedListView<int, ItemEntity>(
      pagingController: controller,
      builderDelegate: controller.defaultListDelegate(
        context: context,
        itemBuilder: (context, item, index) => ItemTile(item),
      ),
    );
  }
}
```

**Paged picker in a sheet** (what
[`CustomPaginatedDropdownFormField`](../../lib/core/widgets/form_fields/custom_paginated_drop_down_form_fied.dart)
does)

```dart
await customModalBottomSheet(
  context,
  child: PaginatedBottomSheet<CityEntity>(
    titleText: context.l10n.select,
    pagingController: controller,          // created by the caller's hook
    labelBuilder: (city) => city.name,
    onSearch: (query) => queryNotifier.value = query,   // sheet then calls refresh()
    onSelect: (city) {
      selection.value = city;
      GoRouter.of(context).pop();
    },
  ),
);
```

**Form screen**

```dart
Scaffold(
  body: FormBody(
    formKey: formKey,
    children: [
      CustomTextFormField(
        controller: phoneController,
        hintText: '7xxxxxxxxx',
        inputFormatters: [englishDigitsOnly],
        validator: context.validator.required().phone().build(),
      ),
    ],
    actions: [
      FilledLoadingButton(
        onPressed: submit,
        isLoading: state.isLoading,
        child: Text(context.l10n.login),
      ),
    ],
  ),
)
```

`context.validator` ([common_extensions.dart](../../lib/core/utils/extensions/common_extensions.dart))
returns a `form_validator` builder already wired to the localized `AppFormValidatorLocale`.
`formKey.isNotValid()` is the guard idiom.

## Hooks-based widgets

`HookConsumerWidget`: `CustomDatePickerFormField`, `CustomTimePickerFormField`,
`CustomPaginatedDropdownFormField`, `PaginatedBottomSheet`, `CustomDialog`. Their
hooks are internal — **callers don't need to be hook widgets**.

You must be in a `HookWidget` / `HookConsumerWidget` / `StatefulHookConsumerWidget`
yourself to call `usePagingController`, `usePagingControllerEither`,
`useDebouncedSearch`, `useDebounce`, `useTextEditingController`, `useFocusNode`,
`useMemoized`, `useEffect`. Standard hook rules apply: call unconditionally, never
inside a loop or `if`, same order every build.
