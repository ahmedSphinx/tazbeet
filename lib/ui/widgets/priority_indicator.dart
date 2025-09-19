import 'package:flutter/material.dart';
import '../../models/task.dart';

class PriorityIndicator extends StatelessWidget {
  final TaskPriority priority;

  const PriorityIndicator({super.key, required this.priority});

  Color get _color {
    switch (priority) {
      case TaskPriority.high:
        return Colors.redAccent;
      case TaskPriority.medium:
        return Colors.orangeAccent;
      case TaskPriority.low:
      default:
        return Colors.greenAccent;
    }
  }

  IconData get _icon {
    switch (priority) {
      case TaskPriority.high:
        return Icons.priority_high;
      case TaskPriority.medium:
        return Icons.label_important;
      case TaskPriority.low:
      default:
        return Icons.low_priority;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(_icon, color: _color, size: 16),
        const SizedBox(width: 4),
        Text(
          priority.name.toUpperCase(),
          style: TextStyle(
            color: _color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
