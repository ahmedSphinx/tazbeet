import 'package:flutter/material.dart';
import '../../../../models/mood.dart';
import '../../../../models/mood_streak.dart';
import '../../../../l10n/app_localizations.dart';

/// Ultimate mood buddy with enhanced animations and emotional intelligence
class UltimateMoodBuddy extends StatefulWidget {
  final MoodLevel? currentMood;
  final MoodStreak? streak;
  final bool showMessage;

  const UltimateMoodBuddy({super.key, this.currentMood, this.streak, this.showMessage = true});

  @override
  State<UltimateMoodBuddy> createState() => _UltimateMoodBuddyState();
}

class _UltimateMoodBuddyState extends State<UltimateMoodBuddy> with TickerProviderStateMixin {
  late AnimationController _bounceController;
  late AnimationController _pulseController;
  late AnimationController _rotateController;

  late Animation<double> _bounceAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  void _initializeAnimations() {
    // Bounce animation for entrance
    _bounceController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);
    _bounceAnimation = CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut);

    // Pulse animation for living feel
    _pulseController = AnimationController(duration: const Duration(seconds: 2), vsync: this);
    _pulseAnimation = CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut);

    // Subtle rotation for organic feel
    _rotateController = AnimationController(duration: const Duration(seconds: 8), vsync: this);
    _rotateAnimation = CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut);

    _bounceController.forward();
    _pulseController.repeat(reverse: true);
    _rotateController.repeat(reverse: true);
  }

  void _disposeAnimations() {
    _bounceController.dispose();
    _pulseController.dispose();
    _rotateController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final buddyState = _getBuddyState();

    return Column(
      children: [
        // Buddy character
        AnimatedBuilder(
          animation: Listenable.merge([_bounceAnimation, _pulseAnimation, _rotateAnimation]),
          builder: (context, child) {
            return Transform.rotate(
              angle: _rotateAnimation.value * 0.05 - 0.025,
              child: Transform.scale(
                scale: _bounceAnimation.value * (1 + _pulseAnimation.value * 0.05),
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: buddyState.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: buddyState.colors.first.withOpacity(0.4), blurRadius: 30, offset: const Offset(0, 15)),
                      BoxShadow(color: buddyState.colors.last.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Main emoji
                      Center(child: Text(buddyState.emoji, style: const TextStyle(fontSize: 64))),

                      // Sparkle effects for good moods
                      if (widget.currentMood != null && (widget.currentMood == MoodLevel.good || widget.currentMood == MoodLevel.very_good)) ..._buildSparkles(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),

        if (widget.showMessage) ...[
          const SizedBox(height: 20),

          // Message
          AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: buddyState.colors.first.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: buddyState.colors.first.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Text(
                  buddyState.message,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 6),
                Text(
                  buddyState.tip,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],

        // Streak indicator
        if (widget.streak != null && widget.streak!.currentStreak > 0) ...[const SizedBox(height: 16), _buildStreakIndicator()],
      ],
    );
  }

  List<Widget> _buildSparkles() {
    return List.generate(6, (index) {
      return Positioned(
        top: 20 + (index % 2) * 40,
        left: 20 + (index % 3) * 30,
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: 0.5 + _pulseAnimation.value * 0.5,
              child: Icon(Icons.star, size: 12, color: Colors.yellow.shade600.withOpacity(0.8)),
            );
          },
        ),
      );
    });
  }

  Widget _buildStreakIndicator() {
    final l10n = AppLocalizations.of(context)!;
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + _pulseAnimation.value * 0.1,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.orange.shade400, Colors.red.shade400], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(25),
              boxShadow: [BoxShadow(color: Colors.orange.shade300.withOpacity(0.4), blurRadius: 15, offset: const Offset(0, 5))],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.rotate(
                      angle: _pulseAnimation.value * 0.2,
                      child: const Text('🔥', style: TextStyle(fontSize: 20)),
                    );
                  },
                ),
                const SizedBox(width: 8),
                Text(
                  '${widget.streak!.currentStreak} ${l10n.dayStreak}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _BuddyState _getBuddyState() {
    final l10n = AppLocalizations.of(context)!;

    if (widget.currentMood == null) {
      return _BuddyState(emoji: '👋', message: l10n.hiThere, tip: l10n.howIsYourDay, colors: [Colors.blue.shade300, Colors.blue.shade100]);
    }

    switch (widget.currentMood!) {
      case MoodLevel.very_bad:
        return _BuddyState(emoji: '🤗', message: l10n.imHereForYou, tip: l10n.itsOkayToHaveToughDays, colors: [Colors.purple.shade300, Colors.purple.shade100]);

      case MoodLevel.bad:
        return _BuddyState(emoji: '💙', message: l10n.sendingYouStrength, tip: l10n.everyDayIsANewOpportunity, colors: [Colors.indigo.shade300, Colors.indigo.shade100]);

      case MoodLevel.neutral:
        return _BuddyState(emoji: '😊', message: l10n.findingBalance, tip: l10n.sometimesNeutralIsExactlyWhereWeNeedToBe, colors: [Colors.teal.shade300, Colors.teal.shade100]);

      case MoodLevel.good:
        return _BuddyState(emoji: '🌟', message: l10n.youreDoingGreat, tip: l10n.keepShiningBright, colors: [Colors.green.shade300, Colors.green.shade100]);

      case MoodLevel.very_good:
        return _BuddyState(emoji: '🎉', message: l10n.absolutelyAmazing, tip: l10n.yourJoyIsContagious, colors: [Colors.amber.shade300, Colors.amber.shade100]);
    }
  }
}

class _BuddyState {
  final String emoji;
  final String message;
  final String tip;
  final List<Color> colors;

  _BuddyState({required this.emoji, required this.message, required this.tip, required this.colors});
}
