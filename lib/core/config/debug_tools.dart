import 'package:app/core/network/api_document.dart';
import 'package:flutter/foundation.dart';

/// Developer tools (console logs, log history, the logs screen) are on in
/// debug builds and in any build that talks to a non-production server.
///
/// A compile-time constant: a prod release build drops everything it guards.
const bool showDebugTools = kDebugMode || ApiDocument.env != 'prod';
