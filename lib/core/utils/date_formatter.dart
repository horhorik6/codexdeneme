import 'package:intl/intl.dart';

class DateFormatter {
  static final _matchDateFormatter = DateFormat('dd MMMM yyyy, EEEE', 'tr');
  static final _matchTimeFormatter = DateFormat('HH:mm', 'tr');
  static final _newsDateFormatter = DateFormat('dd MMMM yyyy', 'tr');

  static String formatMatchDate(DateTime date) => _matchDateFormatter.format(date);

  static String formatMatchTime(DateTime date) => _matchTimeFormatter.format(date);

  static String formatNewsDate(DateTime date) => _newsDateFormatter.format(date);

  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Şimdi';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} dk önce';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} saat önce';
    } else {
      return '${difference.inDays} gün önce';
    }
  }
}
