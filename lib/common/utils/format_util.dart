abstract class FormatUtil {
  static String formatNumberAsCurrency(double number, {String symbol = '\$'}) {
    String formatted = number.toStringAsFixed(0);
    // add commas for thousands
    RegExp reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    formatted = formatted.replaceAllMapped(reg, (Match match) => ',');
    formatted = '$symbol$formatted';
    return formatted;
  }
}
