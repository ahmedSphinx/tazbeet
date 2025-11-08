({DateTime start, DateTime end}) dayRange(DateTime date) {
  final start = DateTime(date.year, date.month, date.day);
  final end = start.add(const Duration(days: 1));
  return (start: start, end: end);
}
