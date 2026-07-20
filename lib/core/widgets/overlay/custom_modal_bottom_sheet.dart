import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/utils/extensions/common_extensions.dart';
import 'package:app/core/utils/extensions/theme_extentions.dart';
import 'package:app/core/widgets/break_line.dart';
import 'package:flutter/material.dart';

Future<dynamic> customModalBottomSheet(
  BuildContext context, {
  bool isDismissible = true,
  bool isScrollControlled = false,
  bool showDragHandle = false,
  double? height,
  double? width,
  required Widget child,
}) {
  return showModalBottomSheet(
    context: context,
    clipBehavior: Clip.hardEdge,
    isScrollControlled: isScrollControlled,
    scrollControlDisabledMaxHeightRatio: 0.75,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    useRootNavigator: true,
    showDragHandle: false,

    backgroundColor: context.colorScheme.surface,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(BorderSize.medium),
        topRight: Radius.circular(BorderSize.medium),
      ),
    ),
    builder: (context) => SizedBox(
      height: height ?? MediaQuery.of(context).size.height * 0.75,
      width: width ?? context.width,
      child: Column(
        children: [
          if (showDragHandle) BreakLine(width: context.width * 0.5, height: 4),
          Expanded(child: child),
        ],
      ),
    ),
  );
}
