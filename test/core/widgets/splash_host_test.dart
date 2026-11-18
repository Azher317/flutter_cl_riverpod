import 'package:app/core/utils/constants/route_names.dart';
import 'package:app/core/utils/constants/sizes.dart';
import 'package:app/core/widgets/branding/splash_host.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _Location extends ChangeNotifier {
  String value = RouteNames.splash;

  void go(String to) {
    value = to;
    notifyListeners();
  }
}

void main() {
  Future<_Location> pump(WidgetTester tester) async {
    final location = _Location();
    await tester.pumpWidget(
      MaterialApp(
        home: SplashHost(
          routeChanges: location,
          location: () => location.value,
          logo: const Text('logo'),
          child: const Text('app'),
        ),
      ),
    );
    await tester.pump();
    return location;
  }

  testWidgets('stays up while the router holds on splash', (tester) async {
    await pump(tester);
    await tester.pump(const Duration(seconds: 5));
    expect(find.text('logo'), findsOneWidget);
  });

  testWidgets('leaves after the router leaves splash, never before the '
      'minimum', (tester) async {
    final location = await pump(tester);
    location.go(RouteNames.home);
    await tester.pump(Time.splashMinimum ~/ 2);
    expect(find.text('logo'), findsOneWidget);
    await tester.pump(Time.splashMinimum);
    await tester.pumpAndSettle();
    expect(find.text('logo'), findsNothing);
    expect(find.text('app'), findsOneWidget);
  });
}
