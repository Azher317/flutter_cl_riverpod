import 'package:app/core/l10n/generated/app_localizations.dart';
import 'package:app/core/permissions/permission_flow.dart';
import 'package:app/core/permissions/permission_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeService implements PermissionService {
  _FakeService(this.current, {this.afterRequest = AppPermissionStatus.granted});

  AppPermissionStatus current;
  final AppPermissionStatus afterRequest;
  int requests = 0;

  @override
  Future<AppPermissionStatus> status(AppPermission permission) async => current;

  @override
  Future<AppPermissionStatus> request(AppPermission permission) async {
    requests++;
    return current = afterRequest;
  }

  @override
  Future<bool> openSettings() async => true;
}

Future<Future<bool>> _start(WidgetTester tester, _FakeService service) async {
  late Future<bool> result;
  await tester.pumpWidget(
    ProviderScope(
      overrides: [permissionServiceProvider.overrideWithValue(service)],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Consumer(
          builder: (context, ref, _) => TextButton(
            onPressed: () => result = ensurePermission(
              context,
              ref,
              AppPermission.camera,
              reason: 'To scan codes',
            ),
            child: const Text('scan'),
          ),
        ),
      ),
    ),
  );
  await tester.tap(find.text('scan'));
  await tester.pumpAndSettle();
  return result;
}

void main() {
  testWidgets('already granted: true, nothing shown', (tester) async {
    final service = _FakeService(AppPermissionStatus.granted);
    final result = await _start(tester, service);
    expect(find.byType(AlertDialog), findsNothing);
    expect(await result, isTrue);
  });

  testWidgets('"Not now": the OS prompt is never shown', (tester) async {
    final service = _FakeService(AppPermissionStatus.denied);
    final result = await _start(tester, service);
    expect(find.text('To scan codes'), findsOneWidget);
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(await result, isFalse);
    expect(service.requests, 0);
  });

  testWidgets('"Continue" then a no in the prompt: false, no second dialog', (
    tester,
  ) async {
    final service = _FakeService(
      AppPermissionStatus.denied,
      afterRequest: AppPermissionStatus.permanentlyDenied,
    );
    final result = await _start(tester, service);
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(await result, isFalse);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('refused for good earlier: offers Settings, "Not now" is fine', (
    tester,
  ) async {
    final service = _FakeService(AppPermissionStatus.permanentlyDenied);
    final result = await _start(tester, service);
    expect(find.text('Open Settings'), findsOneWidget);
    await tester.tap(find.text('Not now'));
    await tester.pumpAndSettle();
    expect(await result, isFalse);
  });
}
