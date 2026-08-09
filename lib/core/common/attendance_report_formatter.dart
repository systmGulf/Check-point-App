class AttendanceReportFormatter {
  /// Formats raw Employee ID (shortens long UUIDs to clean EMP-XXXX code)
  static String formatEmployeeId(String? id) {
    if (id == null || id.trim().isEmpty) return '-';
    final trimmed = id.trim();
    if (trimmed.length > 8 && trimmed.contains('-')) {
      return 'EMP-${trimmed.substring(0, 4).toUpperCase()}';
    }
    return trimmed;
  }

  /// Formats Customer ID (replaces 00000000-0000-0000-0000-000000000000 with '-')
  static String formatCustomerId(String? id) {
    if (id == null || id.trim().isEmpty) return '-';
    final trimmed = id.trim();
    if (trimmed == '00000000-0000-0000-0000-000000000000' || trimmed == '0') {
      return '-';
    }
    if (trimmed.length > 8 && trimmed.contains('-')) {
      return 'CUST-${trimmed.substring(0, 4).toUpperCase()}';
    }
    return trimmed;
  }

  /// Formats time string (e.g. "16:12" or "16:12:00" -> "04:12 PM", "00:00" -> "Not Checked Out")
  static String formatTime(String? timeStr, {bool isOutTime = false}) {
    if (timeStr == null || timeStr.trim().isEmpty || timeStr == 'null') {
      return isOutTime ? 'Not Checked Out' : '--:--';
    }
    final trimmed = timeStr.trim();
    if (trimmed == '00:00' || trimmed == '00:00:00') {
      return isOutTime ? 'Not Checked Out' : '--:--';
    }
    if (trimmed.toUpperCase().contains('AM') ||
        trimmed.toUpperCase().contains('PM')) {
      return trimmed;
    }

    try {
      final parts = trimmed.split(':');
      int hour = int.parse(parts[0].trim());
      int minute =
          parts.length > 1 ? int.parse(parts[1].trim().split(' ').first) : 0;

      String period = hour >= 12 ? 'PM' : 'AM';
      int formattedHour = hour % 12;
      if (formattedHour == 0) formattedHour = 12;

      String minStr = minute < 10 ? '0$minute' : '$minute';
      String hrStr = formattedHour < 10 ? '0$formattedHour' : '$formattedHour';

      return '$hrStr:$minStr $period';
    } catch (_) {
      return trimmed;
    }
  }

  /// Formats total hours (e.g. 6.830332378916666 -> "6 hrs 50 mins")
  static String formatTotalHours(dynamic totalHours) {
    if (totalHours == null) return '0 hrs';
    double? hoursNum;
    if (totalHours is num) {
      hoursNum = totalHours.toDouble();
    } else if (totalHours is String) {
      hoursNum = double.tryParse(totalHours.trim());
    }

    if (hoursNum == null || hoursNum <= 0) {
      return '0 hrs';
    }

    int hours = hoursNum.floor();
    int minutes = ((hoursNum - hours) * 60).round();
    if (minutes == 60) {
      hours += 1;
      minutes = 0;
    }

    if (hours == 0) {
      return '$minutes mins';
    } else if (minutes == 0) {
      return '$hours hrs';
    } else {
      return '$hours hrs $minutes mins';
    }
  }
}
