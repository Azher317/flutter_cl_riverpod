import 'package:app/core/config/debug_tools.dart';
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// A message with its own console tag (`HTTP`, `ROUTE`) instead of the one
/// its level gives (`INFO`, `ERROR`). Only the logging wiring creates these.
@immutable
final class TaggedMessage {
  const TaggedMessage(this.tag, this.text);

  final String tag;
  final String text;

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
/// A multi-line message (HTTP bodies) keeps its extra lines under the first.
/// Errors add the error on the first line and the first [stackFrames]
/// frames of the stack under it.
final class OneLinePrinter extends LogPrinter {
  OneLinePrinter({this.stackFrames = 8});

  final int stackFrames;

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

    final lines = text.split('\n');
    final first = StringBuffer('${_time(event.time)} ${tag.padRight(5)} ')
      ..write(lines.first);
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
