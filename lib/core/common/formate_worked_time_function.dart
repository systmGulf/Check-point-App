import 'package:easy_localization/easy_localization.dart';

DateTime? _tryParseTime(String timeStr) {
  final formats = [
    'HH:mm:ss',
    'HH:mm',
    'h:mm a',
    'hh:mm a',
    'h:mm:ss a',
    'hh:mm:ss a',
  ];
  for (final format in formats) {
    try {
      return DateFormat(format).parse(timeStr.trim());
    } catch (_) {}
  }

  try {
    return DateTime.parse(timeStr);
  } catch (_) {}

  try {
    return DateTime.parse("1970-01-01 $timeStr");
  } catch (_) {}

  return null;
}

String formatWorkedTime({
  required String clockInTime,
  required String clockOutTime,
}) {
  try {
    final inTime = _tryParseTime(clockInTime);
    final outTime = _tryParseTime(clockOutTime);

    if (inTime == null || outTime == null) {
      return "0 ${"minute".tr()}";
    }

    final difference = outTime.difference(inTime);

    final totalMinutes = difference.inSeconds / 60;

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
  } catch (_) {
    return "0 ${"minute".tr()}";
  }
}
