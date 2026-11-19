import 'package:app/core/observability/app_logger.dart';
import 'package:app/core/observability/error_reporter.dart';
import 'package:flutter_test/flutter_test.dart';

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

void main() {
  late _FakeReporter reporter;

  setUp(() {
    reporter = _FakeReporter();
    AppLogger.useReporter(reporter);
    talker.cleanHistory();
  });

  tearDown(() => AppLogger.useReporter(const NoopErrorReporter()));

  test('errors reach the reporter; warnings and info do not', () {
    AppLogger.info('hello');
    AppLogger.warning('careful');
    AppLogger.handle(StateError('boom'), StackTrace.current, 'handled');

    expect(reporter.errors, hasLength(1));
    expect(reporter.errors.single.$2, isFalse);
  });

  test('a framework error is fatal and still kept for the logs screen', () {
    AppLogger.fatal(
      StateError('layout'),
      StackTrace.current,
      'FlutterError',
      printedByFlutter: true,
    );

    expect(reporter.errors.single.$2, isTrue);
    expect(talker.history, isNotEmpty);
  });
}
