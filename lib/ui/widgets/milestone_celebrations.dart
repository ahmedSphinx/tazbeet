import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Milestone celebration data
class MilestoneCelebration {
  final String title;
  final String message;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final List<Color> confettiColors;
  final Duration duration;
  final bool showConfetti;
  final bool showFireworks;

  const MilestoneCelebration({required this.title, required this.message, required this.icon, required this.primaryColor, required this.secondaryColor, required this.confettiColors, this.duration = const Duration(seconds: 3), this.showConfetti = true, this.showFireworks = false});
}

/// Enhanced milestone celebration widget with animations and haptics
class MilestoneCelebrationWidget extends StatefulWidget {
  final MilestoneCelebration celebration;
  final VoidCallback? onComplete;
  final VoidCallback? onDismiss;

  const MilestoneCelebrationWidget({super.key, required this.celebration, this.onComplete, this.onDismiss});

  @override
  State<MilestoneCelebrationWidget> createState() => _MilestoneCelebrationWidgetState();
}

class _MilestoneCelebrationWidgetState extends State<MilestoneCelebrationWidget> with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _scaleController;
  late ConfettiController _confettiController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _pulseController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _scaleController = AnimationController(duration: const Duration(milliseconds: 600), vsync: this);

    _confettiController = ConfettiController(duration: widget.celebration.duration);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOut));

    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(CurvedAnimation(parent: _mainController, curve: Curves.elasticOut));

    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(CurvedAnimation(parent: _mainController, curve: Curves.easeOut));

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));

    _startCelebration();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  void _startCelebration() async {
    // Haptic celebration sequence
    await _performHapticCelebration();

    // Start animations
    _mainController.forward();
    _pulseController.repeat(reverse: true);

    if (widget.celebration.showConfetti) {
      _confettiController.play();
    }

    // Auto-dismiss after duration
    Future.delayed(widget.celebration.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  Future<void> _performHapticCelebration() async {
    // Triple impact celebration
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.heavyImpact();
    await Future.delayed(const Duration(milliseconds: 150));
    await HapticFeedback.heavyImpact();

    // Follow-up medium impacts
    await Future.delayed(const Duration(milliseconds: 200));
    await HapticFeedback.mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await HapticFeedback.mediumImpact();
  }

  void _dismiss() {
    _mainController.reverse().then((_) {
      widget.onDismiss?.call();
      if (mounted) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Background overlay
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Container(color: Colors.black.withValues(alpha: 0.7 * _fadeAnimation.value));
            },
          ),

          // Confetti
          if (widget.celebration.showConfetti)
            Positioned.fill(
              child: ConfettiWidget(confettiController: _confettiController, blastDirectionality: BlastDirectionality.explosive, colors: widget.celebration.confettiColors, numberOfParticles: 50, shouldLoop: false),
            ),

          // Main celebration content
          Center(
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Opacity(opacity: _fadeAnimation.value, child: _buildCelebrationCard()),
                  ),
                );
              },
            ),
          ),

          // Dismiss button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: IconButton(
                    onPressed: _dismiss,
                    icon: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.3), shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white, size: 20),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebrationCard() {
    return Container(
      margin: const EdgeInsets.all(32),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [widget.celebration.primaryColor, widget.celebration.secondaryColor], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: widget.celebration.primaryColor.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5, offset: const Offset(0, 10))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Animated icon
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), shape: BoxShape.circle),
                  child: Icon(widget.celebration.icon, size: 50, color: Colors.white),
                ),
              );
            },
          ).animate(delay: 200.ms).shimmer(duration: 1500.ms, color: Colors.white.withValues(alpha: 0.5)).rotate(begin: -0.1, end: 0.1, duration: 2000.ms).then().rotate(begin: 0.1, end: -0.1, duration: 2000.ms),

          const SizedBox(height: 24),

          // Title
          Text(
            widget.celebration.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ).animate(delay: 400.ms).fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),

          const SizedBox(height: 12),

          // Message
          Text(
            widget.celebration.message,
            style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: 0.9), height: 1.4),
            textAlign: TextAlign.center,
          ).animate(delay: 600.ms).fadeIn(duration: 600.ms).slideY(begin: 0.3, end: 0),

          const SizedBox(height: 32),

          // Action button
          ElevatedButton(
            onPressed: () {
              HapticFeedback.mediumImpact();
              widget.onComplete?.call();
              _dismiss();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: widget.celebration.primaryColor,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              elevation: 8,
            ),
            child: const Text('Awesome!', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ).animate(delay: 800.ms).fadeIn(duration: 600.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1)),
        ],
      ),
    );
  }
}

