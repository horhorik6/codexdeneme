import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static final DateFormat _dayFormat = DateFormat('dd MMMM yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');

  static String formatDate(DateTime dateTime) => _dayFormat.format(dateTime);
  static String formatTime(DateTime dateTime) => _timeFormat.format(dateTime);
  static String formatDateTime(DateTime dateTime) =>
      '${formatDate(dateTime)} - ${formatTime(dateTime)}';
}
