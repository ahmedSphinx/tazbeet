import 'package:flutter/material.dart';

/// Design System: Border Radius Constants
/// Consistent corner radius for all components
class DSBorderRadius {
  DSBorderRadius._();

  /// Extra small - 4px
  /// Use for: Small chips, tight corners
  static const double xs = 4.0;

  /// Small - 8px
  /// Use for: Buttons, small cards
  static const double sm = 8.0;

  /// Medium - 12px
  /// Use for: Input fields, standard buttons
  static const double md = 12.0;

  /// Large - 16px
  /// Use for: Cards, large buttons, containers
  static const double lg = 16.0;

  /// Extra large - 20px
  /// Use for: Hero cards, prominent elements
  static const double xl = 20.0;

  /// 2X large - 24px
  /// Use for: Modal sheets, large containers
  static const double xxl = 24.0;

  /// Full - 9999px (pill shape)
  /// Use for: Pills, circular buttons
  static const double full = 9999.0;

  // BorderRadius helpers
  static BorderRadius get xsRadius => BorderRadius.circular(xs);
  static BorderRadius get smRadius => BorderRadius.circular(sm);
  static BorderRadius get mdRadius => BorderRadius.circular(md);
  static BorderRadius get lgRadius => BorderRadius.circular(lg);
  static BorderRadius get xlRadius => BorderRadius.circular(xl);
  static BorderRadius get xxlRadius => BorderRadius.circular(xxl);
  static BorderRadius get fullRadius => BorderRadius.circular(full);
}
