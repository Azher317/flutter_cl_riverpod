import 'package:app/core/widgets/state_ui/app_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  testWidgets('loading: the real widget is drawn as bones, hidden from '
      'screen readers', (tester) async {
    final semantics = tester.ensureSemantics();
    await pumpApp(
      tester,
      const AppSkeleton(enabled: true, child: Text('Placeholder title')),
      disableAnimations: true,
    );
    expect(find.bySemanticsLabel('Placeholder title'), findsNothing);
    semantics.dispose();
  });

  testWidgets('loaded: the same widget, same size', (tester) async {
    await pumpApp(
      tester,
      const AppSkeleton(enabled: true, child: SizedBox(width: 120, height: 40)),
      disableAnimations: true,
    );
    final loading = tester.getSize(find.byType(SizedBox).last);
    await pumpApp(
      tester,
      const AppSkeleton(enabled: false, child: SizedBox(width: 120, height: 40)),
    );
    expect(tester.getSize(find.byType(SizedBox).last), loading);
  });
}
