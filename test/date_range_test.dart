import 'package:flutter_test/flutter_test.dart';
import 'package:tazbeet/utils/date_range.dart';

void main() {
  group('dayRange', () {
    test('should return start and end of the same day', () {
      final date = DateTime(2025, 10, 12, 14, 30, 45);
      final range = dayRange(date);

      expect(range.start, equals(DateTime(2025, 10, 12, 0, 0, 0)));
      expect(range.end, equals(DateTime(2025, 10, 13, 0, 0, 0)));
    });

    test('should handle midnight correctly', () {
      final date = DateTime(2025, 10, 12, 0, 0, 0);
      final range = dayRange(date);

      expect(range.start, equals(DateTime(2025, 10, 12, 0, 0, 0)));
      expect(range.end, equals(DateTime(2025, 10, 13, 0, 0, 0)));
    });

    test('should handle end of day correctly', () {
      final date = DateTime(2025, 10, 12, 23, 59, 59);
      final range = dayRange(date);

      expect(range.start, equals(DateTime(2025, 10, 12, 0, 0, 0)));
      expect(range.end, equals(DateTime(2025, 10, 13, 0, 0, 0)));
    });

    test('should handle end of month correctly', () {
      final date = DateTime(2025, 10, 31, 12, 0, 0);
      final range = dayRange(date);

      expect(range.start, equals(DateTime(2025, 10, 31, 0, 0, 0)));
      expect(range.end, equals(DateTime(2025, 11, 1, 0, 0, 0)));
    });

    test('should handle end of year correctly', () {
      final date = DateTime(2025, 12, 31, 12, 0, 0);
      final range = dayRange(date);

      expect(range.start, equals(DateTime(2025, 12, 31, 0, 0, 0)));
      expect(range.end, equals(DateTime(2026, 1, 1, 0, 0, 0)));
    });

    test('should handle leap year correctly', () {
      final date = DateTime(2024, 2, 29, 12, 0, 0);
      final range = dayRange(date);

      expect(range.start, equals(DateTime(2024, 2, 29, 0, 0, 0)));
      expect(range.end, equals(DateTime(2024, 3, 1, 0, 0, 0)));
    });

    test('range should span exactly 24 hours', () {
      final date = DateTime(2025, 10, 12, 14, 30, 45);
      final range = dayRange(date);

      final duration = range.end.difference(range.start);
      expect(duration, equals(const Duration(days: 1)));
    });
  });
}
