---
name: add-endpoint
description: Add one API call to a feature that already exists (for example "add GET /orders/{id}" or "call the cancel endpoint"). Use instead of add-feature when the feature folder is already there.
argument-hint: <feature> <METHOD /path>
---

# Add an endpoint to an existing feature

Arguments: `$ARGUMENTS` (the feature, then the method and path).

1. **Ask: "Is the backend for this endpoint ready?"**
   - Ready: read its request and response in `docs/api/`.
   - Not ready: write `docs/api/drafts/<feature>.md` first and follow "Fake
     data" in `.claude/rules/data-layer.md`.
2. **Endpoint constant** in `lib/core/network/endpoints.dart`.
3. **Model** in `data/models/` (Freezed + json_serializable, with
   `.toEntity()`). Dates use `NullableDateTimeConvertor`.
4. **Data source method** calling `ApiConsumer`; it already receives the
   unwrapped payload (`ApiEnvelope.data`). For a page, parse with
   `ApiEnvelope.page(payload, Model.fromJson)` (snippet `clr-data-api-method-paged`).
   User-only data makes no call for a guest (rule 20).
5. **Repository method** wrapped in `guard()`; add it to the domain contract.
6. **Usecase** (one per operation) and its provider in `di/`.
7. **Notifier action**: `AsyncLoading`, then `.fold()` the `Either`.
8. **Tests**: the repository's failure paths, and the notifier.
9. Run the `verify` skill.

Snippets for each step are listed in the `add-feature` skill.
