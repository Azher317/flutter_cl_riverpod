import 'package:app/core/observability/console_printer.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

String _first(OneLinePrinter printer, Level level, Object message) =>
    printer.log(LogEvent(level, message)).first;

void main() {
  final colored = OneLinePrinter();
  final plain = OneLinePrinter(colors: false);

  test('paints only the HTTP status, in the colour it was given', () {
    const message = TaggedMessage(
      'HTTP',
      'GET  /api/home  404  12ms\n  response: {"a":1}',
      highlight: '404',
      highlightColor: ConsoleColor.red,
    );

    final lines = colored.log(LogEvent(Level.warning, message));

    expect(
      lines.first,
      endsWith('HTTP  GET  /api/home  ${ConsoleColor.red.paint('404')}  12ms'),
    );
    expect(lines[1], '  response: {"a":1}');
  });

  test('paints error, warning and route tags; info stays plain', () {
    expect(
      _first(colored, Level.error, 'x'),
      contains(ConsoleColor.red.paint('ERROR')),
    );
    expect(
      _first(colored, Level.warning, 'x'),
      contains(ConsoleColor.orange.paint('WARN ')),
    );
    expect(
      _first(
        colored,
        Level.info,
        const TaggedMessage('ROUTE', 'Open /', tagColor: ConsoleColor.dim),
      ),
      contains(ConsoleColor.dim.paint('ROUTE')),
    );
    expect(
      _first(colored, Level.info, 'Signed in'),
      endsWith('INFO  Signed in'),
    );
  });

  test('with colours off there are no escape codes', () {
    const message = TaggedMessage(
      'HTTP',
      'GET  /api/home  500  12ms',
      highlight: '500',
      highlightColor: ConsoleColor.orange,
    );

    expect(_first(plain, Level.warning, message), isNot(contains('\x1B')));
    expect(_first(plain, Level.error, 'x'), isNot(contains('\x1B')));
  });
}
