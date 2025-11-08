import 'package:flutter/foundation.dart';

/// UI-only controller to manage Home screen selections/state
class HomeScreenController {
  final ValueNotifier<DateTime?> selectedDate = ValueNotifier<DateTime?>(null);
  final ValueNotifier<String?> selectedCategoryId = ValueNotifier<String?>(null);
  final ValueNotifier<bool> showCalendar = ValueNotifier<bool>(true);

  void clearDate() => selectedDate.value = null;
  void setDate(DateTime date) => selectedDate.value = date;
  void setCategory(String? categoryId) => selectedCategoryId.value = categoryId;
  void toggleCalendar() => showCalendar.value = !showCalendar.value;

  void dispose() {
    selectedDate.dispose();
    selectedCategoryId.dispose();
    showCalendar.dispose();
  }
}
