import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// The window sizes every screen is checked at for overflow: the two small
/// phones the apps target, and (tablet layer) an iPad in both orientations.
const phoneSizes = <String, Size>{
  'phone 375x667': Size(375, 667),
  'phone 360x640': Size(360, 640),
};

const tabletSizes = <String, Size>{
  'tablet 834x1194': Size(834, 1194),
  'tablet 1194x834': Size(1194, 834),
};

/// Runs [body] once per size as its own test, so a failure names the size.
/// Pass [tablets] for apps that support tablets.
void testAtScreenSizes(
  String description,
  Future<void> Function(WidgetTester tester, Size size) body, {
  bool tablets = false,
}) {
  final sizes = {...phoneSizes, if (tablets) ...tabletSizes};
  for (final entry in sizes.entries) {
    testWidgets(
      '$description (${entry.key})',
      (tester) => body(tester, entry.value),
    );
  }
}
