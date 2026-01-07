import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app_logging_service.dart';

/// Onboarding service to manage first-time user experience
class OnboardingService {
  static const String _onboardingCompletedKey = 'onboarding_completed';
  static const String _tutorialCompletedKey = 'tutorial_completed';
  static const String _accessibilitySetupKey = 'accessibility_setup_completed';
  static const String _smartFeaturesShownKey = 'smart_features_shown';

  static final OnboardingService _instance = OnboardingService._internal();
  factory OnboardingService() => _instance;
  OnboardingService._internal();

  /// Check if user has completed onboarding
  Future<bool> get hasCompletedOnboarding async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_onboardingCompletedKey) ?? false;
    } catch (e) {
      AppLogging.logError('Failed to check onboarding status: $e');
      return false;
    }
  }

  /// Check if user has completed tutorial
  Future<bool> get hasCompletedTutorial async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_tutorialCompletedKey) ?? false;
    } catch (e) {
      AppLogging.logError('Failed to check tutorial status: $e');
      return false;
    }
  }

  /// Check if accessibility setup is completed
  Future<bool> get hasCompletedAccessibilitySetup async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_accessibilitySetupKey) ?? false;
    } catch (e) {
      AppLogging.logError('Failed to check accessibility setup status: $e');
      return false;
    }
  }

  /// Mark onboarding as completed
  Future<void> completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_onboardingCompletedKey, true);
      AppLogging.logInfo('Onboarding marked as completed');
    } catch (e) {
      AppLogging.logError('Failed to complete onboarding: $e');
    }
  }

  /// Mark tutorial as completed
  Future<void> completeTutorial() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_tutorialCompletedKey, true);
      AppLogging.logInfo('Tutorial marked as completed');
    } catch (e) {
      AppLogging.logError('Failed to complete tutorial: $e');
    }
  }

  /// Mark accessibility setup as completed
  Future<void> completeAccessibilitySetup() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_accessibilitySetupKey, true);
      AppLogging.logInfo('Accessibility setup marked as completed');
    } catch (e) {
      AppLogging.logError('Failed to complete accessibility setup: $e');
    }
  }

  /// Mark smart features as shown
  Future<void> markSmartFeaturesShown() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_smartFeaturesShownKey, true);
      AppLogging.logInfo('Smart features marked as shown');
    } catch (e) {
      AppLogging.logError('Failed to mark smart features as shown: $e');
    }
  }

  /// Check if smart features have been shown
  Future<bool> get hasShownSmartFeatures async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_smartFeaturesShownKey) ?? false;
    } catch (e) {
      AppLogging.logError('Failed to check smart features status: $e');
      return false;
    }
  }

  /// Reset onboarding (for testing or user preference)
  Future<void> resetOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_onboardingCompletedKey);
      await prefs.remove(_tutorialCompletedKey);
      await prefs.remove(_accessibilitySetupKey);
      await prefs.remove(_smartFeaturesShownKey);
      AppLogging.logInfo('Onboarding reset');
    } catch (e) {
      AppLogging.logError('Failed to reset onboarding: $e');
    }
  }

  /// Get onboarding progress
  Future<Map<String, bool>> getOnboardingProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return {
        'onboarding_completed': prefs.getBool(_onboardingCompletedKey) ?? false,
        'tutorial_completed': prefs.getBool(_tutorialCompletedKey) ?? false,
        'accessibility_setup_completed': prefs.getBool(_accessibilitySetupKey) ?? false,
        'smart_features_shown': prefs.getBool(_smartFeaturesShownKey) ?? false,
      };
    } catch (e) {
      AppLogging.logError('Failed to get onboarding progress: $e');
      return {'onboarding_completed': false, 'tutorial_completed': false, 'accessibility_setup_completed': false, 'smart_features_shown': false};
    }
  }
}

/// Onboarding step data class
class OnboardingStep {
  final String title;
  final String description;
  final String imagePath;
  final List<String> highlights;
  final Widget? customContent;
  final bool isRequired;

  OnboardingStep({required this.title, required this.description, required this.imagePath, required this.highlights, this.customContent, this.isRequired = true});
}

/// Predefined onboarding steps
class OnboardingSteps {
  static List<OnboardingStep> get steps => [
    OnboardingStep(
      title: 'Welcome to Tazbeet',
      description: 'Your intelligent task management companion with AI-powered features',
      imagePath: 'assets/images/welcome.png',
      highlights: ['Smart task sorting with AI recommendations', 'Adaptive Pomodoro timing', 'Mood and energy tracking', 'Productivity analytics'],
    ),
    OnboardingStep(
      title: 'Smart Task Sorting',
      description: 'Experience AI-powered task prioritization that adapts to your patterns',
      imagePath: 'assets/images/smart_sort.png',
      highlights: ['Tasks sorted by priority and suitability', 'Time-based recommendations', 'Energy-aware scheduling', 'Visual indicators for AI suggestions'],
    ),
    OnboardingStep(
      title: 'Pomodoro Integration',
      description: 'Focus better with adaptive timing and smart breaks',
      imagePath: 'assets/images/pomodoro.png',
      highlights: ['25-minute focus sessions', 'Adaptive break suggestions', 'Energy level tracking', 'Productivity insights'],
    ),
    OnboardingStep(
      title: 'Mood & Energy Tracking',
      description: 'Understand your patterns and optimize your productivity',
      imagePath: 'assets/images/mood.png',
      highlights: ['Daily mood check-ins', 'Energy level monitoring', 'Achievement system', 'Wellness insights'],
    ),
    OnboardingStep(
      title: 'Accessibility Features',
      description: 'Customize the app to work best for you',
      imagePath: 'assets/images/accessibility.png',
      highlights: ['High contrast mode', 'Large text options', 'Reduced motion settings', 'Voice commands support'],
    ),
  ];
}
