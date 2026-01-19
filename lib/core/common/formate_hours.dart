import 'package:easy_localization/easy_localization.dart';

String formatHour(String timeOut) {
  int hour = int.parse(timeOut.split(':')[0]);

  if (hour == 0) {
    return ' ${"No Time".tr()}';
  } else if (hour == 12) {
    return '12 ${"PM".tr()}';
  } else if (hour > 12) {
    return '${hour - 12} ${"PM".tr()}';
  } else {
    return '$hour ${"AM".tr()}';
  }
}
