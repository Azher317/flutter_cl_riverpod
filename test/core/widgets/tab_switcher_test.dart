import 'package:app/core/widgets/animation/tab_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('a tab is built only when first chosen, then kept', (
    tester,
  ) async {
    final built = <int>[];
    Widget switcher(int index) => TabSwitcher(
      index: index,
      count: 3,
      builder: (context, i) {
        built.add(i);
        return Text('tab $i');
      },
    );

    await pumpApp(tester, switcher(0), disableAnimations: true);
    expect(built.toSet(), {0});

    await pumpApp(tester, switcher(2), disableAnimations: true);
    await tester.pumpAndSettle();
    expect(built.toSet(), {0, 2}); // tab 1 never built
    expect(find.text('tab 2'), findsOneWidget);
    expect(find.text('tab 0', skipOffstage: false), findsOneWidget); // kept
  });
}
