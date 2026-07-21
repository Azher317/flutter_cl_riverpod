import 'package:app/core/utils/extensions/common_extensions.dart';
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
  // Surface, shape and clipping come from `bottomSheetTheme`; everything left
  // here is behaviour or sizing.
  return showModalBottomSheet(
    context: context,
    isScrollControlled: isScrollControlled,
    scrollControlDisabledMaxHeightRatio: 0.75,
    isDismissible: isDismissible,
    enableDrag: isDismissible,
    useRootNavigator: true,
    useSafeArea: true,
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
