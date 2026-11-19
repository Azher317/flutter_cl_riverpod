---
name: new-app
description: Start a new app from this structure. Only when the user calls it by name or says "start a new app called X".
disable-model-invocation: true
argument-hint: <app-name>
---

# Start a new app

The script `bin/new_app.sh` does the work. Ask the user these questions in
chat, in this order, one message with all of them (app name: `$ARGUMENTS`):

1. App name (lowercase, used for the folder)
2. Which folder to create it in (it must exist; the script makes
   `<folder>/<name>` and stops if that already exists)
3. Display name (under the icon)
4. Bundle id
5. Languages: any of `ar`, `en`, `ku`
6. Does the app have sign-in? If yes: guest mode or sign-in required
7. Phone numbers: Iraq only or international
8. Tablets: yes or no
9. Git remote (optional)

Then feed the answers to the script in that order. The sign-in follow-up line
is left out when there is no sign-in:

```bash
printf '%s\n' "<name>" "<folder>" "<display>" "<bundle>" "<langs>" "<y|n>" \
  "<1 guest|2 required, only if y>" "<1 iraq|2 intl>" "<y|n>" "<remote or empty>" \
  | ~/Developer/structores/flutter_cl_riverpod/bin/new_app.sh
```

Report the script's ✓ lines and the "Left for you" list. Never change the
structure repo itself.
