import 'package:easy_localization/easy_localization.dart';

String formatHour(String timeOut) {
  if (timeOut.isEmpty || timeOut == 'null') {
    return ' ${"No Time".tr()}';
  }
  
  final trimmed = timeOut.trim();
  final upper = trimmed.toUpperCase();
  if (upper.contains('AM') || upper.contains('PM')) {
    return trimmed;
  }

  try {
    final parts = trimmed.split(':');
    if (parts.isEmpty) return ' ${"No Time".tr()}';
    
    int hour = int.parse(parts[0].trim());
    int minute = 0;
    if (parts.length > 1) {
      final minPart = parts[1].trim().split(' ').first;
      minute = int.parse(minPart);
    }

    if (hour == 0 && minute == 0 && (trimmed == '00:00' || trimmed == '00:00:00')) {
      return ' ${"No Time".tr()}';
    }

    String period = hour >= 12 ? "PM".tr() : "AM".tr();
    int formattedHour = hour % 12;
    if (formattedHour == 0) formattedHour = 12;

    String minStr = minute < 10 ? '0$minute' : '$minute';
    return '$formattedHour:$minStr $period';
  } catch (e) {
    return trimmed;
  }
}
