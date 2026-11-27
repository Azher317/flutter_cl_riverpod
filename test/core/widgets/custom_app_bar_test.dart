import 'package:app/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

/// Whether the back arrow is drawn mirrored (pointing right).
bool _arrowIsMirrored(WidgetTester tester) {
  final transforms = tester.widgetList<Transform>(
    find.descendant(of: find.byType(Icon), matching: find.byType(Transform)),
  );
  return transforms.any((t) => t.transform.storage[0] == -1);
}

void main() {
  for (final leading in LeadingButton.values) {
    group('back arrow (${leading.name})', () {
      Widget appBar() => Builder(
        builder: (context) =>
            Scaffold(appBar: customAppBar(context, leading: leading)),
      );

      testWidgets('Arabic (right-to-left): points right', (tester) async {
        await pumpApp(tester, appBar());
        expect(_arrowIsMirrored(tester), isTrue);
      });

      testWidgets('English (left-to-right): points left', (tester) async {
        await pumpApp(tester, appBar(), locale: const Locale('en'));
        expect(_arrowIsMirrored(tester), isFalse);
      });
    });
  }

  // Guards the check itself: an icon that has no direction is not mirrored
  // in Arabic, so "mirrored" above really means the arrow flipped.
  testWidgets('a non-directional icon is not mirrored in Arabic', (
    tester,
  ) async {
    await pumpApp(tester, const Icon(Icons.home_rounded));
    expect(_arrowIsMirrored(tester), isFalse);
  });
}
