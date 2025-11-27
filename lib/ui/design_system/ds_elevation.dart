import 'package:flutter/material.dart';

/// Design System: Elevation Tokens
/// Material Design 3 elevation system for consistent depth
class DSElevation {
  DSElevation._();

  /// Level 0 - Surface level
  /// Use for: Base surfaces, backgrounds
  static const double level0 = 0;

  /// Level 1 - Raised surface
  /// Use for: Slightly raised elements
  static const double level1 = 1;

  /// Level 2 - Cards, chips
  /// Use for: Standard cards, chips, small elevated elements
  static const double level2 = 2;

  /// Level 3 - Raised cards, dropdowns
  /// Use for: Hover states, dropdowns, tooltips
  static const double level3 = 4;

  /// Level 4 - FAB, app bar
  /// Use for: Floating action buttons, persistent elements
  static const double level4 = 6;

  /// Level 5 - Navigation drawer, modal bottom sheet
  /// Use for: Overlays, modals, drawers
  static const double level5 = 8;

  /// Level 6 - Dialogs
  /// Use for: Dialogs, full-screen overlays
  static const double level6 = 16;

  /// Get shadow color based on theme brightness
  static Color getShadowColor(BuildContext context, double elevation) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseOpacity = isDark ? 0.3 : 0.15;
    final opacity = (elevation / 16) * baseOpacity;
    return Colors.black.withValues(alpha: opacity.clamp(0.0, 1.0));
  }

  /// Create box shadow for custom containers
  static List<BoxShadow> getBoxShadow(BuildContext context, double elevation) {
    if (elevation == 0) return [];

    return [BoxShadow(color: getShadowColor(context, elevation), blurRadius: elevation * 2, offset: Offset(0, elevation / 2))];
  }
}
