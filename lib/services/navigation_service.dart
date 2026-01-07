import 'package:flutter/material.dart';

class NavigationService {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Future<dynamic> navigateTo(String routeName, {Object? arguments}) {
    final navigatorState = navigatorKey.currentState;
    if (navigatorState == null) {
      throw Exception('Navigator not initialized');
    }
    return navigatorState.pushNamed(routeName, arguments: arguments);
  }

  static Future<dynamic> navigateToReplacement(String routeName, {Object? arguments}) {
    final navigatorState = navigatorKey.currentState;
    if (navigatorState == null) {
      throw Exception('Navigator not initialized');
    }
    return navigatorState.pushReplacementNamed(routeName, arguments: arguments);
  }

  static void goBack() {
    final navigatorState = navigatorKey.currentState;
    if (navigatorState == null) {
      throw Exception('Navigator not initialized');
    }
    navigatorState.pop();
  }

  static bool canPop() {
    final navigatorState = navigatorKey.currentState;
    if (navigatorState == null) {
      return false;
    }
    return navigatorState.canPop();
  }

  // Safe method that waits for navigator to be ready
  static Future<void> safeNavigateToReplacement(String routeName, {Object? arguments}) async {
    int attempts = 0;
    const maxAttempts = 10;

    while (attempts < maxAttempts) {
      final navigatorState = navigatorKey.currentState;
      if (navigatorState != null) {
        try {
          await navigatorState.pushReplacementNamed(routeName, arguments: arguments);
          return;
        } catch (e) {
          // Navigator might not be ready yet
          attempts++;
          await Future.delayed(const Duration(milliseconds: 50));
        }
      } else {
        attempts++;
        await Future.delayed(const Duration(milliseconds: 50));
      }
    }
    throw Exception('Failed to navigate after $maxAttempts attempts');
  }
}
