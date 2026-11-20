import 'package:app/core/config/debug_tools.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Console colours (ANSI). Shown by the `flutter run` terminal and the VS
/// Code and Android Studio consoles; Xcode and logcat print the raw codes.
enum ConsoleColor {
  green('32'),
  orange('38;5;208'),
  red('31'),
  dim('2');

  const ConsoleColor(this.code);

  final String code;

  String paint(String text) => '\x1B[${code}m$text\x1B[0m';
}

/// A message with its own console tag (`HTTP`, `ROUTE`) instead of the one
/// its level gives (`INFO`, `ERROR`). Only the logging wiring creates these.
///
/// [highlight] (an HTTP status) is painted [highlightColor] on the first line.
@immutable
final class TaggedMessage {
  const TaggedMessage(
    this.tag,
    this.text, {
    this.tagColor,
    this.highlight,
    this.highlightColor,
  });

  final String tag;
  final String text;
  final ConsoleColor? tagColor;
  final String? highlight;
  final ConsoleColor? highlightColor;

  @override
  String toString() => text;
}

/// Prints only in debug and UAT builds ([showDebugTools]); a prod release
/// prints nothing.
final class DebugToolsFilter extends LogFilter {
  @override
  bool shouldLog(LogEvent event) => showDebugTools;
}

/// One short line per entry: `23:41:09 INFO  Signed in`.
///
/// With [colors] (on unless `--dart-define=LOG_COLORS=false`), only the tag
/// and an HTTP status are painted: `ERROR`/`FATAL` red, `WARN` orange,
/// `ROUTE` dim. The rest of the line and the body lines stay plain.
///
/// A multi-line message (HTTP bodies) keeps its extra lines under the first.
/// Errors add the error on the first line and the first [stackFrames]
/// frames of the stack under it.
final class OneLinePrinter extends LogPrinter {
  OneLinePrinter({this.stackFrames = 8, this.colors = logColors});

  final int stackFrames;
  final bool colors;

  static const _tagColors = {
    Level.warning: ConsoleColor.orange,
    Level.error: ConsoleColor.red,
    Level.fatal: ConsoleColor.red,
  };

  static const _tags = {
    Level.trace: 'TRACE',
    Level.debug: 'DEBUG',
    Level.info: 'INFO',
    Level.warning: 'WARN',
    Level.error: 'ERROR',
    Level.fatal: 'FATAL',
  };

  @override
  List<String> log(LogEvent event) {
    final message = event.message;
    final tag = message is TaggedMessage
        ? message.tag
        : _tags[event.level] ?? event.level.name.toUpperCase();
    final text = message?.toString() ?? '';
    final error = event.error;

    final tagColor = message is TaggedMessage
        ? message.tagColor
        : _tagColors[event.level];
    final paddedTag = tag.padRight(5);

    final lines = text.split('\n');
    var head = lines.first;
    if (colors && message is TaggedMessage) {
      final highlight = message.highlight;
      final color = message.highlightColor;
      if (highlight != null && color != null) {
        head = head.replaceFirst('  $highlight', '  ${color.paint(highlight)}');
      }
    }
    final first = StringBuffer(
      '${_time(event.time)} '
      '${colors && tagColor != null ? tagColor.paint(paddedTag) : paddedTag} ',
    )..write(head);
    if (error != null && !text.contains(error.toString())) {
      first.write(text.isEmpty ? '$error' : ': $error');
    }

    return [first.toString(), ...lines.skip(1), ..._frames(event.stackTrace)];
  }

  Iterable<String> _frames(StackTrace? stackTrace) {
    if (stackTrace == null || stackFrames <= 0) return const [];
    return stackTrace
        .toString()
        .split('\n')
        .where((line) => line.trim().isNotEmpty)
        .take(stackFrames)
        .map((line) => '  $line');
  }

  static String _time(DateTime t) =>
      '${_two(t.hour)}:${_two(t.minute)}:${_two(t.second)}';

  static String _two(int n) => n.toString().padLeft(2, '0');
}

/// Writes each line with [debugPrint], on every platform, so it shows in the
/// `flutter run` terminal (where agents read), the IDE console and logcat.
///
/// Lines longer than [maxLineLength] are split, because iOS and logcat cut
/// very long lines.
final class PlatformConsoleOutput extends LogOutput {
  PlatformConsoleOutput({this.maxLineLength = 800});

  final int maxLineLength;

  @override
  void output(OutputEvent event) {
    for (final line in event.lines) {
      for (var i = 0; i < line.length || i == 0; i += maxLineLength) {
        final end = i + maxLineLength;
        debugPrint(line.substring(i, end < line.length ? end : line.length));
      }
    }
  }
}
