import 'package:intl/intl.dart';

class DateFormatter {
  static final _dayFormatter = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
  static final _shortFormatter = DateFormat('d MMM yyyy', 'id_ID');
  static final _timeFormatter = DateFormat('HH:mm', 'id_ID');
  static final _datetimeFormatter = DateFormat('d MMM yyyy, HH:mm', 'id_ID');

  static String formatFull(DateTime dt) => _dayFormatter.format(dt);
  static String formatShort(DateTime dt) => _shortFormatter.format(dt);
  static String formatTime(DateTime dt) => _timeFormatter.format(dt);
  static String formatDateTime(DateTime dt) => _datetimeFormatter.format(dt);

  static String timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 1) return 'Baru saja';
    if (diff.inMinutes < 60) return '${diff.inMinutes} menit lalu';
    if (diff.inHours < 24) return '${diff.inHours} jam lalu';
    if (diff.inDays < 7) return '${diff.inDays} hari lalu';
    return formatShort(dt);
  }
}
