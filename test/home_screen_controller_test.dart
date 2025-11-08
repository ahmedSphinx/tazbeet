import 'package:flutter_test/flutter_test.dart';
import 'package:tazbeet/ui/controllers/home_screen_controller.dart';

void main() {
  group('HomeScreenController', () {
    late HomeScreenController controller;

    setUp(() {
      controller = HomeScreenController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('should initialize with null date and category, showCalendar true', () {
      expect(controller.selectedDate.value, isNull);
      expect(controller.selectedCategoryId.value, isNull);
      expect(controller.showCalendar.value, isTrue);
    });

    test('setDate should update selectedDate', () {
      final date = DateTime(2025, 10, 12);
      controller.setDate(date);
      expect(controller.selectedDate.value, equals(date));
    });

    test('clearDate should set selectedDate to null', () {
      controller.setDate(DateTime(2025, 10, 12));
      controller.clearDate();
      expect(controller.selectedDate.value, isNull);
    });

    test('setCategory should update selectedCategoryId', () {
      controller.setCategory('cat-123');
      expect(controller.selectedCategoryId.value, equals('cat-123'));

      controller.setCategory(null);
      expect(controller.selectedCategoryId.value, isNull);
    });

    test('toggleCalendar should flip showCalendar value', () {
      expect(controller.showCalendar.value, isTrue);
      controller.toggleCalendar();
      expect(controller.showCalendar.value, isFalse);
      controller.toggleCalendar();
      expect(controller.showCalendar.value, isTrue);
    });

    test('ValueNotifiers should notify listeners on change', () {
      int dateChanges = 0;
      int categoryChanges = 0;
      int calendarChanges = 0;

      controller.selectedDate.addListener(() => dateChanges++);
      controller.selectedCategoryId.addListener(() => categoryChanges++);
      controller.showCalendar.addListener(() => calendarChanges++);

      controller.setDate(DateTime(2025, 10, 12));
      controller.setCategory('cat-456');
      controller.toggleCalendar();

      expect(dateChanges, equals(1));
      expect(categoryChanges, equals(1));
      expect(calendarChanges, equals(1));
    });
  });
}
