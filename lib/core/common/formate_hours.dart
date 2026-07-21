import 'package:easy_localization/easy_localization.dart';

String formatHour(String timeOut) {
  if (timeOut.isEmpty || timeOut == 'null') {
    return ' ${"No Time".tr()}';
  }
  try {
    final parts = timeOut.split(':');
    int hour = int.parse(parts[0]);
    int minute = parts.length > 1 ? int.parse(parts[1]) : 0;

    if (hour == 0 && minute == 0 && (timeOut == '00:00' || timeOut == '00:00:00')) {
      return ' ${"No Time".tr()}';
    }

    String period = hour >= 12 ? "PM".tr() : "AM".tr();
    int formattedHour = hour % 12;
    if (formattedHour == 0) formattedHour = 12;

    if (minute == 0) {
      return '$formattedHour $period';
    } else {
      String minStr = minute < 10 ? '0$minute' : '$minute';
      return '$formattedHour:$minStr $period';
    }
  } catch (e) {
    return ' ${"No Time".tr()}';
  }
}
