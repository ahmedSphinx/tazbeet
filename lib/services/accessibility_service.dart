import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_logging_service.dart';

/// Comprehensive accessibility and UI/UX optimization service
class AccessibilityService {
  static final AccessibilityService _instance = AccessibilityService._internal();
  factory AccessibilityService() => _instance;
  AccessibilityService._internal();

  // Accessibility settings
  bool _highContrastEnabled = false;
  bool _largeTextEnabled = false;
  bool _reducedMotionEnabled = false;
  bool _screenReaderEnabled = false;
  bool _hapticFeedbackEnabled = true;
  double _textScaleFactor = 1.0;
  ColorBlindnessType _colorBlindnessType = ColorBlindnessType.none;

  // UI optimization settings
  bool _autoOptimizeEnabled = true;
  bool _gestureSimplificationEnabled = false;
  bool _voiceCommandsEnabled = false;
  double _animationSpeedFactor = 1.0;
  int _touchTargetSize = 44; // Minimum touch target size in pixels

  final List<AccessibilityEvent> _events = [];
  Timer? _optimizationTimer;

  void initialize() {
    _loadSettings();
    _setupSystemListeners();
    _startOptimization();
    AppLogging.logInfo('Accessibility service initialized');
  }

  /// Check if accessibility features should be enabled based on system settings
  Future<void> checkSystemAccessibility() async {
    try {
      // Check system accessibility settings
      final prefs = await SharedPreferences.getInstance();

      // Large text
      final systemLargeText = prefs.getBool('system_large_text') ?? false;
      if (systemLargeText != _largeTextEnabled) {
        _largeTextEnabled = systemLargeText;
        _updateTextScale();
      }

      // High contrast
      final systemHighContrast = prefs.getBool('system_high_contrast') ?? false;
      if (systemHighContrast != _highContrastEnabled) {
        _highContrastEnabled = systemHighContrast;
        _updateContrast();
      }

      // Reduced motion
      final systemReducedMotion = prefs.getBool('system_reduced_motion') ?? false;
      if (systemReducedMotion != _reducedMotionEnabled) {
        _reducedMotionEnabled = systemReducedMotion;
        _updateAnimationSettings();
      }

      _recordEvent(AccessibilityEvent(type: AccessibilityEventType.systemCheck, description: 'System accessibility settings checked', timestamp: DateTime.now()));
    } catch (e, stackTrace) {
      AppLogging.logError('Failed to check system accessibility', error: e, stackTrace: stackTrace);
    }
  }

  /// Get optimized theme data based on accessibility settings
  ThemeData getOptimizedTheme(ThemeData baseTheme, {bool isDark = false}) {
    final themeData = baseTheme.copyWith(
      textTheme: _getOptimizedTextTheme(baseTheme.textTheme),
      colorScheme: _getOptimizedColorScheme(baseTheme.colorScheme),
      elevatedButtonTheme: _getOptimizedButtonTheme(baseTheme.elevatedButtonTheme),
      cardTheme: _getOptimizedCardTheme(baseTheme.cardTheme),
      appBarTheme: _getOptimizedAppBarTheme(baseTheme.appBarTheme),
    );

    if (_highContrastEnabled) {
      return _applyHighContrast(themeData);
    }

    if (_colorBlindnessType != ColorBlindnessType.none) {
      return _applyColorBlindnessFilter(themeData);
    }

    return themeData;
  }

  /// Get optimized text scale factor
  double getTextScaleFactor() {
    if (_largeTextEnabled) {
      return (_textScaleFactor * 1.3).clamp(1.0, 2.0);
    }
    return _textScaleFactor.clamp(0.8, 2.0);
  }

  /// Get optimized animation duration
  Duration getOptimizedAnimationDuration(Duration baseDuration) {
    if (_reducedMotionEnabled) {
      return Duration.zero;
    }
    return Duration(milliseconds: (baseDuration.inMilliseconds / _animationSpeedFactor).round());
  }

