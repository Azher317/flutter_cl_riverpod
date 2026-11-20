import 'package:app/core/observability/app_logger.dart';
import 'package:app/core/observability/console_printer.dart';
import 'package:app/core/observability/error_reporter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

class _FakeReporter implements ErrorReporter {
  final errors = <(Object, bool)>[];

  @override
  void recordError(
    Object error,
    StackTrace? stackTrace, {
    String? reason,
    bool fatal = false,
  }) => errors.add((error, fatal));

  @override
  void log(String message) {}
}

/// The console lines the real logger would print.
class _CaptureOutput extends LogOutput {
  final lines = <String>[];

  @override
  void output(OutputEvent event) => lines.addAll(event.lines);
}

final _time = RegExp(r'^\d\d:\d\d:\d\d ');

void main() {
  late _FakeReporter reporter;
  late _CaptureOutput console;

  setUp(() {
    reporter = _FakeReporter();
    console = _CaptureOutput();
    AppLogger.useReporter(reporter);
    AppLogger.useConsoleOutput(console);
  });

  tearDown(() {
    AppLogger.useReporter(const NoopErrorReporter());
    AppLogger.useConsoleOutput(null);
  });

  test('errors reach the reporter; warnings and info do not', () {
    AppLogger.info('hello');
    AppLogger.warning('careful');
    AppLogger.handle(StateError('boom'), StackTrace.current, 'handled');

    expect(reporter.errors, hasLength(1));
    expect(reporter.errors.single.$2, isFalse);
  });

  test('info and warning print one tagged line each', () {
    AppLogger.info('Signed in');
    AppLogger.warning('Request cancelled');

    expect(console.lines, hasLength(2));
    expect(console.lines[0], matches(_time));
    expect(console.lines[0], endsWith('INFO  Signed in'));
    expect(console.lines[1], endsWith('WARN  Request cancelled'));
  });

  test('an error prints its message, the error and at most 8 frames', () {
    AppLogger.error(
      'Upload failed',
      StateError('disk full'),
      StackTrace.current,
    );

    expect(console.lines.first, contains('ERROR Upload failed: '));
    expect(console.lines.first, contains('disk full'));
    expect(console.lines.length, inInclusiveRange(2, 9));
    expect(console.lines.skip(1), everyElement(startsWith('  ')));
  });

  test('a stack trace passed as the error does not throw', () {
    AppLogger.error('Oops', StackTrace.current);

    expect(console.lines.first, endsWith('ERROR Oops'));
    expect(reporter.errors, hasLength(1));
  });

  test('a framework error Flutter already printed is not printed again', () {
    AppLogger.fatal(
      StateError('layout'),
      StackTrace.current,
      'FlutterError',
      printedByFlutter: true,
    );

    expect(console.lines, isEmpty);
    expect(reporter.errors.single.$2, isTrue);
  });

  test('an uncaught error prints as FATAL and is reported as fatal', () {
    AppLogger.fatal(StateError('boom'), null, 'Uncaught async error');

    expect(console.lines.single, contains('FATAL Uncaught async error: '));
    expect(reporter.errors.single.$2, isTrue);
  });

  test('network and route lines carry their own tags', () {
    AppLogger.network('GET  /api/home  200  41ms', failed: false);
    AppLogger.route('Open /login');

    expect(console.lines[0], endsWith('HTTP  GET  /api/home  200  41ms'));
    expect(console.lines[1], endsWith('ROUTE Open /login'));
  });

  test('the console output splits very long lines', () {
    final printed = <String?>[];
    final previous = debugPrint;
    debugPrint = (message, {wrapWidth}) => printed.add(message);
    addTearDown(() => debugPrint = previous);

    PlatformConsoleOutput(
      maxLineLength: 10,
    ).output(OutputEvent(LogEvent(Level.info, ''), ['a' * 25, '']));

    expect(printed, ['a' * 10, 'a' * 10, 'a' * 5, '']);
  });
}
