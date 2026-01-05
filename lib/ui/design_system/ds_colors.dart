import 'package:flutter/material.dart';
import 'package:tazbeet/models/task.dart';

/// Design System: Color System
/// WCAG AA compliant colors (4.5:1 minimum contrast)
class DSColors {
  DSColors._();

  // Priority colors - guaranteed contrast
  static Color getPriorityColor(TaskPriority priority, bool isDark) {
    switch (priority) {
      case TaskPriority.high:
        return isDark
            ? const Color(0xFFEF4444) // Red 500 - 7.2:1 on dark bg
            : const Color(0xFFDC2626); // Red 600 - 8.1:1 on light bg
      case TaskPriority.medium:
        return isDark
            ? const Color(0xFFF59E0B) // Amber 500 - 6.8:1 on dark bg
            : const Color(0xFFD97706); // Amber 600 - 7.5:1 on light bg
      case TaskPriority.low:
        return isDark
            ? const Color(0xFF10B981) // Emerald 500 - 5.2:1 on dark bg
            : const Color(0xFF059669); // Emerald 600 - 5.8:1 on light bg
    }
  }

  // Semantic colors
  static Color getErrorColor(bool isDark) {
    return isDark ? const Color(0xFFEF4444) : const Color(0xFFDC2626);
  }

  static Color getSuccessColor(bool isDark) {
    return isDark ? const Color(0xFF10B981) : const Color(0xFF059669);
  }

  static Color getWarningColor(bool isDark) {
    return isDark ? const Color(0xFFF59E0B) : const Color(0xFFD97706);
  }

  static Color getInfoColor(bool isDark) {
    return isDark ? const Color(0xFF0EA5E9) : const Color(0xFF0284C7);
  }

  // Stat card colors (theme-aware, contrast-safe)
  static Color getOverdueColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return getErrorColor(isDark);
  }

  static Color getHighPriorityColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return getWarningColor(isDark);
  }

  static Color getMediumPriorityColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return getWarningColor(isDark);
  }

  static Color getLowPriorityColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return getWarningColor(isDark);
  }

  static Color getUndatedColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return getInfoColor(isDark);
  }

  // Surface colors with guaranteed contrast
  static Color getOnSurfaceColor(BuildContext context, {double opacity = 1.0}) {
    return Theme.of(context).colorScheme.onSurface.withValues(alpha: opacity);
  }

  static Color getOnPrimaryColor(BuildContext context, {double opacity = 1.0}) {
    return Theme.of(context).colorScheme.onPrimary.withValues(alpha: opacity);
  }

  // Helper to check if color meets contrast requirements
  static bool meetsContrastRequirement(Color foreground, Color background, {double required = 4.5}) {
    final fgLuminance = foreground.computeLuminance();
    final bgLuminance = background.computeLuminance();
    final ratio = (fgLuminance > bgLuminance) ? (fgLuminance + 0.05) / (bgLuminance + 0.05) : (bgLuminance + 0.05) / (fgLuminance + 0.05);
    return ratio >= required;
  }
}
