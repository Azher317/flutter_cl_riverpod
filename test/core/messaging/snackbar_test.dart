import 'package:app/core/messaging/snackbar.dart';
import 'package:app/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('a toast with an action still goes away by itself', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        scaffoldMessengerKey: AppMessenger.key,
        home: const Scaffold(),
      ),
    );
    AppMessenger.show(
      'Saved',
      action: SnackBarAction(label: 'Undo', onPressed: () {}),
    );
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsOneWidget);

    await tester.pump(const Duration(seconds: 6));
    await tester.pumpAndSettle();
    expect(find.text('Saved'), findsNothing);
  });
}
