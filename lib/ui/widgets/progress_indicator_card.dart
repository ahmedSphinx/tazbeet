import 'package:flutter/material.dart';
import '../themes/design_system.dart';

class ProgressIndicatorCard extends StatelessWidget {
  final String title;
  final double progress;
  final int currentValue;
  final int targetValue;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const ProgressIndicatorCard({super.key, required this.title, required this.progress, required this.currentValue, required this.targetValue, required this.icon, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: AppCardStyles.standard(context).copyWith(border: Border.all(color: indicatorColor.withValues(alpha: 0.2), width: 1)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(color: indicatorColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.sm)),
                  child: Icon(icon, color: indicatorColor, size: AppSizes.iconMedium),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.titleSmall.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: AppSpacing.xs),
                      Text('$currentValue / $targetValue', style: context.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            CustomLinearProgressIndicator(progress: progress.clamp(0.0, 1.0), color: indicatorColor),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${(progress * 100).toInt()}%',
              style: context.bodySmall.copyWith(color: indicatorColor, fontWeight: FontWeight.w600),
              textAlign: TextAlign.end,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomLinearProgressIndicator extends StatelessWidget {
  final double progress;
  final Color color;
  final double height;

  const CustomLinearProgressIndicator({super.key, required this.progress, required this.color, this.height = 8.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(height / 2)),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(height / 2)),
        ),
      ),
    );
  }
}

class CircularProgressCard extends StatelessWidget {
  final String title;
  final double progress;
  final String centerText;
  final Color? color;
  final VoidCallback? onTap;

  const CircularProgressCard({super.key, required this.title, required this.progress, required this.centerText, this.color, this.onTap});

  @override
  Widget build(BuildContext context) {
    final indicatorColor = color ?? Theme.of(context).colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: AppCardStyles.elevated(context).copyWith(border: Border.all(color: indicatorColor.withValues(alpha: 0.2), width: 1)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomCircularProgressIndicator(progress: progress.clamp(0.0, 1.0), color: indicatorColor, centerText: centerText),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              style: context.titleSmall.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class CustomCircularProgressIndicator extends StatelessWidget {
  final double progress;
  final Color color;
  final String centerText;
  final double radius;

  const CustomCircularProgressIndicator({super.key, required this.progress, required this.color, required this.centerText, this.radius = 50.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: radius * 2,
      height: radius * 2,
      child: Stack(
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(value: progress, strokeWidth: AppSpacing.sm, backgroundColor: color.withValues(alpha: 0.1), valueColor: AlwaysStoppedAnimation<Color>(color)),
          ),
          Center(
            child: Text(
              centerText,
              style: context.titleLarge.copyWith(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
