import 'package:app/core/observability/console_printer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

String _first(Level level, Object message) =>
    OneLinePrinter().log(LogEvent(level, message)).first;

void main() {
  test('warnings and errors get an emoji after the tag; info stays plain', () {
    expect(_first(Level.warning, 'x'), endsWith('WARN  ⚠️ x'));
    expect(_first(Level.error, 'x'), endsWith('ERROR ❌ x'));
    expect(_first(Level.fatal, 'x'), endsWith('FATAL ❌ x'));
    expect(_first(Level.info, 'Signed in'), endsWith('INFO  Signed in'));
  });

  test('a tagged line keeps its own text and gets no level emoji', () {
    final lines = OneLinePrinter().log(
      LogEvent(
        Level.warning,
        const TaggedMessage(
          'HTTP',
          'GET  /api/home  🔴 404  12ms\n  response: {"a":1}',
        ),
      ),
    );

    expect(lines.first, endsWith('HTTP  GET  /api/home  🔴 404  12ms'));
    expect(lines[1], '  response: {"a":1}');
    expect(
      _first(Level.info, const TaggedMessage('ROUTE', 'Open /')),
      endsWith('ROUTE Open /'),
    );
  });

  test('prints no colour codes', () {
    expect(_first(Level.error, 'x'), isNot(contains('\x1B')));
  });
}
