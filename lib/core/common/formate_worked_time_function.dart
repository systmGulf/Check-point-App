import 'package:easy_localization/easy_localization.dart';

String formatWorkedTime({
  required String clockInTime,
  required String clockOutTime,
}) {
  final inTime = DateTime.parse("1970-01-01 $clockInTime");
  final outTime = DateTime.parse("1970-01-01 $clockOutTime");

  final difference = outTime.difference(inTime);

  final totalMinutes = difference.inSeconds / 60;

  // لو أقل من دقيقة نحسبها دقيقة
  if (totalMinutes < 1) {
    return "1 ${"minute".tr()}";
  }

  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes.round() % 60;

  if (hours == 0) {
    return "$minutes ${"minute".tr()}";
  } else if (minutes == 0) {
    return "$hours ${"hour".tr()}";
  } else {
    return "$hours ${hours == 1 ? "hour".tr() : "hours".tr()} و $minutes ${minutes == 1 ? "minute".tr() : "minutes".tr()}";
  }
}
