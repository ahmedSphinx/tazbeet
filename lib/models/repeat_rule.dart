import 'package:equatable/equatable.dart';

enum RepeatFrequency {
  weekly,
  biweekly,
  monthly,
}

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

  const RepeatRule({
    required this.frequency,
    this.repeatType = RepeatType.forever,
    this.daysOfWeek = const [],
    this.endDate,
    this.repeatCount,
    required this.startDate,
    this.includeTime = false,
  });

  RepeatRule copyWith({
    RepeatFrequency? frequency,
    RepeatType? repeatType,
    List<int>? daysOfWeek,
    DateTime? endDate,
    int? repeatCount,
    DateTime? startDate,
    bool? includeTime,
  }) {
    return RepeatRule(
      frequency: frequency ?? this.frequency,
      repeatType: repeatType ?? this.repeatType,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      endDate: endDate ?? this.endDate,
      repeatCount: repeatCount ?? this.repeatCount,
      startDate: startDate ?? this.startDate,
      includeTime: includeTime ?? this.includeTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'frequency': frequency.index,
      'repeatType': repeatType.index,
      'daysOfWeek': daysOfWeek,
      'endDate': endDate?.toIso8601String(),
      'repeatCount': repeatCount,
      'startDate': startDate.toIso8601String(),
      'includeTime': includeTime,
    };
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

  DateTime? getNextOccurrence(DateTime fromDate) {
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
        nextDate = DateTime(
          nextDate.year,
          nextDate.month + 1,
          nextDate.day,
        );
        break;
    }

    // Check if next occurrence is within limits
    if (repeatType == RepeatType.untilDate && nextDate.isAfter(endDate!)) {
      return null;
    }

    return nextDate.isAfter(now) ? nextDate : null;
  }

  String getDisplayText() {
    String text = '';

    switch (frequency) {
      case RepeatFrequency.weekly:
        text = 'Weekly';
        if (daysOfWeek.isNotEmpty) {
          final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
          final selectedDays = daysOfWeek.map((i) => dayNames[i]).join(', ');
          text += ' on $selectedDays';
        }
        break;
      case RepeatFrequency.biweekly:
        text = 'Bi-weekly';
        break;
      case RepeatFrequency.monthly:
        text = 'Monthly';
        break;
    }

    switch (repeatType) {
      case RepeatType.forever:
        text += ' (forever)';
        break;
      case RepeatType.untilDate:
        text += ' until ${endDate!.toString().split(' ')[0]}';
        break;
      case RepeatType.count:
        text += ' ($repeatCount times)';
        break;
    }

    return text;
  }

  @override
  List<Object?> get props => [
        frequency,
        repeatType,
        daysOfWeek,
        endDate,
        repeatCount,
        startDate,
        includeTime,
      ];
}
