#!/usr/bin/env bash
# Runs flutter, but hides Android's own system log lines (VRI, SurfaceView,
# InputMethodManager...) so the console shows only the app's lines.
#
#   bin/flutter_quiet.sh run --dart-define-from-file=env/uat.json
#
# Kept: the app's lines (I/flutter), Flutter's own messages, Android errors
# and crashes (E/ and F/ lines), and Java crash traces (AndroidRuntime,
# System.err). Samsung's graphics-driver startup errors (gralloc4...) are
# hidden too. VS Code uses this script through "customTool" in
# .vscode/launch.json. FLUTTER_ALL_LOGS=1 shows everything.

if [[ "${FLUTTER_ALL_LOGS:-}" == "1" ]]; then
  exec flutter "$@"
fi

exec flutter "$@" > >(awk '
  /^[VDIWEF]\/(gralloc4|Gralloc4|GraphicBufferAllocator|AHardwareBuffer) *\(/ { next }
  /"log":"[VDIWEF]\/(gralloc4|Gralloc4|GraphicBufferAllocator|AHardwareBuffer) *\(/ { next }
  /^[VDIW]\/[^(]*\(/ && !/^[VDIW]\/(flutter|DartVM|AndroidRuntime|System\.err) *\(/ { next }
  /"log":"[VDIW]\/[^(]*\(/ && !/"log":"[VDIW]\/(flutter|DartVM|AndroidRuntime|System\.err) *\(/ { next }
  { print; fflush() }
')
