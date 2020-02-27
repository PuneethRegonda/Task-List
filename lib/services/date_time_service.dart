import 'package:intl/intl.dart';

class DateTimeServiceProvider {
  static final DateFormat internalFormat = DateFormat("yyyy-MM-dd");

  static String dateTimetoStr(DateTime dateTime) =>
      internalFormat.format(dateTime);

  static DateTime strToDateTime(String string) => DateTime.parse(string);

  static bool isDelayed(DateTime dateTime) {
    return DateTime.now().difference(dateTime).isNegative;
  }
}
