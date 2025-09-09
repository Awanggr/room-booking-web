import 'package:intl/intl.dart';

class DateUtilsHelper {
  // Ambil Senin minggu ini
  static DateTime startOfWeek(DateTime date) {
    int difference = date.weekday - DateTime.monday;
    return date.subtract(Duration(days: difference));
  }

  // Ambil Minggu minggu ini
  static DateTime endOfWeek(DateTime date) {
    DateTime monday = startOfWeek(date);
    return monday.add(const Duration(days: 6));
  }

  // Format tanggal (misal "Senin, 09 Sep")
  static String formatDay(DateTime date) {
    return DateFormat('EEEE, dd MMM', 'id_ID').format(date);
  }
}
