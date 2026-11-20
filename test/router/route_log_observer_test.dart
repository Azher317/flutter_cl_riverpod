import 'package:app/core/observability/app_logger.dart';
import 'package:app/router/route_log_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

class _CaptureOutput extends LogOutput {
  final lines = <String>[];

  @override
  void output(OutputEvent event) => lines.addAll(event.lines);
}

Route<void> _route(String? name) => MaterialPageRoute<void>(
  settings: RouteSettings(name: name),
  builder: (_) => const SizedBox(),
);

void main() {
  late _CaptureOutput console;

  setUp(() {
    console = _CaptureOutput();
    AppLogger.useConsoleOutput(console);
  });

  tearDown(() => AppLogger.useConsoleOutput(null));

  test('named routes print Open and Back to; unnamed ones are skipped', () {
    final observer = RouteLogObserver();
    final home = _route('/');
    final login = _route('/login');

    observer
      ..didPush(home, null)
      ..didPush(login, home)
      ..didPush(_route(null), login)
      ..didPop(login, home);

    expect(console.lines.map((l) => l.substring(9)), [
      'ROUTE Open /',
      'ROUTE Open /login',
      'ROUTE Back to /',
    ]);
  });
}
