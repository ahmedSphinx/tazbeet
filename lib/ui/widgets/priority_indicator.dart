import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../themes/design_system.dart';

class PriorityIndicator extends StatelessWidget {
  final TaskPriority priority;

  const PriorityIndicator({super.key, required this.priority});

  Color get _color {
    switch (priority) {
      case TaskPriority.high:
        return AppColors.priorityHigh;
      case TaskPriority.medium:
        return AppColors.priorityMedium;
      case TaskPriority.low:
        return AppColors.priorityLow;
    }
  }

  IconData get _icon {
    switch (priority) {
      case TaskPriority.high:
        return Icons.priority_high;
      case TaskPriority.medium:
        return Icons.label_important;
      case TaskPriority.low:
        return Icons.low_priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_icon, color: _color, size: AppSizes.iconSmall),
        const SizedBox(width: AppSpacing.xs),
        Text(
          priority.name.toUpperCase(),
          style: context.labelSmall.copyWith(
            color: _color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
