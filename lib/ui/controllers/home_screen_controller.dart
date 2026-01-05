import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tazbeet/models/task.dart';

/// Sort options for tasks
enum TaskSortOption { dueDate, priority, title, createdDate, none }

/// Calendar view modes
enum CalendarViewMode { day, week, month }

/// UI-only controller to manage Home screen selections/state
class HomeScreenController {
  final ValueNotifier<DateTime?> selectedDate = ValueNotifier<DateTime?>(null);
  final ValueNotifier<String?> selectedCategoryId = ValueNotifier<String?>(null);
  final ValueNotifier<bool> showCalendar = ValueNotifier<bool>(false);
  final ValueNotifier<CalendarViewMode> calendarViewMode = ValueNotifier<CalendarViewMode>(CalendarViewMode.week);
  final ValueNotifier<DateTime> focusedDate = ValueNotifier<DateTime>(DateTime.now());
  final ValueNotifier<TaskPriority?> filterPriority = ValueNotifier<TaskPriority?>(null);
  final ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  final ValueNotifier<TaskSortOption> sortOption = ValueNotifier<TaskSortOption>(TaskSortOption.dueDate);
  final ValueNotifier<bool> sortAscending = ValueNotifier<bool>(true);
  final ValueNotifier<bool> showOverdueOnly = ValueNotifier<bool>(false);
  final ValueNotifier<bool> showUndatedOnly = ValueNotifier<bool>(false);
  final ValueNotifier<bool> showCompletedSection = ValueNotifier<bool>(false);

  Timer? _searchTimer;

  void clearDate() => selectedDate.value = null;
  void setDate(DateTime date) => selectedDate.value = date;
  void setCategory(String? categoryId) => selectedCategoryId.value = categoryId;
  void toggleCalendar() => showCalendar.value = false;

  // Calendar view mode helpers
  void setCalendarViewMode(CalendarViewMode mode) {
    calendarViewMode.value = mode;
    _saveCalendarViewMode(mode);
  }

  void setFocusedDate(DateTime date) => focusedDate.value = date;
  void toggleCompletedSection() => showCompletedSection.value = !showCompletedSection.value;

  // Persist calendar view mode
  Future<void> _saveCalendarViewMode(CalendarViewMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('calendarViewMode', mode.index);
  }

  // Load calendar view mode from storage
  Future<void> loadCalendarViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    final savedMode = prefs.getInt('calendarViewMode');
    if (savedMode != null && savedMode < CalendarViewMode.values.length) {
      calendarViewMode.value = CalendarViewMode.values[savedMode];
    }
  }

  // Filter helpers for quick stats
  void setOverdueFilter() {
    // Set overdue-only flag without clearing other filters
    showOverdueOnly.value = true;
    showUndatedOnly.value = false;
  }

  void setPriorityFilter(TaskPriority? priority) {
    filterPriority.value = priority;
  }

  void setUndatedFilter() {
    // Set undated-only flag without clearing other filters
    showOverdueOnly.value = false;
    showUndatedOnly.value = true;
  }

  void clearSpecialFilters() {
    showOverdueOnly.value = false;
    showUndatedOnly.value = false;
    // Don't clear category filter unless explicitly requested
  }

  void setSearchQuery(String query) {
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 300), () {
      searchQuery.value = query.trim();
    });
  }

  void setSearchImmediate(String query) {
    _searchTimer?.cancel();
    searchQuery.value = query.trim();
  }

  void clearSearch() {
    _searchTimer?.cancel();
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
      case TaskSortOption.none:
        // No sorting, return as-is
        break;
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
    showOverdueOnly.value = false;
    showUndatedOnly.value = false;
  }

  /// Returns true if any filter is active
  bool get hasActiveFilters => selectedDate.value != null || selectedCategoryId.value != null || filterPriority.value != null || searchQuery.value.isNotEmpty || showOverdueOnly.value || showUndatedOnly.value;

  void dispose() {
    _searchTimer?.cancel();
    selectedDate.dispose();
    selectedCategoryId.dispose();
    showCalendar.dispose();
    calendarViewMode.dispose();
    focusedDate.dispose();
    filterPriority.dispose();
    searchQuery.dispose();
    sortOption.dispose();
    sortAscending.dispose();
    showOverdueOnly.dispose();
    showUndatedOnly.dispose();
    showCompletedSection.dispose();
  }
}
