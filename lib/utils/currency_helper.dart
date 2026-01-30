import 'package:intl/intl.dart';

class CurrencyHelper {
  static String format(double amount) {
    // Format as 15 000 FCFA
    final formatter = NumberFormat("#,###", "fr_FR");

    // We want spaces as separators or rely on custom pattern if needed.
    // However, the number format for 'fr' usually handles space grouping.

    return "${formatter.format(amount)} FCFA";
  }
}
