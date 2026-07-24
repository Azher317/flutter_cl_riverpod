---
paths:
  - "lib/core/utils/**"
  - "lib/core/models/**"
---

# Shared utilities (`lib/core/utils/`)

`either.dart` (the local `Either`), `annotations/` (shared `@freezed` /
`@JsonSerializable` presets with a full parameter glossary), `constants/`
(`assets.dart`, `sizes.dart`), `extensions/` (`context.l10n`, `context.theme`,
`context.validator`, `context.width/height`, `formKey.isNotValid()`, date/string
helpers), `formatters/`, `hooks/` (`useDebounce`, `useDebouncedSearch`), and
`validation/` (regexes + `TextInputFormatter`s such as `englishDigitsOnly`).

`core/models/` holds wire-format helpers: `json_types.dart` typedefs,
`phone_number.dart`, and `_models.dart` (barrel). `core/network/convertors/` holds
`JsonConverter`s for nullable/sentinel wire values and multipart uploads.
