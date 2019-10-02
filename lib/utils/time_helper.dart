class TimeHelper {
  static String get term {
    final today = DateTime.now();
    if (today.month < 3) {
      // Fall Semester of Last Year
      return "${today.year - 1}f";
    } else if (today.month < 8) {
      // Spring Semester of This Year
      return "${today.year}s";
    } else {
      return "${today.year}f";
    }
  }

  static DateTime getDeadline(int month, int day, int hour, int min) {
    final today = new DateTime.now();
    var year = today.year;

    if (today.month < 3 && today.month > 8) {
      // In Fall Semester, Assignments in Next Year
      year = today.year + 1;
    } else if (today.month < 3 && month > 8) {
      // In Fall Semester, Assignments in Previous Year
      year = today.year - 1;
    }

    return DateTime.utc(year, month, day, hour - 9, min);
  }
}
