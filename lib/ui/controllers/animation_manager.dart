import 'package:flutter/material.dart';

/// Manages animation controllers for MainScreen
class AnimationManager {
  late AnimationController _categorySearchAnimationController;
  late AnimationController _categoryFabAnimationController;
  late Animation<double> _categorySearchFadeAnimation;
  late Animation<double> _categoryFabScaleAnimation;

  Animation<double> get categorySearchFadeAnimation => _categorySearchFadeAnimation;
  Animation<double> get categoryFabScaleAnimation => _categoryFabScaleAnimation;

  void initialize(TickerProvider vsync) {
    _categorySearchAnimationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: vsync);

    _categoryFabAnimationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: vsync);

    _categorySearchFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _categorySearchAnimationController, curve: Curves.easeInOut));

    _categoryFabScaleAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _categoryFabAnimationController, curve: Curves.easeInOut));
  }

  void forwardCategorySearch() {
    _categorySearchAnimationController.forward();
    _categoryFabAnimationController.forward();
  }

  void reverseCategorySearch() {
    _categorySearchAnimationController.reverse();
    _categoryFabAnimationController.reverse();
  }

  void dispose() {
    _categorySearchAnimationController.dispose();
    _categoryFabAnimationController.dispose();
  }
}
