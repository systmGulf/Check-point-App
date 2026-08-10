import 'package:easy_localization/easy_localization.dart';

String convertTo12HourFormat(String clockOutTime) {
  try {
    if (!clockOutTime.contains(':') || clockOutTime.length < 5) {
      return clockOutTime;
    }
    var timeParts = clockOutTime.substring(0, 5).split(':');
    int? hour = int.tryParse(timeParts[0]);
    int? minute = int.tryParse(timeParts[1]);

    if (hour == null || minute == null) {
      return clockOutTime;
    }

    // Increment the hour by 1
    hour = (hour + 1) % 24; // Ensure it wraps around to 0 after 23

    String period = hour >= 12 ? 'PM'.tr() : 'AM'.tr();
    int displayHour = hour % 12;
    displayHour = displayHour == 0 ? 12 : displayHour;

    String formattedTime = '$displayHour:${minute.toString().padLeft(2, '0')} $period';

    return formattedTime;
  } catch (_) {
    return clockOutTime;
  }
}
