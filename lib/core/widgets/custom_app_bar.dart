import 'package:app/core/extensions/theme_extentions.dart';
import 'package:app/core/theme/sizes.dart';
import 'package:app/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum LeadingButton { flatIcon, elevatedIcon }

AppBar customAppBar(
  BuildContext context, {
  Widget? title,
  List<Widget>? actions,
  double? borderRadius,
  required LeadingButton leading,
  EdgeInsets? padding,
}) {
  return AppBar(
    clipBehavior: Clip.none,
    forceMaterialTransparency: true,
    // automaticallyImplyLeading: false,
    leadingWidth: 69,
    leading: Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.medium),
      child: leading == LeadingButton.elevatedIcon
          ? IconButton(
              style: IconButton.styleFrom(
                // padding: EdgeInsets.symmetric(horizontal: Insets.medium),
                fixedSize: Size(45, 45),
                backgroundColor: context.colorScheme.secondary,
                foregroundColor: context.colorScheme.onSurface,
                overlayColor: context.colorScheme.primary.withValues(
                  alpha: 0.12,
                ),
                shape: const CircleBorder(),
              ),
              onPressed: () {
                if (GoRouter.of(context).canPop()) {
                  GoRouter.of(context).pop();
                } else {
                  GoRouter.of(context).go(RoutesDocument.home);
                }
              },
              icon: Icon(Icons.arrow_back_rounded, size: 20),
            )
          : IconButton(
              style: IconButton.styleFrom(
                overlayColor: context.colorScheme.primary.withValues(
                  alpha: 0.12,
                ),
                shape: const CircleBorder(),
              ),
              onPressed: () {
                if (GoRouter.of(context).canPop()) {
                  GoRouter.of(context).pop();
                } else {
                  GoRouter.of(context).go(RoutesDocument.home);
                }
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            ),
    ),
    title: title,
    centerTitle: true,
    actions: actions,
  );
}

SliverAppBar customSliverAppBar(
  BuildContext context, {
  Widget? title,
  List<Widget>? actions,
  double? borderRadius,
  required LeadingButton leading,
  EdgeInsets? padding,
}) {
  return SliverAppBar(
    clipBehavior: Clip.none,
    forceMaterialTransparency: true,
    // automaticallyImplyLeading: false,
    leadingWidth: 67,
    leading: Padding(
      padding: EdgeInsets.symmetric(horizontal: Insets.large),
      child: leading == LeadingButton.elevatedIcon
          ? IconButton(
              style: IconButton.styleFrom(
                fixedSize: Size(45, 45),
                backgroundColor: context.colorScheme.secondary,
                foregroundColor: context.colorScheme.onSurface,
                overlayColor: context.colorScheme.primary.withValues(
                  alpha: 0.12,
                ),
                shape: const CircleBorder(),
              ),
              onPressed: () {
                if (GoRouter.of(context).canPop()) {
                  GoRouter.of(context).pop();
                } else {
                  GoRouter.of(context).go(RoutesDocument.home);
                }
              },
              icon: Icon(Icons.arrow_back_rounded, size: 20),
            )
          : IconButton(
              style: IconButton.styleFrom(
                overlayColor: context.colorScheme.primary.withValues(
                  alpha: 0.12,
                ),
                shape: const CircleBorder(),
              ),
              onPressed: () {
                if (GoRouter.of(context).canPop()) {
                  GoRouter.of(context).pop();
                } else {
                  GoRouter.of(context).go(RoutesDocument.home);
                }
              },
              icon: Icon(Icons.arrow_back_ios_new_rounded, size: 18),
            ),
    ),
    title: title,
    centerTitle: true,
    actions: actions,
  );
}
