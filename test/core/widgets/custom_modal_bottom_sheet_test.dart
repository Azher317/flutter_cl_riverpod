import 'package:app/core/widgets/overlay/custom_modal_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  Future<void> openSheet(
    WidgetTester tester, {
    bool disableAnimations = false,
    Size size = const Size(390, 844),
  }) async {
    await pumpApp(
      tester,
      Builder(
        builder: (context) => TextButton(
          onPressed: () => customModalBottomSheet<void>(
            context,
            height: 200,
            child: const Text('sheet'),
          ),
          child: const Text('open'),
        ),
      ),
      disableAnimations: disableAnimations,
      size: size,
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    expect(find.text('sheet'), findsOneWidget);
  }

  testWidgets('a phone sheet leans the screen behind it back', (
    tester,
  ) async {
    await openSheet(tester);
    expect(find.byType(SheetBackdropLean), findsOneWidget);
  });

  testWidgets('reduced motion: the screen behind stays still', (
    tester,
  ) async {
    await openSheet(tester, disableAnimations: true);
    expect(find.byType(SheetBackdropLean), findsNothing);
  });

  testWidgets('a tablet: the screen behind stays still', (tester) async {
    await openSheet(tester, size: const Size(900, 1200));
    expect(find.byType(SheetBackdropLean), findsNothing);
  });
}
