import 'package:app/core/l10n/generated/app_localizations.dart';
import 'package:app/router/app_shell.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/pump_app.dart';

class _Counter extends StatefulWidget {
  const _Counter(this.name);

  final String name;

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: TextButton(
      onPressed: () => setState(() => count++),
      child: Text('${widget.name} $count'),
    ),
  );
}

GoRouter _router() => GoRouter(
  initialLocation: '/a',
  routes: [
    StatefulShellRoute(
      builder: (context, state, shell) => shell,
      navigatorContainerBuilder: (context, shell, children) => AppShell(
        shell: shell,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'A'),
          NavigationDestination(icon: Icon(Icons.person), label: 'B'),
        ],
        children: children,
      ),
      branches: [
        StatefulShellBranch(
          routes: [GoRoute(path: '/a', builder: (_, _) => const _Counter('a'))],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/b', builder: (_, _) => const _Counter('b'))],
        ),
      ],
    ),
  ],
);

Future<void> _pump(WidgetTester tester, Size size) async {
  setWindowSize(tester, size);
  await tester.pumpWidget(
    MaterialApp.router(
      routerConfig: _router(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('phone: a bottom bar; each tab keeps its state', (tester) async {
    await _pump(tester, const Size(390, 844));
    expect(find.byType(NavigationBar), findsOneWidget);
    await tester.tap(find.text('a 0'));
    await tester.pump();
    await tester.tap(find.text('B'));
    await tester.pumpAndSettle();
    expect(find.text('b 0'), findsOneWidget);
    await tester.tap(find.text('A'));
    await tester.pumpAndSettle();
    expect(find.text('a 1'), findsOneWidget);
  });

  testWidgets('tablet: a rail instead of the bottom bar', (tester) async {
    await _pump(tester, const Size(1024, 768));
    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });
}
