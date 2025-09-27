import 'package:flutter/material.dart';

/// Comprehensive Design System for Tazbeet
/// Provides consistent spacing, typography, colors, and component styles

class AppSpacing {
  // Base spacing unit (4px)
  static const double xs = 4.0; // 4px
  static const double sm = 8.0; // 8px
  static const double md = 16.0; // 16px
  static const double lg = 24.0; // 24px
  static const double xl = 32.0; // 32px
  static const double xxl = 48.0; // 48px
  static const double xxxl = 64.0; // 64px

  // Content spacing
  static const double contentPadding = md; // 16px
  static const double sectionSpacing = lg; // 24px
  static const double cardSpacing = sm; // 8px
}

class AppRadius {
  static const double none = 0.0;
  static const double xs = 4.0; // Small radius for minor elements
  static const double sm = 8.0; // Standard radius for buttons
  static const double md = 12.0; // Card radius
  static const double lg = 16.0; // Large radius for dialogs
  static const double xl = 24.0; // Extra large for special cases
  static const double full = 9999.0; // Full circle
}

class AppTypography {
  // Font sizes based on Material Design 3
  static const double displayLarge = 57.0;
  static const double displayMedium = 45.0;
  static const double displaySmall = 36.0;
  static const double headlineLarge = 32.0;
  static const double headlineMedium = 28.0;
  static const double headlineSmall = 24.0;
  static const double titleLarge = 22.0;
  static const double titleMedium = 16.0;
  static const double titleSmall = 14.0;
  static const double bodyLarge = 16.0;
  static const double bodyMedium = 14.0;
  static const double bodySmall = 12.0;
  static const double labelLarge = 14.0;
  static const double labelMedium = 12.0;
  static const double labelSmall = 11.0;
}

class AppShadows {
  static List<BoxShadow> get card => [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 8, offset: const Offset(0, 2))];

  static List<BoxShadow> get cardHover => [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 12, offset: const Offset(0, 4))];

  static List<BoxShadow> get elevated => [BoxShadow(color: Colors.black.withValues(alpha: 0.12), blurRadius: 16, offset: const Offset(0, 4))];

  static List<BoxShadow> get fab => [BoxShadow(color: Colors.black.withValues(alpha: 0.24), blurRadius: 16, offset: const Offset(0, 6))];
}

class AppColors {
  // Semantic colors that work with both light and dark themes
  static Color get success => Colors.green.shade600;
  static Color get warning => Colors.orange.shade600;
  static Color get error => Colors.red.shade600;
  static Color get info => Colors.blue.shade600;

  // Priority colors
  static Color get priorityHigh => Colors.red.shade500;
  static Color get priorityMedium => Colors.orange.shade500;
  static Color get priorityLow => Colors.green.shade500;

  // Status colors
  static Color get completed => Colors.green.shade600;
  static Color get pending => Colors.orange.shade600;
  static Color get overdue => Colors.red.shade600;
}

class AppAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  static const Curve standard = Curves.easeInOut;
  static const Curve bounce = Curves.easeOutBack;
  static const Curve gentle = Curves.easeOutCubic;
}

class AppSizes {
  // Touch target sizes (minimum 44pt)
  static const double touchTarget = 44.0;
  static const double iconSmall = 16.0;
  static const double iconMedium = 20.0;
  static const double iconLarge = 24.0;
  static const double iconExtraLarge = 32.0;

  // Component heights
  static const double appBarHeight = 56.0;
  static const double bottomNavHeight = 80.0;
  static const double listItemHeight = 72.0;
  static const double cardMinHeight = 80.0;
}

// Extension methods for consistent styling
extension AppThemeExtension on BuildContext {
  // Spacing utilities
  double get spacingXs => AppSpacing.xs;
  double get spacingSm => AppSpacing.sm;
  double get spacingMd => AppSpacing.md;
  double get spacingLg => AppSpacing.lg;
  double get spacingXl => AppSpacing.xl;

  // Typography utilities
  TextStyle get displayLarge => Theme.of(this).textTheme.displayLarge!;
  TextStyle get displayMedium => Theme.of(this).textTheme.displayMedium!;
  TextStyle get displaySmall => Theme.of(this).textTheme.displaySmall!;
  TextStyle get headlineLarge => Theme.of(this).textTheme.headlineLarge!;
  TextStyle get headlineMedium => Theme.of(this).textTheme.headlineMedium!;
  TextStyle get headlineSmall => Theme.of(this).textTheme.headlineSmall!;
  TextStyle get titleLarge => Theme.of(this).textTheme.titleLarge!;
  TextStyle get titleMedium => Theme.of(this).textTheme.titleMedium!;
  TextStyle get titleSmall => Theme.of(this).textTheme.titleSmall!;
  TextStyle get bodyLarge => Theme.of(this).textTheme.bodyLarge!;
  TextStyle get bodyMedium => Theme.of(this).textTheme.bodyMedium!;
  TextStyle get bodySmall => Theme.of(this).textTheme.bodySmall!;
  TextStyle get labelLarge => Theme.of(this).textTheme.labelLarge!;
  TextStyle get labelMedium => Theme.of(this).textTheme.labelMedium!;
  TextStyle get labelSmall => Theme.of(this).textTheme.labelSmall!;
}

// Consistent button styles
class AppButtonStyles {
  static ButtonStyle primary(BuildContext context) => ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.primary,
    foregroundColor: Theme.of(context).colorScheme.onPrimary,
    elevation: 0,
    shadowColor: Colors.transparent,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
    textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
  );

  static ButtonStyle secondary(BuildContext context) => OutlinedButton.styleFrom(
    side: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1.5),
    foregroundColor: Theme.of(context).colorScheme.onSurface,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
    textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
  );

  static ButtonStyle text(BuildContext context) => TextButton.styleFrom(
    foregroundColor: Theme.of(context).colorScheme.primary,
    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
    textStyle: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500),
  );

  static ButtonStyle icon(BuildContext context, {Color? backgroundColor}) => IconButton.styleFrom(
    backgroundColor: backgroundColor,
    foregroundColor: Theme.of(context).colorScheme.onSurface,
    iconSize: AppSizes.iconMedium,
    minimumSize: const Size(AppSizes.touchTarget, AppSizes.touchTarget),
    padding: const EdgeInsets.all(AppSpacing.sm),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
  );
}

// Consistent card styles
class AppCardStyles {
  static BoxDecoration standard(BuildContext context) => BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(AppRadius.md),
    boxShadow: AppShadows.card,
    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
  );

  static BoxDecoration elevated(BuildContext context) => BoxDecoration(
    color: Theme.of(context).colorScheme.surface,
    borderRadius: BorderRadius.circular(AppRadius.md),
    boxShadow: AppShadows.elevated,
    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.3), width: 0.5),
  );

  static BoxDecoration interactive(BuildContext context) =>
      BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        boxShadow: AppShadows.card,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5), width: 0.5),
      ).copyWith(
        color: MaterialStateColor.resolveWith((states) {
          if (states.contains(MaterialState.hovered)) {
            return Theme.of(context).colorScheme.surfaceVariant;
          }
          return Theme.of(context).colorScheme.surface;
        }),
      );
}

// Input field styles
class AppInputStyles {
  static InputDecoration standard(BuildContext context, String label) => InputDecoration(
    labelText: label,
    labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline, width: 1.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5), width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.sm),
      borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1.5),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
  );
}