/// Predefined milestone celebrations
class MilestoneCelebrations {
  /// Task completion celebration
  static MilestoneCelebration taskCompleted({required String taskTitle}) {
    return MilestoneCelebration(
      title: 'Task Complete! 🎉',
      message: 'Great job completing "$taskTitle"!\nYou\'re making excellent progress.',
      icon: Icons.celebration,
      primaryColor: Colors.green,
      secondaryColor: Colors.teal,
      confettiColors: [Colors.green, Colors.teal, Colors.blue, Colors.yellow],
      duration: const Duration(seconds: 4),
    );
  }

  /// Subtask milestone (25%, 50%, 75%)
  static MilestoneCelebration subtaskMilestone({required int percentage, required int completedCount, required int totalCount}) {
    String title;
    String message;
    Color primaryColor;
    Color secondaryColor;

    if (percentage >= 75) {
      title = 'Almost Done! 💪';
      message = 'You\'ve completed $completedCount of $totalCount subtasks.\nThe finish line is in sight!';
      primaryColor = Colors.orange;
      secondaryColor = Colors.deepOrange;
    } else if (percentage >= 50) {
      title = 'Halfway There! 🚀';
      message = 'You\'ve completed $completedCount of $totalCount subtasks.\nKeep up the momentum!';
      primaryColor = Colors.blue;
      secondaryColor = Colors.indigo;
    } else {
      title = 'Great Start! ⭐';
      message = 'You\'ve completed $completedCount of $totalCount subtasks.\nYou\'re off to a fantastic start!';
      primaryColor = Colors.purple;
      secondaryColor = Colors.deepPurple;
    }

    return MilestoneCelebration(title: title, message: message, icon: Icons.trending_up, primaryColor: primaryColor, secondaryColor: secondaryColor, confettiColors: [primaryColor, secondaryColor, Colors.white, Colors.yellow], duration: const Duration(seconds: 3));
  }

  /// Pomodoro session milestone
  static MilestoneCelebration pomodoroMilestone({required int sessionCount, required int totalMinutes}) {
    return MilestoneCelebration(
      title: 'Focus Master! 🧠',
      message: 'You\'ve completed $sessionCount focus sessions!\nThat\'s $totalMinutes minutes of deep work.',
      icon: Icons.psychology,
      primaryColor: Colors.purple,
      secondaryColor: Colors.deepPurple,
      confettiColors: [Colors.purple, Colors.pink, Colors.indigo, Colors.white],
      duration: const Duration(seconds: 3),
    );
  }

  /// Streak milestone
  static MilestoneCelebration streakMilestone({required int streakDays}) {
    return MilestoneCelebration(
      title: '$streakDays Day Streak! 🔥',
      message: 'You\'ve been consistently productive for $streakDays days.\nYour dedication is inspiring!',
      icon: Icons.local_fire_department,
      primaryColor: Colors.red,
      secondaryColor: Colors.orange,
      confettiColors: [Colors.red, Colors.orange, Colors.yellow, Colors.white],
      duration: const Duration(seconds: 4),
    );
  }

  /// First task celebration
  static MilestoneCelebration firstTask() {
    return MilestoneCelebration(
      title: 'Welcome Aboard! 🎊',
      message: 'You\'ve completed your first task!\nThis is the beginning of something great.',
      icon: Icons.rocket_launch,
      primaryColor: Colors.blue,
      secondaryColor: Colors.cyan,
      confettiColors: [Colors.blue, Colors.cyan, Colors.white, Colors.yellow],
      duration: const Duration(seconds: 5),
    );
  }

  /// Level up celebration
  static MilestoneCelebration levelUp({required int newLevel, required String achievement}) {
    return MilestoneCelebration(
      title: 'Level $newLevel! 🏆',
      message: 'You\'ve unlocked: $achievement\nYour productivity skills are evolving!',
      icon: Icons.emoji_events,
      primaryColor: Colors.amber,
      secondaryColor: Colors.orange,
      confettiColors: [Colors.amber, Colors.yellow, Colors.orange, Colors.white],
      duration: const Duration(seconds: 4),
      showFireworks: true,
    );
  }
}

/// Helper function to show milestone celebrations
void showMilestoneCelebration(BuildContext context, MilestoneCelebration celebration, {VoidCallback? onComplete}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.transparent,
    builder: (context) => MilestoneCelebrationWidget(celebration: celebration, onComplete: onComplete),
  );
}
