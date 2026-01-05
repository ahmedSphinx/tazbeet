import 'package:flutter/material.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/mood.dart';
import '../../../models/mood_streak.dart';

/// A friendly mood buddy character that reflects user's mood
class MoodBuddyWidget extends StatelessWidget {
  final MoodLevel? currentMood;
  final MoodStreak? streak;
  final bool showMessage;

  const MoodBuddyWidget({super.key, this.currentMood, this.streak, this.showMessage = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final buddyState = _getBuddyState(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Buddy character
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: buddyState.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: buddyState.colors.first.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: Center(child: Text(buddyState.emoji, style: const TextStyle(fontSize: 64))),
            ),

            if (showMessage) ...[
              const SizedBox(height: 16),
              Text(
                buddyState.message,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                buddyState.tip,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ],

            // Streak indicator
            if (streak != null && streak!.currentStreak > 0) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: Colors.orange.shade100, borderRadius: BorderRadius.circular(20)),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🔥', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      '${streak!.currentStreak} ${AppLocalizations.of(context)!.daysStreak}',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  _BuddyState _getBuddyState(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    if (currentMood == null) {
      return _BuddyState(emoji: '👋', message: l10n.hiThere, tip: l10n.howIsYourDay, colors: [Colors.blue.shade300, Colors.blue.shade100]);
    }

    switch (currentMood!) {
      case MoodLevel.very_bad:
        return _BuddyState(emoji: '🤗', message: l10n.moodBuddyFeelingSad, tip: l10n.moodBuddyTipSad, colors: [Colors.purple.shade300, Colors.purple.shade100]);

      case MoodLevel.bad:
        return _BuddyState(emoji: '💙', message: l10n.moodBuddyFeelingDown, tip: l10n.moodBuddyTipDown, colors: [Colors.indigo.shade300, Colors.indigo.shade100]);

      case MoodLevel.neutral:
        return _BuddyState(emoji: '😊', message: l10n.moodBuddyFeelingOkay, tip: l10n.moodBuddyTipOkay, colors: [Colors.teal.shade300, Colors.teal.shade100]);

      case MoodLevel.good:
        return _BuddyState(emoji: '🌟', message: l10n.moodBuddyFeelingGood, tip: l10n.moodBuddyTipGood, colors: [Colors.green.shade300, Colors.green.shade100]);

      case MoodLevel.very_good:
        return _BuddyState(emoji: '🎉', message: l10n.moodBuddyFeelingGreat, tip: l10n.moodBuddyTipGreat, colors: [Colors.amber.shade300, Colors.amber.shade100]);
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
