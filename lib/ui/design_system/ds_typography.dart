import 'package:flutter/material.dart';

/// Design System: Typography Scale
/// Consistent text styles with proper hierarchy
class DSTypography {
  DSTypography._();

  /// Caption - 10px, regular
  /// Use for: Timestamps, metadata, fine print
  static TextStyle caption(BuildContext context) {
    return Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 10, height: 1.4, letterSpacing: 0.4, fontWeight: FontWeight.w400);
  }

  /// Label - 12px, medium
  /// Use for: Form labels, chip text, badges
  static TextStyle label(BuildContext context) {
    return Theme.of(context).textTheme.labelMedium!.copyWith(fontSize: 12, height: 1.5, letterSpacing: 0.5, fontWeight: FontWeight.w500);
  }

  /// Body - 14px, regular
  /// Use for: Body text, descriptions, list items
  static TextStyle body(BuildContext context) {
    return Theme.of(context).textTheme.bodyMedium!.copyWith(fontSize: 14, height: 1.5, letterSpacing: 0.25, fontWeight: FontWeight.w400);
  }

  /// Body Large - 16px, regular
  /// Use for: Emphasized body text, important descriptions
  static TextStyle bodyLarge(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 16, height: 1.5, letterSpacing: 0.15, fontWeight: FontWeight.w400);
  }

  /// Subtitle - 18px, semibold
  /// Use for: Section headers, card titles
  static TextStyle subtitle(BuildContext context) {
    return Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 18, height: 1.4, letterSpacing: 0.15, fontWeight: FontWeight.w600);
  }

  /// Title - 24px, bold
  /// Use for: Screen titles, dialog headers
  static TextStyle title(BuildContext context) {
    return Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 24, height: 1.3, letterSpacing: 0, fontWeight: FontWeight.w700);
  }

  /// Headline - 32px, bold
  /// Use for: Large numbers, stat values, emphasis
  static TextStyle headline(BuildContext context) {
    return Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: 32, height: 1.25, letterSpacing: 0, fontWeight: FontWeight.w700);
  }

  /// Display - 40px, bold
  /// Use for: Hero text, major headings
  static TextStyle display(BuildContext context) {
    return Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 40, height: 1.2, letterSpacing: -0.5, fontWeight: FontWeight.w700);
  }
}