  /// Check if widget meets accessibility standards
  AccessibilityCheckResult checkWidgetAccessibility(Widget widget, {String? context}) {
    final issues = <AccessibilityIssue>[];
    final warnings = <AccessibilityIssue>[];

    // Check semantic labels
    if (!_hasSemanticLabel(widget)) {
      issues.add(AccessibilityIssue(type: AccessibilityIssueType.missingSemanticLabel, description: 'Widget missing semantic label', severity: AccessibilitySeverity.high, context: context));
    }

    // Check touch target size
    if (!_hasMinimumTouchTarget(widget)) {
      issues.add(AccessibilityIssue(type: AccessibilityIssueType.insufficientTouchTarget, description: 'Touch target smaller than minimum size', severity: AccessibilitySeverity.medium, context: context));
    }

    // Check color contrast
    if (!_hasSufficientContrast(widget)) {
      warnings.add(AccessibilityIssue(type: AccessibilityIssueType.insufficientContrast, description: 'Color contrast may be insufficient', severity: AccessibilitySeverity.low, context: context));
    }

    // Check for screen reader support
    if (!_supportsScreenReader(widget)) {
      warnings.add(AccessibilityIssue(type: AccessibilityIssueType.poorScreenReaderSupport, description: 'Widget may not work well with screen readers', severity: AccessibilitySeverity.medium, context: context));
    }

    return AccessibilityCheckResult(isAccessible: issues.isEmpty, issues: issues, warnings: warnings, widgetType: widget.runtimeType.toString(), context: context);
  }

  /// Optimize widget for accessibility
  Widget optimizeWidgetForAccessibility(Widget widget, {String? semanticLabel, String? semanticHint}) {
    List<Widget> children = [widget];

    // Add semantic label if provided
    if (semanticLabel != null) {
      children = [Semantics(label: semanticLabel, hint: semanticHint, child: widget)];
    }

    // Apply high contrast if enabled
    if (_highContrastEnabled) {
      children = [Theme(data: _applyHighContrast(ThemeData.dark()), child: children.last)];
    }

    // Apply larger touch targets if needed
    if (_touchTargetSize > 44) {
      children = [Padding(padding: EdgeInsets.all((_touchTargetSize - 44) / 2), child: children.last)];
    }

    return children.last;
  }

  /// Get accessibility recommendations
  List<AccessibilityRecommendation> getRecommendations() {
    final recommendations = <AccessibilityRecommendation>[];

    if (!_highContrastEnabled && _shouldEnableHighContrast()) {
      recommendations.add(
        AccessibilityRecommendation(
          type: RecommendationType.contrast,
          title: 'Enable High Contrast',
          description: 'High contrast mode can improve visibility',
          priority: RecommendationPriority.medium,
          action: () => _enableHighContrast(),
        ),
      );
    }

    if (!_largeTextEnabled && _shouldEnableLargeText()) {
      recommendations.add(
        AccessibilityRecommendation(
          type: RecommendationType.textSize,
          title: 'Enable Large Text',
          description: 'Larger text can improve readability',
          priority: RecommendationPriority.low,
          action: () => _enableLargeText(),
        ),
      );
    }

    if (!_reducedMotionEnabled && _shouldEnableReducedMotion()) {
      recommendations.add(
        AccessibilityRecommendation(
          type: RecommendationType.motion,
          title: 'Enable Reduced Motion',
          description: 'Reduced motion can help with motion sensitivity',
          priority: RecommendationPriority.low,
          action: () => _enableReducedMotion(),
        ),
      );
    }

    return recommendations;
  }

  /// Update accessibility settings
  Future<void> updateSettings({
    bool? highContrastEnabled,
    bool? largeTextEnabled,
    bool? reducedMotionEnabled,
    bool? screenReaderEnabled,
    bool? hapticFeedbackEnabled,
    double? textScaleFactor,
    ColorBlindnessType? colorBlindnessType,
    bool? autoOptimizeEnabled,
    bool? gestureSimplificationEnabled,
    bool? voiceCommandsEnabled,
    double? animationSpeedFactor,
    int? touchTargetSize,
  }) async {
    bool needsUpdate = false;

    if (highContrastEnabled != null && highContrastEnabled != _highContrastEnabled) {
      _highContrastEnabled = highContrastEnabled;
      _updateContrast();
      needsUpdate = true;
    }

    if (largeTextEnabled != null && largeTextEnabled != _largeTextEnabled) {
      _largeTextEnabled = largeTextEnabled;
      _updateTextScale();
      needsUpdate = true;
    }

    if (reducedMotionEnabled != null && reducedMotionEnabled != _reducedMotionEnabled) {
      _reducedMotionEnabled = reducedMotionEnabled;
      _updateAnimationSettings();
      needsUpdate = true;
    }

    if (screenReaderEnabled != null) _screenReaderEnabled = screenReaderEnabled;
    if (hapticFeedbackEnabled != null) _hapticFeedbackEnabled = hapticFeedbackEnabled;
    if (textScaleFactor != null) _textScaleFactor = textScaleFactor;
    if (colorBlindnessType != null) _colorBlindnessType = colorBlindnessType;
    if (autoOptimizeEnabled != null) _autoOptimizeEnabled = autoOptimizeEnabled;
    if (gestureSimplificationEnabled != null) _gestureSimplificationEnabled = gestureSimplificationEnabled;
    if (voiceCommandsEnabled != null) _voiceCommandsEnabled = voiceCommandsEnabled;
    if (animationSpeedFactor != null) _animationSpeedFactor = animationSpeedFactor;
    if (touchTargetSize != null) _touchTargetSize = touchTargetSize;

    if (needsUpdate) {
      await _saveSettings();
    }
  }

