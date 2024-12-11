import 'package:easy_localization/easy_localization.dart';

String convertTo12HourFormat(String clockOutTime) {
  var timeParts = clockOutTime.substring(0, 5).split(':');
  int hour = int.parse(timeParts[0]);
  int minute = int.parse(timeParts[1]);

  String period = hour >= 12 ? 'PM'.tr() : 'AM'.tr();
  hour = hour % 12;
  hour = hour == 0 ? 12 : hour;

  String formattedTime = '$hour.${minute.toString().padLeft(2, '0')} $period';

  return formattedTime;
}
