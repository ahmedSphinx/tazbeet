import 'package:flutter/material.dart';

/// Helper class for accessibility improvements
class AccessibilityHelper {
  // Semantic labels for common UI elements
  static const Map<String, String> semanticLabels = {
    'add_task': 'Add new task',
    'search': 'Search tasks',
    'filter': 'Filter tasks',
    'menu': 'Menu',
    'settings': 'Settings',
    'home': 'Home screen',
    'progress': 'Progress tracking',
    'pomodoro': 'Pomodoro timer',
    'categories': 'Task categories',
    'mood': 'Mood tracking',
    'task_completed': 'Task completed',
    'task_pending': 'Task pending',
    'task_overdue': 'Task overdue',
    'delete_task': 'Delete task',
    'edit_task': 'Edit task',
    'clear_filters': 'Clear all filters',
    'calendar_view': 'Calendar view',
    'today': 'Today',
    'upcoming': 'Upcoming',
    'completed': 'Completed',
  };

  // Semantic hints for interactive elements
  static const Map<String, String> semanticHints = {
    'add_task': 'Double tap to create a new task',
    'search': 'Double tap to search tasks',
    'filter': 'Double tap to filter tasks',
    'task_item': 'Double tap to view task details',
    'task_checkbox': 'Double tap to mark task as complete',
    'delete_task': 'Double tap to delete this task',
    'edit_task': 'Double tap to edit this task',
    'clear_filters': 'Double tap to clear all active filters',
    'category_chip': 'Double tap to filter by this category',
    'date_filter': 'Double tap to filter by this date',
  };

  // Add semantic properties to a widget
  static Widget addSemantics({
    required Widget child,
    required String semanticKey,
    String? customLabel,
    String? customHint,
    bool? isButton,
    bool? isSlider,
    bool? isSwitch,
    bool? isTextField,
    bool? isHeader,
    bool? isImage,
    bool? isSelected,
    bool? isObscured,
    bool? isFocusable,
  }) {
    return Semantics(
      label: customLabel ?? semanticLabels[semanticKey] ?? semanticKey,
      hint: customHint ?? semanticHints[semanticKey],
      button: isButton,
      slider: isSlider,
      textField: isTextField,
      header: isHeader,
      image: isImage,
      selected: isSelected,
      obscured: isObscured,
      focusable: isFocusable,
      child: child,
    );
  }

  // Add semantic properties to list items
  static Widget addListItemSemantics({required Widget child, required String semanticKey, required int index, required int totalItems, String? customLabel, String? customHint}) {
    return Semantics(label: customLabel ?? '${semanticLabels[semanticKey] ?? semanticKey}, item ${index + 1} of $totalItems', hint: customHint ?? semanticHints[semanticKey], child: child);
  }

  // Add semantic properties to form fields
  static Widget addFormFieldSemantics({required Widget child, required String semanticKey, required String? errorText, required bool isRequired, String? customLabel, String? customHint}) {
    String hint = customHint ?? semanticHints[semanticKey] ?? '';
    if (isRequired) {
      hint += ', required field';
    }
    if (errorText != null) {
      hint += ', error: $errorText';
    }

    return Semantics(label: customLabel ?? semanticLabels[semanticKey] ?? semanticKey, hint: hint, textField: true, child: child);
  }

  // Add semantic properties to buttons with state
  static Widget addButtonSemantics({required Widget child, required String semanticKey, required bool isEnabled, required bool isLoading, String? customLabel, String? customHint}) {
    String label = customLabel ?? semanticLabels[semanticKey] ?? semanticKey;
    String hint = customHint ?? semanticHints[semanticKey] ?? '';

    if (isLoading) {
      label += ', loading';
    } else if (!isEnabled) {
      label += ', disabled';
      hint += ', button is currently disabled';
    }

    return Semantics(label: label, hint: hint, button: true, child: child);
  }

  // Check if accessibility features are enabled
  static bool isAccessibilityEnabled(BuildContext context) {
    return MediaQuery.of(context).accessibleNavigation;
  }

  // Get appropriate tap target size based on accessibility settings
  static double getTapTargetSize(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    if (mediaQuery.accessibleNavigation) {
      return 48.0; // Larger tap targets for accessibility
    }
    return 44.0; // Default tap target size
  }

  // Get appropriate font scaling
  static double getFontScale(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    if (mediaQuery.accessibleNavigation) {
      return 1.2; // Larger text for accessibility
    }
    return 1.0;
  }

  // Add focus management for keyboard navigation
  static Widget addFocusManagement({required Widget child, required FocusNode focusNode, required bool autoFocus, VoidCallback? onFocusChanged}) {
    return Focus(
      focusNode: focusNode,
      autofocus: autoFocus,
      onFocusChange: (hasFocus) {
        onFocusChanged?.call();
      },
      child: child,
    );
  }

  // Add proper heading structure
  static Widget addHeadingSemantics({required Widget child, required int level, String? customLabel}) {
    return Semantics(label: customLabel, header: true, child: child);
  }

  // Add landmark semantics for screen regions
  static Widget addLandmarkSemantics({required Widget child, required String landmarkType, String? customLabel}) {
    return Semantics(label: customLabel ?? landmarkType, child: child);
  }

  // Add live region for dynamic content
  static Widget addLiveRegionSemantics({required Widget child, required bool isLive, String? customLabel}) {
    return Semantics(label: customLabel, liveRegion: isLive, child: child);
  }
}
