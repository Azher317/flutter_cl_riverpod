import 'package:app/core/config/debug_tools.dart';
import 'package:app/core/utils/constants/route_names.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The one way into the logs screen. Put it in the app's settings screen,
/// once; never add a second entry point.
///
/// Shown in debug builds and in builds that talk to a non-production server
/// ([showDebugTools]); renders nothing in prod.
class DebugLogsTile extends StatelessWidget {
  const DebugLogsTile({super.key});

  @override
  Widget build(BuildContext context) {
    if (!showDebugTools) return const SizedBox.shrink();
    return ListTile(
      leading: const Icon(Icons.bug_report_outlined),
      // Developer-only tool, never shown to store users: not localized.
      title: const Text('Logs'), // ignore: avoid_hardcoded_strings
      onTap: () => context.push(RouteNames.logs),
    );
  }
}
