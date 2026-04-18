import 'package:easy_localization/easy_localization.dart';

String formatWorkedTime({
  required String clockInTime,
  required String clockOutTime,
}) {
  final inParts = clockInTime.split(':');
  final outParts = clockOutTime.split(':');

  final inMinutes = (int.parse(inParts[0]) * 60) +
      int.parse(inParts[1]) +
      (inParts.length > 2 ? int.parse(inParts[2]) / 60 : 0);

  final outMinutes = (int.parse(outParts[0]) * 60) +
      int.parse(outParts[1]) +
      (outParts.length > 2 ? int.parse(outParts[2]) / 60 : 0);

  final totalMinutes = outMinutes - inMinutes;

  if (totalMinutes <= 0) {
    return "0 ${"minute".tr()}";
  }

  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;

  if (hours == 0) {
    return "$minutes ${"minute".tr()}";
  } else if (minutes == 0) {
    return "$hours ${"hour".tr()}";
  } else {
    return "$hours ${"hour".tr()} و $minutes ${"minute".tr()}";
  }
}
