import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_logging_service.dart';

/// Theme service to manage app themes and dark mode
class ThemeService {
  static const String _themeModeKey = 'theme_mode';
  static const String _customColorSchemeKey = 'custom_color_scheme';
  static const String _highContrastKey = 'high_contrast';
  static const String _autoThemeKey = 'auto_theme';

  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  ThemeMode _themeMode = ThemeMode.system;
  bool _autoTheme = true;
  bool _highContrast = false;
  String _customColorScheme = 'default';

  /// Get current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Get auto theme setting
  bool get autoTheme => _autoTheme;

  /// Get high contrast setting
  bool get highContrast => _highContrast;

  /// Get custom color scheme
  String get customColorScheme => _customColorScheme;

  /// Initialize theme service and load settings
  Future<void> initialize() async {
    try {
      await _loadSettings();
      _setupSystemThemeListener();
      AppLogging.logInfo('Theme service initialized');
    } catch (e) {
      AppLogging.logError('Failed to initialize theme service: $e');
    }
  }

  /// Load theme settings from preferences
  Future<void> _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final themeModeIndex = prefs.getInt(_themeModeKey);
      _themeMode = ThemeMode.values[themeModeIndex?.clamp(0, ThemeMode.values.length - 1) ?? 0];

      _autoTheme = prefs.getBool(_autoThemeKey) ?? true;
      _highContrast = prefs.getBool(_highContrastKey) ?? false;
      _customColorScheme = prefs.getString(_customColorSchemeKey) ?? 'default';

