import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/mood.dart';

/// A beautiful, animated emoji selector for mood levels
class EmojiMoodSelector extends StatefulWidget {
  final MoodLevel selectedMood;
  final ValueChanged<MoodLevel> onMoodSelected;
  final bool showLabels;
  final double size;

  const EmojiMoodSelector({super.key, required this.selectedMood, required this.onMoodSelected, this.showLabels = true, this.size = 64});

  @override
  State<EmojiMoodSelector> createState() => _EmojiMoodSelectorState();
}

class _EmojiMoodSelectorState extends State<EmojiMoodSelector> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  MoodLevel? _tappedMood;

  final Map<MoodLevel, String> _moodEmojis = {MoodLevel.very_bad: '😭', MoodLevel.bad: '😔', MoodLevel.neutral: '😐', MoodLevel.good: '🙂', MoodLevel.very_good: '😊'};

  final Map<MoodLevel, String> _moodLabels = {MoodLevel.very_bad: 'Very Bad', MoodLevel.bad: 'Bad', MoodLevel.neutral: 'Okay', MoodLevel.good: 'Good', MoodLevel.very_good: 'Great'};

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
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
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
      widget.onMoodSelected(mood);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceEvenly,
      spacing: 8,
      runSpacing: 16,
      children: MoodLevel.values.map((mood) {
        final isSelected = widget.selectedMood == mood;
        final isTapped = _tappedMood == mood;

        return _buildMoodButton(mood: mood, isSelected: isSelected, isTapped: isTapped);
      }).toList(),
    );
  }

  Widget _buildMoodButton({required MoodLevel mood, required bool isSelected, required bool isTapped}) {
    final color = _moodColors[mood]!;

    return GestureDetector(
      onTap: () => _onMoodTap(mood),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          final scale = isTapped ? _scaleAnimation.value : 1.0;

          return Transform.scale(
            scale: scale,
            child: Container(
              width: widget.size + 24,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: isSelected ? LinearGradient(colors: [color.withOpacity(0.2), color.withOpacity(0.1)], begin: Alignment.topLeft, end: Alignment.bottomRight) : null,
                border: Border.all(color: isSelected ? color : Colors.grey.shade300, width: isSelected ? 3 : 1.5),
                borderRadius: BorderRadius.circular(20),
                boxShadow: isSelected ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))] : null,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_moodEmojis[mood]!, style: TextStyle(fontSize: widget.size)),
                  if (widget.showLabels) ...[
                    const SizedBox(height: 8),
                    Text(
                      _moodLabels[mood]!,
                      style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, color: isSelected ? color : Colors.grey.shade700),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