  /// Get accessibility metrics
  Map<String, dynamic> getAccessibilityMetrics() {
    return {
      'high_contrast_enabled': _highContrastEnabled,
      'large_text_enabled': _largeTextEnabled,
      'reduced_motion_enabled': _reducedMotionEnabled,
      'screen_reader_enabled': _screenReaderEnabled,
      'haptic_feedback_enabled': _hapticFeedbackEnabled,
      'text_scale_factor': _textScaleFactor,
      'color_blindness_type': _colorBlindnessType.name,
      'auto_optimize_enabled': _autoOptimizeEnabled,
      'gesture_simplification_enabled': _gestureSimplificationEnabled,
      'voice_commands_enabled': _voiceCommandsEnabled,
      'animation_speed_factor': _animationSpeedFactor,
      'touch_target_size': _touchTargetSize,
      'accessibility_score': _calculateAccessibilityScore(),
      'recent_events': _events.take(10).toList(),
    };
  }

  void dispose() {
    _optimizationTimer?.cancel();
  }

  // Private methods

  void _loadSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _highContrastEnabled = prefs.getBool('high_contrast_enabled') ?? false;
      _largeTextEnabled = prefs.getBool('large_text_enabled') ?? false;
      _reducedMotionEnabled = prefs.getBool('reduced_motion_enabled') ?? false;
      _screenReaderEnabled = prefs.getBool('screen_reader_enabled') ?? false;
      _hapticFeedbackEnabled = prefs.getBool('haptic_feedback_enabled') ?? true;
      _textScaleFactor = prefs.getDouble('text_scale_factor') ?? 1.0;
      _colorBlindnessType = ColorBlindnessType.values[prefs.getInt('color_blindness_type') ?? 0];
      _autoOptimizeEnabled = prefs.getBool('auto_optimize_enabled') ?? true;
      _gestureSimplificationEnabled = prefs.getBool('gesture_simplification_enabled') ?? false;
      _voiceCommandsEnabled = prefs.getBool('voice_commands_enabled') ?? false;
      _animationSpeedFactor = prefs.getDouble('animation_speed_factor') ?? 1.0;
      _touchTargetSize = prefs.getInt('touch_target_size') ?? 44;
    } catch (e, stackTrace) {
      AppLogging.logError('Failed to load accessibility settings', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> _saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('high_contrast_enabled', _highContrastEnabled);
      await prefs.setBool('large_text_enabled', _largeTextEnabled);
      await prefs.setBool('reduced_motion_enabled', _reducedMotionEnabled);
      await prefs.setBool('screen_reader_enabled', _screenReaderEnabled);
      await prefs.setBool('haptic_feedback_enabled', _hapticFeedbackEnabled);
      await prefs.setDouble('text_scale_factor', _textScaleFactor);
      await prefs.setInt('color_blindness_type', _colorBlindnessType.index);
      await prefs.setBool('auto_optimize_enabled', _autoOptimizeEnabled);
      await prefs.setBool('gesture_simplification_enabled', _gestureSimplificationEnabled);
      await prefs.setBool('voice_commands_enabled', _voiceCommandsEnabled);
      await prefs.setDouble('animation_speed_factor', _animationSpeedFactor);
      await prefs.setInt('touch_target_size', _touchTargetSize);
    } catch (e, stackTrace) {
      AppLogging.logError('Failed to save accessibility settings', error: e, stackTrace: stackTrace);
    }
  }

  void _setupSystemListeners() {
    // Listen for system accessibility changes
    // This would typically use platform-specific APIs
  }

  void _startOptimization() {
    if (_autoOptimizeEnabled) {
      _optimizationTimer = Timer.periodic(const Duration(minutes: 5), (_) {
        _performAutoOptimization();
      });
    }
  }

  void _performAutoOptimization() {
    // Automatically adjust settings based on usage patterns
    checkSystemAccessibility();
  }

  void _updateContrast() {
    _recordEvent(AccessibilityEvent(type: AccessibilityEventType.settingChanged, description: 'Contrast settings updated', timestamp: DateTime.now()));
  }

  void _updateTextScale() {
    _recordEvent(AccessibilityEvent(type: AccessibilityEventType.settingChanged, description: 'Text scale settings updated', timestamp: DateTime.now()));
  }

  void _updateAnimationSettings() {
    _recordEvent(AccessibilityEvent(type: AccessibilityEventType.settingChanged, description: 'Animation settings updated', timestamp: DateTime.now()));
  }

  TextTheme _getOptimizedTextTheme(TextTheme baseTheme) {
    final scaleFactor = getTextScaleFactor();
    return baseTheme.copyWith(
      displayLarge: baseTheme.displayLarge?.copyWith(fontSize: (baseTheme.displayLarge?.fontSize ?? 57) * scaleFactor),
      displayMedium: baseTheme.displayMedium?.copyWith(fontSize: (baseTheme.displayMedium?.fontSize ?? 45) * scaleFactor),
      displaySmall: baseTheme.displaySmall?.copyWith(fontSize: (baseTheme.displaySmall?.fontSize ?? 36) * scaleFactor),
      headlineLarge: baseTheme.headlineLarge?.copyWith(fontSize: (baseTheme.headlineLarge?.fontSize ?? 32) * scaleFactor),
      headlineMedium: baseTheme.headlineMedium?.copyWith(fontSize: (baseTheme.headlineMedium?.fontSize ?? 28) * scaleFactor),
      headlineSmall: baseTheme.headlineSmall?.copyWith(fontSize: (baseTheme.headlineSmall?.fontSize ?? 24) * scaleFactor),
      titleLarge: baseTheme.titleLarge?.copyWith(fontSize: (baseTheme.titleLarge?.fontSize ?? 22) * scaleFactor),
      titleMedium: baseTheme.titleMedium?.copyWith(fontSize: (baseTheme.titleMedium?.fontSize ?? 16) * scaleFactor),
      titleSmall: baseTheme.titleSmall?.copyWith(fontSize: (baseTheme.titleSmall?.fontSize ?? 14) * scaleFactor),
      bodyLarge: baseTheme.bodyLarge?.copyWith(fontSize: (baseTheme.bodyLarge?.fontSize ?? 16) * scaleFactor),
      bodyMedium: baseTheme.bodyMedium?.copyWith(fontSize: (baseTheme.bodyMedium?.fontSize ?? 14) * scaleFactor),
      bodySmall: baseTheme.bodySmall?.copyWith(fontSize: (baseTheme.bodySmall?.fontSize ?? 12) * scaleFactor),
    );
  }

  ColorScheme _getOptimizedColorScheme(ColorScheme baseScheme) {
    if (_highContrastEnabled) {
      return baseScheme.copyWith(
        primary: _getHighContrastColor(baseScheme.primary),
        secondary: _getHighContrastColor(baseScheme.secondary),
        surface: Colors.white,
        onSurface: Colors.black,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
      );
    }
    return baseScheme;
  }

  Color _getHighContrastColor(Color color) {
    // Convert to high contrast version
    final hsl = HSLColor.fromColor(color);
    if (hsl.lightness > 0.5) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }

  ThemeData _applyHighContrast(ThemeData theme) {
    return theme.copyWith(
      colorScheme: theme.colorScheme.copyWith(surface: Colors.white, onSurface: Colors.black, primary: Colors.black, onPrimary: Colors.white),
    );
  }

  ThemeData _applyColorBlindnessFilter(ThemeData theme) {
    // Apply color blindness filter
    return theme; // Implementation would depend on specific color blindness type
  }

  bool _hasSemanticLabel(Widget widget) {
    // Check if widget has proper semantic labeling
    return true; // Simplified implementation
  }

  bool _hasMinimumTouchTarget(Widget widget) {
    // Check if widget meets minimum touch target size
    return true; // Simplified implementation
  }

  bool _hasSufficientContrast(Widget widget) {
    // Check color contrast ratios
    return true; // Simplified implementation
  }

  bool _supportsScreenReader(Widget widget) {
    // Check screen reader compatibility
    return true; // Simplified implementation
  }

  bool _shouldEnableHighContrast() {
    // Logic to determine if high contrast should be recommended
    return false; // Simplified implementation
  }

  bool _shouldEnableLargeText() {
    // Logic to determine if large text should be recommended
    return false; // Simplified implementation
  }

  bool _shouldEnableReducedMotion() {
    // Logic to determine if reduced motion should be recommended
    return false; // Simplified implementation
  }

  void _enableHighContrast() async {
    await updateSettings(highContrastEnabled: true);
  }

  void _enableLargeText() async {
    await updateSettings(largeTextEnabled: true);
  }

  void _enableReducedMotion() async {
    await updateSettings(reducedMotionEnabled: true);
  }

  void _recordEvent(AccessibilityEvent event) {
    _events.add(event);
    if (_events.length > 100) {
      _events.removeAt(0);
    }
  }

  double _calculateAccessibilityScore() {
    double score = 100.0;

    if (!_highContrastEnabled && _shouldEnableHighContrast()) score -= 10;
    if (!_largeTextEnabled && _shouldEnableLargeText()) score -= 5;
    if (!_reducedMotionEnabled && _shouldEnableReducedMotion()) score -= 5;
    if (!_hapticFeedbackEnabled) score -= 5;
    if (_touchTargetSize < 44) score -= 10;

    return score.clamp(0.0, 100.0);
  }

  // Additional theme optimization methods would go here...
  ElevatedButtonThemeData _getOptimizedButtonTheme(ElevatedButtonThemeData? baseTheme) => baseTheme ?? const ElevatedButtonThemeData();
  CardThemeData _getOptimizedCardTheme(CardThemeData? baseTheme) => baseTheme ?? const CardThemeData();
  AppBarTheme _getOptimizedAppBarTheme(AppBarTheme? baseTheme) => baseTheme ?? const AppBarTheme();
}

