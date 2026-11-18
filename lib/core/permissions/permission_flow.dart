import 'dart:async';

import 'package:app/core/permissions/permission_service.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// How much a feature needs a permission. Decided per permission by the app
/// owner, never by the developer or an agent alone (docs/permissions.md).
enum PermissionNeed {
  /// The feature has another way (type the code, pick an address). Refusing
  /// is fine: the screen shows that other way. Never asks twice in a row.
  optional,

  /// The feature can't work without it (e.g. a camera-only scanner). Still
  /// never forced by the OS: the user can refuse, and only this feature
  /// stays unavailable; the explanation says so plainly.
  required,
}

/// Asks for [permission] the friendly way and returns whether it's granted.
/// Call it at the moment the feature needs it (a tap), never on launch.
///
/// 1. Already granted → `true`, nothing shown.
/// 2. Not asked yet → a dialog with [reason] and **Continue** / **Not now**.
///    Only Continue shows the OS prompt (iOS shows it once per app).
/// 3. Refused for good → a dialog offering **Open Settings** / **Not now**.
///    After a trip to Settings, the status is read again when the app comes
///    back, and that answer is returned.
///
/// `false` means: show the feature's alternative ([PermissionNeed.optional])
/// or leave it unavailable with a short explanation
/// ([PermissionNeed.required]). Never block the rest of the app, never loop.
Future<bool> ensurePermission(
  BuildContext context,
  WidgetRef ref,
  AppPermission permission, {
  required String reason,
  PermissionNeed need = PermissionNeed.optional,
}) async {
  final service = ref.read(permissionServiceProvider);
  final l10n = context.l10n;

  final status = await service.status(permission);
  if (status == AppPermissionStatus.granted) return true;
  if (!context.mounted) return false;

  if (status == AppPermissionStatus.denied) {
    final proceed = await _ask(
      context,
      title: need == PermissionNeed.required
          ? l10n.permissionRequiredTitle
          : l10n.permissionTitle,
      body: reason,
      confirm: l10n.permissionContinue,
    );
    if (!proceed) return false;
    // A "no" in the OS prompt is respected: no second dialog now (iOS
    // reports it as permanently denied straight away; Settings is offered
    // only on a later tap).
    return await service.request(permission) == AppPermissionStatus.granted;
  }

  // Permanently denied from an earlier visit: offer Settings once per tap.
  if (!context.mounted) return false;
  final open = await _ask(
    context,
    title: l10n.permissionDeniedTitle,
    body: '$reason\n\n${l10n.permissionDeniedBody}',
    confirm: l10n.permissionOpenSettings,
  );
  if (!open) return false;
  final cameBack = _nextResume();
  if (!await service.openSettings()) return false;
  await cameBack;
  return await service.status(permission) == AppPermissionStatus.granted;
}

/// Completes when the app is next resumed (back from Settings).
Future<void> _nextResume() {
  final done = Completer<void>();
  late final AppLifecycleListener listener;
  listener = AppLifecycleListener(
    onResume: () {
      listener.dispose();
      if (!done.isCompleted) done.complete();
    },
  );
  return done.future;
}

Future<bool> _ask(
  BuildContext context, {
  required String title,
  required String body,
  required String confirm,
}) async =>
    await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.permissionNotNow),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(confirm),
          ),
        ],
      ),
    ) ??
    false;
