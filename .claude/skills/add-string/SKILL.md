---
name: add-string
description: Add or change user-visible text. Use for any new label, message, button or error text, so the key lands in every language file the app ships.
---

# Add a string

1. List the app's languages: the files in `lib/l10n/arb/` (`app_ar.arb`,
   `app_en.arb`, `app_ku.arb` as present). Every one gets the key.
2. Add the key in camelCase, named for its meaning, not its screen
   (`deleteAddressConfirm`, not `screen3Text`). Search first: an existing key
   with the same meaning is reused, not duplicated.
3. Placeholders need an `@key` block in the template ARB (named in
   `l10n.yaml`), e.g. `"@greeting": {"placeholders": {"name": {"type": "String"}}}`.
   Plain strings need no `@key` block.
4. Write each language properly: Arabic in Arabic, Kurdish in Sorani (Arabic
   script). If you can't write a language well, say so instead of guessing.
5. Run `flutter gen-l10n` and use it as `context.l10n.<key>`.
6. `untranslated_messages.txt` must list nothing for the new key.
