import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/constants/sizes.dart';
import 'package:app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum LeadingButton { flatIcon, elevatedIcon }

AppBar customAppBar(
  BuildContext context, {
  Widget? title,
  List<Widget>? actions,
  required LeadingButton leading,
  EdgeInsets? padding,
}) {
  return AppBar(
    clipBehavior: Clip.none,
    forceMaterialTransparency: true,
    leadingWidth: 69,
    leading: Padding(
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: Insets.medium),
      child: _leadingButton(context, leading),
    ),
    title: title,
    centerTitle: true,
    actions: actions,
  );
}

Widget _leadingButton(BuildContext context, LeadingButton leading) {
  final isElevated = leading == LeadingButton.elevatedIcon;

  return IconButton(
    style: IconButton.styleFrom(
      fixedSize: isElevated ? const Size(45, 45) : null,
      backgroundColor: isElevated ? context.colorScheme.secondary : null,
      foregroundColor: isElevated ? context.colorScheme.onSurface : null,
      overlayColor: context.colorScheme.primary.withValues(alpha: 0.12),
      shape: const CircleBorder(),
    ),
    onPressed: () => _onBack(context),
    icon: isElevated
        ? const Icon(Icons.arrow_back_rounded, size: 20)
        : const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
  );
}

void _onBack(BuildContext context) {
  final router = GoRouter.of(context);
  if (router.canPop()) {
    router.pop();
  } else {
    router.go(RoutesDocument.home);
  }
}
