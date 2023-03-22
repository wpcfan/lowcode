extension DateTimeExtension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);

  String get formatted =>
      '${_formatNumber(year, 4)}-${_formatNumber(month, 2)}-${_formatNumber(day, 2)}';

  String format(String pattern) {
    String result = pattern;
    result = result.replaceAll('yyyy', _formatNumber(year, 4));
    result = result.replaceAll('MM', _formatNumber(month, 2));
    result = result.replaceAll('dd', _formatNumber(day, 2));
    result = result.replaceAll('HH', _formatNumber(hour, 2));
    result = result.replaceAll('mm', _formatNumber(minute, 2));
    result = result.replaceAll('ss', _formatNumber(second, 2));
    return result;
  }

  String _formatNumber(int number, int width) {
    return number.toString().padLeft(width, '0');
  }
}
