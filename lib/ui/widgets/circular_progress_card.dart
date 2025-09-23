import 'package:flutter/material.dart';

class CircularProgressCard extends StatelessWidget {
  final String title;
  final double progress;
  final String centerText;
  final Color color;

  const CircularProgressCard({
    super.key,
    required this.title,
    required this.progress,
    required this.centerText,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 80,
            height: 80,
            child: Stack(
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  backgroundColor: color.withValues(alpha: 0.2),
                ),
                Center(
                  child: Text(
                    centerText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
