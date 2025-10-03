import 'package:flutter/material.dart';
import '../../services/color_customization_service.dart';

class AppThemes {
  // Color palette for more vibrant theme
  static const Color _primaryLight = Color(0xFF6366F1); // Indigo
  static const Color _secondaryLight = Color(0xFFEC4899); // Pink
  static const Color _tertiaryLight = Color(0xFF10B981); // Emerald
  static const Color _accentLight = Color(0xFFF59E0B); // Amber

  static const Color _primaryDark = Color(0xFF8B5CF6); // Violet
  static const Color _secondaryDark = Color(0xFFF472B6); // Pink
  static const Color _tertiaryDark = Color(0xFF34D399); // Emerald
  static const Color _accentDark = Color(0xFFFBBF24); // Yellow

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: 'TajawalR',
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryLight,
        brightness: Brightness.light,
        primary: _primaryLight,
        secondary: _secondaryLight,
        tertiary: _tertiaryLight,
        surfaceTint: _accentLight,
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Light gray background
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _primaryLight.withValues(alpha: 0.1),
        foregroundColor: _primaryLight,
        titleTextStyle: const TextStyle(
          color: _primaryLight,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        shadowColor: _primaryLight.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        surfaceTintColor: _primaryLight.withValues(alpha: 0.1),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 6,
        backgroundColor: _secondaryLight,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: _primaryLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryLight.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primaryLight, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        labelStyle: TextStyle(color: _primaryLight.withValues(alpha: 0.7)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _primaryLight.withValues(alpha: 0.1),
        selectedColor: _primaryLight.withValues(alpha: 0.2),
        checkmarkColor: _primaryLight,
        labelStyle: TextStyle(color: _primaryLight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: _secondaryLight,
        linearTrackColor: _secondaryLight.withValues(alpha: 0.2),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: 'TajawalR',
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryDark,
        brightness: Brightness.dark,
        primary: _primaryDark,
        secondary: _secondaryDark,
        tertiary: _tertiaryDark,
        surfaceTint: _accentDark,
      ),
      scaffoldBackgroundColor: const Color(
        0xFF0F172A,
      ), // Dark blue-gray background
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: _primaryDark.withValues(alpha: 0.2),
        foregroundColor: _primaryDark,
        titleTextStyle: TextStyle(
          color: _primaryDark,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        shadowColor: _primaryDark.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: const Color(0xFF1E293B), // Dark card background
        surfaceTintColor: _primaryDark.withValues(alpha: 0.1),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 6,
        backgroundColor: _secondaryDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: _primaryDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryDark.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _primaryDark, width: 2),
        ),
        filled: true,
        fillColor: const Color(0xFF334155), // Dark input background
        labelStyle: TextStyle(color: _primaryDark.withValues(alpha: 0.7)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: _primaryDark.withValues(alpha: 0.2),
        selectedColor: _primaryDark.withValues(alpha: 0.3),
        checkmarkColor: _primaryDark,
        labelStyle: TextStyle(color: _primaryDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: _secondaryDark,
        linearTrackColor: _secondaryDark.withValues(alpha: 0.2),
      ),
    );
  }

  static ThemeData getCustomTheme(Color primaryColor, bool isDark) {

    final baseSecondary = isDark ? _secondaryDark : _secondaryLight;
    final baseTertiary = isDark ? _tertiaryDark : _tertiaryLight;
    final baseAccent = isDark ? _accentDark : _accentLight;

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      fontFamily: 'TajawalR',
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primaryColor,
        secondary: baseSecondary,
        tertiary: baseTertiary,
        surfaceTint: baseAccent,
      ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0F172A)
          : const Color(0xFFF8FAFC),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: primaryColor.withValues(alpha: 0.1),
        foregroundColor: primaryColor,
        titleTextStyle: TextStyle(
          color: primaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 3,
        shadowColor: primaryColor.withValues(alpha: 0.2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        surfaceTintColor: primaryColor.withValues(alpha: 0.1),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: 6,
        backgroundColor: baseSecondary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor.withValues(alpha: 0.3)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF334155) : Colors.white,
        labelStyle: TextStyle(color: primaryColor.withValues(alpha: 0.7)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: primaryColor.withValues(alpha: 0.1),
        selectedColor: primaryColor.withValues(alpha: 0.2),
        checkmarkColor: primaryColor,
        labelStyle: TextStyle(color: primaryColor),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: baseSecondary,
        linearTrackColor: baseSecondary.withValues(alpha: 0.2),
      ),
    );
  }

  // Get theme with color customization service integration
  static ThemeData getLightThemeWithCustomization(ColorCustomizationService colorService) {
    final effectivePrimary = colorService.getEffectivePrimaryColor(false);
    return colorService.useCustomColors
        ? getCustomTheme(effectivePrimary, false)
        : lightTheme;
  }

  static ThemeData getDarkThemeWithCustomization(ColorCustomizationService colorService) {
    final effectivePrimary = colorService.getEffectivePrimaryColor(true);
    return colorService.useCustomColors
        ? getCustomTheme(effectivePrimary, true)
        : darkTheme;
  }

  // Priority-based colors for tasks
  static Color getPriorityColor(String priority, bool isDark) {
    switch (priority.toLowerCase()) {
      case 'high':
        return isDark
            ? const Color(0xFFEF4444)
            : const Color(0xFFDC2626); // Red
      case 'medium':
        return isDark
            ? const Color(0xFFF59E0B)
            : const Color(0xFFD97706); // Orange
      case 'low':
        return isDark
            ? const Color(0xFF10B981)
            : const Color(0xFF059669); // Green
      default:
        return isDark ? _primaryDark : _primaryLight;
    }
  }

  // Gradient backgrounds for special elements
  static LinearGradient getPrimaryGradient(bool isDark) {
    return LinearGradient(
      colors: isDark
          ? [_primaryDark, _secondaryDark]
          : [_primaryLight, _secondaryLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  static LinearGradient getAccentGradient(bool isDark) {
    return LinearGradient(
      colors: isDark
          ? [_accentDark, _tertiaryDark]
          : [_accentLight, _tertiaryLight],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}
