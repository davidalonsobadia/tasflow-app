class FormatUtils {
  static String formatAmount(double amount) {
    if (amount.truncate() == amount) {
      return amount.toStringAsFixed(0);
    } else {
      return amount.toStringAsFixed(2);
    }
  }
}
