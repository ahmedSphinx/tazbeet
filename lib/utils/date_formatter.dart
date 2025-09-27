import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

class DateFormatter {
  static final DateFormat _dateFormat = DateFormat('MMM dd, yyyy');
  static final DateFormat _timeFormat = DateFormat('HH:mm');
  static final DateFormat _dateTimeFormat = DateFormat('MMM dd, yyyy HH:mm');

  /// Formats a date to a user-friendly string
  static String formatDate(DateTime date, BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final yesterday = today.subtract(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) {
      return AppLocalizations.of(context)!.today;
    } else if (dateOnly == tomorrow) {
      return AppLocalizations.of(context)!.tomorrow;
    } else if (dateOnly == yesterday) {
      return AppLocalizations.of(context)!.yesterday;
    } else {
      return _dateFormat.format(date);
    }
  }

  /// Formats a date and time to a user-friendly string
  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (dateOnly == today) {
      return 'Today ${_timeFormat.format(dateTime)}';
    } else {
      return _dateTimeFormat.format(dateTime);
    }
  }

  /// Gets a relative time string (e.g., "2 days ago", "in 3 hours")
  static String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);

    if (difference.isNegative) {
      final absDifference = difference.abs();

      if (absDifference.inDays > 0) {
        return '${absDifference.inDays} day${absDifference.inDays == 1 ? '' : 's'} ago';
      } else if (absDifference.inHours > 0) {
        return '${absDifference.inHours} hour${absDifference.inHours == 1 ? '' : 's'} ago';
      } else if (absDifference.inMinutes > 0) {
        return '${absDifference.inMinutes} minute${absDifference.inMinutes == 1 ? '' : 's'} ago';
      } else {
        return 'Just now';
      }
    } else {
      if (difference.inDays > 0) {
        return 'In ${difference.inDays} day${difference.inDays == 1 ? '' : 's'}';
      } else if (difference.inHours > 0) {
        return 'In ${difference.inHours} hour${difference.inHours == 1 ? '' : 's'}';
      } else if (difference.inMinutes > 0) {
        return 'In ${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'}';
      } else {
        return 'Now';
      }
    }
  }

  /// Checks if a date is overdue
  static bool isOverdue(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly.isBefore(today);
  }

  /// Checks if a date is due today
  static bool isDueToday(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly == today;
  }

  /// Checks if a date is due tomorrow
  static bool isDueTomorrow(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly == tomorrow;
  }

  /// Gets the number of days until a date
  static int daysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateOnly = DateTime(date.year, date.month, date.day);
    return dateOnly.difference(today).inDays;
  }

  /// Formats a time to a user-friendly string
  static String formatTime(DateTime dateTime) {
    return _timeFormat.format(dateTime);
  }
}
