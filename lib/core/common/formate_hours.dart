String formatHour(String timeOut) {
  int hour = int.parse(timeOut.split(':')[0]);

  if (hour == 0) {
    return '12 AM';
  } else if (hour == 12) {
    return '12 PM';
  } else if (hour > 12) {
    return '${hour - 12} PM';
  } else {
    return '$hour AM';
  }
}