// Supporting classes

enum ColorBlindnessType { none, protanopia, deuteranopia, tritanopia }

enum AccessibilityEventType { settingChanged, systemCheck, widgetChecked, optimizationPerformed }

enum AccessibilityIssueType { missingSemanticLabel, insufficientTouchTarget, insufficientContrast, poorScreenReaderSupport }

enum AccessibilitySeverity { low, medium, high, critical }

enum RecommendationType { contrast, textSize, motion, haptic, gesture }

enum RecommendationPriority { low, medium, high }

class AccessibilityEvent {
  final AccessibilityEventType type;
  final String description;
  final DateTime timestamp;

  AccessibilityEvent({required this.type, required this.description, required this.timestamp});
}

class AccessibilityIssue {
  final AccessibilityIssueType type;
  final String description;
  final AccessibilitySeverity severity;
  final String? context;

  AccessibilityIssue({required this.type, required this.description, required this.severity, this.context});
}

class AccessibilityCheckResult {
  final bool isAccessible;
  final List<AccessibilityIssue> issues;
  final List<AccessibilityIssue> warnings;
  final String widgetType;
  final String? context;

  AccessibilityCheckResult({required this.isAccessible, required this.issues, required this.warnings, required this.widgetType, this.context});
}

class AccessibilityRecommendation {
  final RecommendationType type;
  final String title;
  final String description;
  final RecommendationPriority priority;
  final VoidCallback action;

  AccessibilityRecommendation({required this.type, required this.title, required this.description, required this.priority, required this.action});
}

class AccessibilityMetrics {
  final int widgetsChecked;
  final int issuesFound;
  final int warningsFound;
  final double accessibilityScore;
  final DateTime lastUpdated;

  AccessibilityMetrics({required this.widgetsChecked, required this.issuesFound, required this.warningsFound, required this.accessibilityScore, required this.lastUpdated});
}
