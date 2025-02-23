import 'package:intl/intl.dart';

class DateTimeHelper {
  static DateTime stringToDateTime(String dateTimeString) {
    try {
      return DateTime.parse(dateTimeString);
    } catch (e) {
      return DateTime.now();
    }
  }

  static String formatDate(DateTime dateTime, {String locale = 'id_ID'}) {
    try {
      return DateFormat('EEEE, d MMMM y', locale).format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  static String formatTime(DateTime dateTime) {
    try {
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return '-';
    }
  }

  static String formatTimeFromString(String timeString) {
    try {
      final dateTime = DateTime.parse('2024-01-01 $timeString');
      return formatTime(dateTime);
    } catch (e) {
      return timeString;
    }
  }

  static bool isWithinTimeRange(DateTime dateTime, String startTime, String endTime) {
    try {
      final now = DateTime.now();
      final start = stringToDateTime(startTime);
      final end = stringToDateTime(endTime);

      return dateTime.isAfter(start) && dateTime.isBefore(end);
    } catch (e) {
      return false;
    }
  }
}
