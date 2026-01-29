import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import '../../models/task.dart';

class SmartReminderIndicator extends StatelessWidget {
  final Task task;
  final AppLocalizations l10n;

  const SmartReminderIndicator({super.key, required this.task, required this.l10n});

  @override
  Widget build(BuildContext context) {
    if (task.reminderDate == null) {
      return const SizedBox.shrink();
    }

    // Check if this is a smart default reminder
    final defaultReminder = task.defaultReminderDate;
    final isSmartReminder = defaultReminder != null && _isSameDay(task.reminderDate!, defaultReminder);

    if (!isSmartReminder) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.auto_awesome, size: 14, color: Colors.blue),
          const SizedBox(width: 6),
          Text(
            'Smart Reminder',
            style: TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}
