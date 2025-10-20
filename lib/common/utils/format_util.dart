abstract class FormatUtil {
  static String formatNumberAsCurrency(double number, {String symbol = '\$'}) {
    String formatted = number.toStringAsFixed(0);
    // add commas for thousands
    RegExp reg = RegExp(r'\B(?=(\d{3})+(?!\d))');
    formatted = formatted.replaceAllMapped(reg, (Match match) => ',');
    formatted = '$symbol$formatted';
    return formatted;
  }

  static String convertTimestampToDuration(int timestamp) {
    Duration duration = Duration(seconds: timestamp);
    // nếu < 60 mins thì chỉ hiển thị mm:ss
    if (duration.inHours == 0) {
      return duration.toString().split('.').first.substring(2);
    }
    return duration.toString().split('.').first;
  }
}
