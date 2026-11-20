import 'package:app/core/layout/window_layout.dart';
import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/widgets/layout/content_box.dart';
import 'package:app/core/widgets/layout/two_pane.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';
import '../../helpers/screen_sizes.dart';

void main() {
  test('margins and columns follow the window width', () {
    expect(const WindowLayout(375).screenInset, Insets.screen);
    expect(const WindowLayout(834).screenInset, Insets.screenTablet);
    expect(const WindowLayout(375).columns(343, minItemWidth: 160), 1);
    expect(const WindowLayout(834).columns(786, minItemWidth: 240), 3);
  });

  test('content is capped by padding, never narrower than the margin', () {
    expect(ContentBox.sidePadding(375, inset: 16), 16);
    expect(ContentBox.sidePadding(1194, inset: 24), (1194 - 1040) / 2);
  });

  testAtScreenSizes('TwoPane splits only on a wide window', (
    tester,
    size,
  ) async {
    await pumpApp(
      tester,
      const TwoPane(start: Text('list'), end: Text('details'), endWidth: 320),
      size: size,
    );
    expect(tester.takeException(), isNull); // no overflow
    expect(
      find.text('details'),
      size.width >= Layout.twoPaneMinWidth ? findsOneWidget : findsNothing,
    );
  }, tablets: true);
}
