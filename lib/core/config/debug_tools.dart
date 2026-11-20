import 'package:app/core/network/api_document.dart';
import 'package:flutter/foundation.dart';

/// Developer tools (console logs, the Dio and route loggers) are on in debug
/// builds and in any build that talks to a non-production server.
///
/// A compile-time constant: a prod release build drops everything it guards.
const bool showDebugTools = kDebugMode || ApiDocument.env != 'prod';

/// Print the request and response body of every HTTP call, not only of the
/// failed ones: `--dart-define=LOG_BODIES=true`. Use it when an endpoint
/// returns 200 with the wrong data. Has no effect without [showDebugTools].
const bool logAllBodies = bool.fromEnvironment('LOG_BODIES');
