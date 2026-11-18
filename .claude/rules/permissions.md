---
paths:
  - "lib/**"
---

# Permissions

Runtime permissions (camera, location, notifications, …) follow
[docs/permissions.md](../../docs/permissions.md):

1. **Ask Azher first, for every permission: optional or required?** Don't add a
   permission, an `ensurePermission` call, or a Podfile / Info.plist / manifest entry
   until he has answered. Never assume required.
2. Only through `ensurePermission(...)`, at the moment the user taps the feature. Never
   on launch, never the plugin directly, never re-asked without a new tap.
3. Refusal never blocks the app: optional features show their alternative; required
   ones stay unavailable with a short note.
4. The structure ships no permission plugin (opt-in). Setting it up in an app is the
   checklist in docs/permissions.md.
