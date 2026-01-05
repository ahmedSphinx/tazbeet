import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/mood/mood_bloc.dart';
import '../../../blocs/mood/mood_event.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/mood.dart';

/// A quick mood check-in widget for instant mood logging
class QuickMoodWidget extends StatefulWidget {
  final VoidCallback? onMoodAdded;

  const QuickMoodWidget({super.key, this.onMoodAdded});

  @override
  State<QuickMoodWidget> createState() => _QuickMoodWidgetState();
}

class _QuickMoodWidgetState extends State<QuickMoodWidget> with TickerProviderStateMixin {
  late AnimationController _controller;
  MoodLevel? _tappedMood;

  final Map<MoodLevel, String> _moodEmojis = {MoodLevel.very_bad: '😭', MoodLevel.bad: '😔', MoodLevel.neutral: '😐', MoodLevel.good: '🙂', MoodLevel.very_good: '😊'};

  final Map<MoodLevel, Color> _moodColors = {
    MoodLevel.very_bad: const Color(0xFFFF5252),
    MoodLevel.bad: const Color(0xFFFF9800),
    MoodLevel.neutral: const Color(0xFF9E9E9E),
    MoodLevel.good: const Color(0xFF8BC34A),
    MoodLevel.very_good: const Color(0xFF4CAF50),
  };

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onMoodTap(MoodLevel mood) {
    HapticFeedback.mediumImpact();
    setState(() => _tappedMood = mood);

    _controller.forward().then((_) {
      _controller.reverse();

      // Add quick mood
      context.read<MoodBloc>().add(QuickAddMood(mood, null));

      // Show confirmation
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(children: [Text(_moodEmojis[mood]!), const SizedBox(width: 8), Text(AppLocalizations.of(context)!.moodSaved)]),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );

        widget.onMoodAdded?.call();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.favorite, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.quickMoodCheckIn, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.howAreYouFeeling, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: MoodLevel.values.map((mood) {
                return _buildQuickMoodButton(mood);
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickMoodButton(MoodLevel mood) {
    final isTapped = _tappedMood == mood;
    final color = _moodColors[mood]!;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final scale = isTapped ? 1.0 + (_controller.value * 0.3) : 1.0;

        return Transform.scale(
          scale: scale,
          child: GestureDetector(
            onTap: () => _onMoodTap(mood),
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.3), width: 2),
              ),
              child: Center(child: Text(_moodEmojis[mood]!, style: const TextStyle(fontSize: 32))),
            ),
          ),
        );
      },
    );
  }
}
