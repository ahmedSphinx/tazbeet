import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A slider with emoji endpoints instead of numbers
class EmojiSlider extends StatelessWidget {
  final String title;
  final double value;
  final ValueChanged<double> onChanged;
  final String lowEmoji;
  final String highEmoji;
  final String lowLabel;
  final String highLabel;
  final Color? activeColor;

  const EmojiSlider({super.key, required this.title, required this.value, required this.onChanged, required this.lowEmoji, required this.highEmoji, required this.lowLabel, required this.highLabel, this.activeColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = activeColor ?? theme.colorScheme.primary;

    // Convert 1-10 scale to descriptive text
    String getValueLabel() {
      if (value <= 3) return lowLabel;
      if (value <= 4) return 'Somewhat $lowLabel';
      if (value <= 6) return 'Balanced';
      if (value <= 7) return 'Somewhat $highLabel';
      return highLabel;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title and current value
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
              child: Text(
                getValueLabel(),
                style: theme.textTheme.bodyMedium?.copyWith(color: color, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Slider with emoji endpoints
        Row(
          children: [
            // Low emoji
            Text(lowEmoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 8),

            // Slider
            Expanded(
              child: SliderTheme(
                data: SliderThemeData(
                  activeTrackColor: color,
                  inactiveTrackColor: color.withValues(alpha: 0.2),
                  thumbColor: color,
                  overlayColor: color.withValues(alpha: 0.2),
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
                  trackHeight: 6,
                ),
                child: Slider(
                  value: value,
                  min: 1,
                  max: 10,
                  divisions: 9,
                  onChanged: (newValue) {
                    HapticFeedback.selectionClick();
                    onChanged(newValue);
                  },
                ),
              ),
            ),

            const SizedBox(width: 8),
            // High emoji
            Text(highEmoji, style: const TextStyle(fontSize: 28)),
          ],
        ),

        // Labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(lowLabel, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
              Text(highLabel, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

/// Predefined emoji sliders for common mood metrics
class EmojiSliders {
  static Widget energy({required double value, required ValueChanged<double> onChanged}) {
    return EmojiSlider(title: 'Energy', value: value, onChanged: onChanged, lowEmoji: '😴', highEmoji: '⚡', lowLabel: 'Drained', highLabel: 'Energized', activeColor: const Color(0xFFFFB74D));
  }

  static Widget focus({required double value, required ValueChanged<double> onChanged}) {
    return EmojiSlider(title: 'Focus', value: value, onChanged: onChanged, lowEmoji: '🌀', highEmoji: '🎯', lowLabel: 'Scattered', highLabel: 'Locked In', activeColor: const Color(0xFF64B5F6));
  }

  static Widget stress({required double value, required ValueChanged<double> onChanged}) {
    return EmojiSlider(title: 'Stress', value: value, onChanged: onChanged, lowEmoji: '😌', highEmoji: '😰', lowLabel: 'Chill', highLabel: 'Overwhelmed', activeColor: const Color(0xFFE57373));
  }
}
