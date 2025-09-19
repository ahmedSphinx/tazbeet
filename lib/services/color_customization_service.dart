import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ColorCustomizationService extends ChangeNotifier {
  static final ColorCustomizationService _instance = ColorCustomizationService._internal();
  factory ColorCustomizationService() => _instance;
  ColorCustomizationService._internal();

  Color? _customPrimaryColor;
  bool _useCustomColors = false;

  Color? get customPrimaryColor => _customPrimaryColor;
  bool get useCustomColors => _useCustomColors;

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _useCustomColors = prefs.getBool('use_custom_colors') ?? false;

    final colorValue = prefs.getInt('custom_primary_color');
    if (colorValue != null) {
      _customPrimaryColor = Color(colorValue);
    }

    notifyListeners();
  }

  Future<void> setCustomPrimaryColor(Color color) async {
    _customPrimaryColor = color;
    _useCustomColors = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_custom_colors', true);
    await prefs.setInt('custom_primary_color', color.value);

    notifyListeners();
  }

  Future<void> enableCustomColors(bool enabled) async {
    _useCustomColors = enabled;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('use_custom_colors', enabled);

    notifyListeners();
  }

  Future<void> resetToDefault() async {
    _customPrimaryColor = null;
    _useCustomColors = false;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('use_custom_colors');
    await prefs.remove('custom_primary_color');

    notifyListeners();
  }

  // Get the effective primary color (custom or default)
  Color getEffectivePrimaryColor(bool isDark) {
    if (_useCustomColors && _customPrimaryColor != null) {
      return _customPrimaryColor!;
    }

    // Return default colors based on theme
    return isDark
        ? const Color(0xFF8B5CF6) // Violet for dark
        : const Color(0xFF6366F1); // Indigo for light
  }
}
