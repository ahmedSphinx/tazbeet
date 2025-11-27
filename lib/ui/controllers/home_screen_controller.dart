import 'package:flutter/foundation.dart';
import 'package:tazbeet/models/task.dart';

/// Sort options for tasks
enum TaskSortOption { dueDate, priority, title, createdDate }

/// UI-only controller to manage Home screen selections/state
class HomeScreenController {
  final ValueNotifier<DateTime?> selectedDate = ValueNotifier<DateTime?>(null);
  final ValueNotifier<String?> selectedCategoryId = ValueNotifier<String?>(null);
  final ValueNotifier<bool> showCalendar = ValueNotifier<bool>(false);
  final ValueNotifier<TaskPriority?> filterPriority = ValueNotifier<TaskPriority?>(null);
  final ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  final ValueNotifier<TaskSortOption> sortOption = ValueNotifier<TaskSortOption>(TaskSortOption.dueDate);
  final ValueNotifier<bool> sortAscending = ValueNotifier<bool>(true);

  void clearDate() => selectedDate.value = null;
  void setDate(DateTime date) => selectedDate.value = date;
  void setCategory(String? categoryId) => selectedCategoryId.value = categoryId;
  void toggleCalendar() => showCalendar.value = !showCalendar.value;

  // Filter helpers for quick stats
  void setOverdueFilter() {
    // Set date to today and rely on task list logic to show overdue
    selectedDate.value = DateTime.now();
    // Optionally, could add a separate filter flag if needed
  }

  void setPriorityFilter(TaskPriority? priority) {
    filterPriority.value = priority;
  }

  void setUndatedFilter() {
    // Set date to null to show undated tasks
    selectedDate.value = null;
    // Optionally, could add a separate filter flag if needed
  }

  void setSearchQuery(String query) {
    searchQuery.value = query.trim();
  }

  void clearSearch() {
    searchQuery.value = '';
  }

  bool get isSearching => searchQuery.value.isNotEmpty;

  void setSortOption(TaskSortOption option) {
    sortOption.value = option;
  }

  void toggleSortDirection() {
    sortAscending.value = !sortAscending.value;
  }

  /// Sort tasks based on current sort option and direction
  List<Task> sortTasks(List<Task> tasks) {
    final sorted = List<Task>.from(tasks);

    switch (sortOption.value) {
      case TaskSortOption.dueDate:
        sorted.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case TaskSortOption.priority:
        sorted.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case TaskSortOption.title:
        sorted.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case TaskSortOption.createdDate:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
    }

    return sortAscending.value ? sorted : sorted.reversed.toList();
  }

  /// Clears all active filters
  void clearAllFilters() {
    selectedDate.value = null;
    selectedCategoryId.value = null;
    filterPriority.value = null;
    searchQuery.value = '';
  }

  /// Returns true if any filter is active
  bool get hasActiveFilters => selectedDate.value != null || selectedCategoryId.value != null || filterPriority.value != null || searchQuery.value.isNotEmpty;

  void dispose() {
    selectedDate.dispose();
    selectedCategoryId.dispose();
    showCalendar.dispose();
    filterPriority.dispose();
    searchQuery.dispose();
    sortOption.dispose();
    sortAscending.dispose();
  }
}