      AppLogging.logInfo('Theme settings loaded: mode=$_themeMode, auto=$_autoTheme, highContrast=$_highContrast');
    } catch (e) {
      AppLogging.logError('Failed to load theme settings: $e');
    }
  }

  /// Save theme settings to preferences
  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeModeKey, _themeMode.index);
      await prefs.setBool(_autoThemeKey, _autoTheme);
      await prefs.setBool(_highContrastKey, _highContrast);
      await prefs.setString(_customColorSchemeKey, _customColorScheme);

      AppLogging.logInfo('Theme settings saved: mode=$_themeMode, auto=$_autoTheme, highContrast=$_highContrast');
    } catch (e) {
      AppLogging.logError('Failed to save theme settings: $e');
    }
  }

  /// Setup system theme listener
  void _setupSystemThemeListener() {
    if (_autoTheme) {
      // Listen to system theme changes
      // This would typically use platform-specific APIs
      // For now, we'll check periodically
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _saveSettings();
    AppLogging.logInfo('Theme mode changed to: $mode');
  }

  /// Set auto theme
  Future<void> setAutoTheme(bool auto) async {
    _autoTheme = auto;
    await _saveSettings();
    AppLogging.logInfo('Auto theme changed to: $auto');

    if (auto) {
      _syncWithSystemTheme();
    }
  }

  /// Set high contrast mode
  Future<void> setHighContrast(bool highContrast) async {
    _highContrast = highContrast;
    await _saveSettings();
    AppLogging.logInfo('High contrast changed to: $highContrast');
  }

  /// Set custom color scheme
  Future<void> setCustomColorScheme(String scheme) async {
    _customColorScheme = scheme;
    await _saveSettings();
    AppLogging.logInfo('Custom color scheme changed to: $scheme');
  }

  /// Sync with system theme
  void _syncWithSystemTheme() {
    if (!_autoTheme) return;

    // This would typically use platform-specific APIs
    // For now, we'll use a simple heuristic based on time
    final hour = DateTime.now().hour;
    final isDark = hour < 6 || hour >= 18;

    final newMode = isDark ? ThemeMode.dark : ThemeMode.light;
    if (newMode != _themeMode) {
      setThemeMode(newMode);
    }
  }

  /// Get optimized theme data
  ThemeData getOptimizedTheme(BuildContext context, {bool isDarkMode = false}) {
    final baseTheme = isDarkMode ? _buildDarkTheme() : _buildLightTheme();

    if (_highContrast) {
      return _buildHighContrastTheme(baseTheme);
    }

    return baseTheme.copyWith(colorScheme: _getCustomColorScheme(baseTheme.colorScheme.brightness));
  }

  /// Build light theme
  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.light),
      appBarTheme: const AppBarTheme(elevation: 0, scrolledUnderElevation: 1, centerTitle: true, backgroundColor: Colors.transparent),
      cardTheme: CardThemeData(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  /// Build dark theme
  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue, brightness: Brightness.dark),
      appBarTheme: const AppBarTheme(elevation: 0, scrolledUnderElevation: 1, centerTitle: true, backgroundColor: Colors.transparent),
      cardTheme: CardThemeData(elevation: 2, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),
    );
  }

  /// Build high contrast theme
  ThemeData _buildHighContrastTheme(ThemeData baseTheme) {
    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        surface: baseTheme.colorScheme.brightness == Brightness.dark ? Colors.black : Colors.white,
        onSurface: baseTheme.colorScheme.brightness == Brightness.dark ? Colors.white : Colors.black,
        primary: baseTheme.colorScheme.brightness == Brightness.dark ? Colors.white : Colors.black,
        secondary: baseTheme.colorScheme.brightness == Brightness.dark ? Colors.grey.withValues(alpha: 0.7) : Colors.grey.withValues(alpha: 0.7),
      ),
      textTheme: baseTheme.textTheme.copyWith(
        bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
        bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
        titleLarge: baseTheme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  /// Get custom color scheme
  ColorScheme _getCustomColorScheme(Brightness brightness) {
    switch (_customColorScheme) {
      case 'ocean':
        return ColorScheme.fromSeed(seedColor: Colors.blue, brightness: brightness);
      case 'forest':
        return ColorScheme.fromSeed(seedColor: Colors.green, brightness: brightness);
      case 'sunset':
        return ColorScheme.fromSeed(seedColor: Colors.orange, brightness: brightness);
      case 'purple':
        return ColorScheme.fromSeed(seedColor: Colors.purple, brightness: brightness);
      case 'teal':
        return ColorScheme.fromSeed(seedColor: Colors.teal, brightness: brightness);
      case 'rose':
        return ColorScheme.fromSeed(seedColor: Colors.pink, brightness: brightness);
      default:
        return ColorScheme.fromSeed(seedColor: Colors.blue, brightness: brightness);
    }
  }

  /// Get available color schemes
  List<String> get availableColorSchemes => ['default', 'ocean', 'forest', 'sunset', 'purple', 'teal', 'rose'];

  /// Get theme mode display name
  String getThemeModeDisplayName(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      case ThemeMode.system:
        return 'System';
    }
  }

  /// Get color scheme display name
  String getColorSchemeDisplayName(String scheme) {
    switch (scheme) {
      case 'ocean':
        return 'Ocean Blue';
      case 'forest':
        return 'Forest Green';
      case 'sunset':
        return 'Sunset Orange';
      case 'purple':
        return 'Royal Purple';
      case 'teal':
        return 'Teal';
      case 'rose':
        return 'Rose Pink';
      default:
        return 'Default Blue';
    }
  }

  /// Check if dark mode is currently active
  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // Check system theme
      final brightness = MediaQueryData.fromView(WidgetsBinding.instance.platformDispatcher.views.first).platformBrightness;
      return brightness == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  /// Reset theme settings to defaults
  Future<void> resetToDefaults() async {
    _themeMode = ThemeMode.system;
    _autoTheme = true;
    _highContrast = false;
    _customColorScheme = 'default';
    await _saveSettings();
    AppLogging.logInfo('Theme settings reset to defaults');
  }
}

/// Theme change notifier for reactive UI updates
class ThemeNotifier extends ChangeNotifier {
  final ThemeService _service = ThemeService();

  ThemeMode get themeMode => _service.themeMode;
  bool get autoTheme => _service.autoTheme;
  bool get highContrast => _service.highContrast;
  String get customColorScheme => _service.customColorScheme;
  bool get isDarkMode => _service.isDarkMode;

  Future<void> setThemeMode(ThemeMode mode) async {
    await _service.setThemeMode(mode);
    notifyListeners();
  }

  Future<void> setAutoTheme(bool auto) async {
    await _service.setAutoTheme(auto);
    notifyListeners();
  }

  Future<void> setHighContrast(bool highContrast) async {
    await _service.setHighContrast(highContrast);
    notifyListeners();
  }

  Future<void> setCustomColorScheme(String scheme) async {
    await _service.setCustomColorScheme(scheme);
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    await _service.resetToDefaults();
    notifyListeners();
  }
}
