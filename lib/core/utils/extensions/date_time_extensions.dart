import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

extension DateTimeX on DateTime {
  String formatDate([String? locale]) =>
      DateFormat('yyyy/MM/dd', locale).format(this);

  String formatTime([String? locale]) =>
      DateFormat('hh:mm a', locale).format(this);

  String formatDOW([String? locale]) => DateFormat('EEEE', locale).format(this);

  String format([String? locale]) =>
      DateFormat('yyyy/MM/dd hh:mm', locale).format(this);

  String formatTimeago([String? locale]) =>
      timeago.format(this, locale: locale).toUpperCase();
}

extension TimeOfDayX on TimeOfDay {
  String format24Hour() {
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
