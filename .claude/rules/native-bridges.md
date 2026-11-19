---
paths:
  - "ios/Runner/**"
  - "android/app/src/main/**"
  - "lib/core/**/*channel*.dart"
  - "lib/core/**/*bridge*.dart"
---

# Native bridges (platform channels)

Every call returns one of three results, and the Dart side keeps them apart:

- **found**, with the value;
- **not found**, a real "there is none";
- **error**, with the platform's error code and message.

Never return `nil`/`null` for an error. A keychain or keystore that fails for a
moment is an error, not "no key": treating it as "no key" once told real users
to register again (Basmah). Show the error code in a hidden diagnostics line
so field reports can name it.
