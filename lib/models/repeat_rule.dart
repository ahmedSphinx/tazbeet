import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

enum RepeatFrequency { weekly, biweekly, monthly }

enum RepeatType {
  forever, // Repeat indefinitely
  untilDate, // Repeat until specific date
  count, // Repeat specific number of times
}

class RepeatRule extends Equatable {
  final RepeatFrequency frequency;
  final RepeatType repeatType;
  final List<int> daysOfWeek; // 0-6, where 0 is Sunday
  final DateTime? endDate; // For untilDate type
  final int? repeatCount; // For count type
  final DateTime startDate;
  final bool includeTime; // Whether to repeat at specific time

  const RepeatRule({required this.frequency, this.repeatType = RepeatType.forever, this.daysOfWeek = const [], this.endDate, this.repeatCount, required this.startDate, this.includeTime = false});

  RepeatRule copyWith({RepeatFrequency? frequency, RepeatType? repeatType, List<int>? daysOfWeek, DateTime? endDate, int? repeatCount, DateTime? startDate, bool? includeTime}) {
    return RepeatRule(frequency: frequency ?? this.frequency, repeatType: repeatType ?? this.repeatType, daysOfWeek: daysOfWeek ?? this.daysOfWeek, endDate: endDate ?? this.endDate, repeatCount: repeatCount ?? this.repeatCount, startDate: startDate ?? this.startDate, includeTime: includeTime ?? this.includeTime);
  }

  Map<String, dynamic> toJson() {
    return {'frequency': frequency.index, 'repeatType': repeatType.index, 'daysOfWeek': daysOfWeek, 'endDate': endDate?.toIso8601String(), 'repeatCount': repeatCount, 'startDate': startDate.toIso8601String(), 'includeTime': includeTime};
  }

  factory RepeatRule.fromJson(Map<String, dynamic> json) {
    return RepeatRule(
      frequency: RepeatFrequency.values[json['frequency']],
      repeatType: RepeatType.values[json['repeatType']],
      daysOfWeek: List<int>.from(json['daysOfWeek'] ?? []),
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      repeatCount: json['repeatCount'],
      startDate: DateTime.parse(json['startDate']),
      includeTime: json['includeTime'] ?? false,
    );
  }

  bool get isActive {
    final now = DateTime.now();
    switch (repeatType) {
      case RepeatType.forever:
        return true;
      case RepeatType.untilDate:
        return endDate != null && now.isBefore(endDate!);
      case RepeatType.count:
        return repeatCount != null && repeatCount! > 0;
    }
  }

  DateTime? getNextOccurrence(DateTime fromDate, [int depth = 0]) {
    // Prevent infinite recursion
    if (depth > 100) return null;

    if (!isActive) return null;

    final now = DateTime.now();
    DateTime nextDate = fromDate;

    switch (frequency) {
      case RepeatFrequency.weekly:
        if (daysOfWeek.isEmpty) {
          // Repeat every week on the same day
          nextDate = nextDate.add(const Duration(days: 7));
        } else {
          // Find next occurrence of specified days
          int daysToAdd = 1;
          while (daysToAdd <= 7) {
            final checkDate = nextDate.add(Duration(days: daysToAdd));
            if (daysOfWeek.contains(checkDate.weekday % 7)) {
              nextDate = checkDate;
              break;
            }
            daysToAdd++;
          }
          if (daysToAdd > 7) {
            // No valid day found in current week, go to next week
            nextDate = nextDate.add(const Duration(days: 7));
          }
        }
        break;

      case RepeatFrequency.biweekly:
        nextDate = nextDate.add(const Duration(days: 14));
        break;

      case RepeatFrequency.monthly:
        // Handle month overflow safely (e.g., Jan 31 -> Feb 28)
        int nextMonth = nextDate.month + 1;
        int nextYear = nextDate.year;
        if (nextMonth > 12) {
          nextMonth = 1;
          nextYear++;
        }
        // Find the last valid day of the target month
        int targetDay = nextDate.day;
        int lastDayOfMonth = DateTime(nextYear, nextMonth + 1, 0).day;
        if (targetDay > lastDayOfMonth) {
          targetDay = lastDayOfMonth;
        }
        nextDate = DateTime(nextYear, nextMonth, targetDay);
        break;
    }

    // Check if next occurrence is within limits
    if (repeatType == RepeatType.untilDate && nextDate.isAfter(endDate!)) {
      return null;
    }

    // Return nextDate if it's in the future, otherwise calculate the next valid occurrence
    if (!nextDate.isAfter(now)) {
      // If the calculated date is not in the future, calculate the next one
      return getNextOccurrence(nextDate, depth + 1);
    }

    return nextDate;
  }

  String getDisplayText([BuildContext? context]) {
    final l10n = context != null ? AppLocalizations.of(context)! : null;
    String text = '';

    switch (frequency) {
      case RepeatFrequency.weekly:
        text = l10n?.weekly ?? 'Weekly';
        if (daysOfWeek.isNotEmpty) {
          final dayNames = [l10n?.sunday ?? 'Sun', l10n?.monday ?? 'Mon', l10n?.tuesday ?? 'Tue', l10n?.wednesday ?? 'Wed', l10n?.thursday ?? 'Thu', l10n?.friday ?? 'Fri', l10n?.saturday ?? 'Sat'];
          final selectedDays = daysOfWeek.map((i) => dayNames[i]).join(', ');
          text += ' ${l10n?.onDays ?? 'on'} $selectedDays';
        }
        break;
      case RepeatFrequency.biweekly:
        text = l10n?.biweekly ?? 'Bi-weekly';
        break;
      case RepeatFrequency.monthly:
        text = l10n?.monthly ?? 'Monthly';
        break;
    }

    switch (repeatType) {
      case RepeatType.forever:
        text += ' ${l10n?.repeatForever ?? '(forever)'}';
        break;
      case RepeatType.untilDate:
        text += ' ${l10n?.repeatUntil ?? 'until'} ${endDate!.toString().split(' ')[0]}';
        break;
      case RepeatType.count:
        text += ' ${l10n?.repeatCount ?? '($repeatCount times)'}';
        break;
    }

    return text;
  }

  @override
  List<Object?> get props => [frequency, repeatType, daysOfWeek, endDate, repeatCount, startDate, includeTime];
}
