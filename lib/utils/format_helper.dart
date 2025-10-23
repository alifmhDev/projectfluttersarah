import 'package:intl/intl.dart';

class FormatHelper {
  static String formatDate(String date) {
    final DateTime parsed = DateTime.parse(date);
    return DateFormat('d MMM yyyy').format(parsed);
  }

  static String formatCurrency(num value) {
    final format = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp');
    return format.format(value);
  }
}
