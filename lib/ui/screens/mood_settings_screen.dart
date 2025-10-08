import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tazbeet/services/settings_service.dart' as settings;
import 'package:tazbeet/l10n/app_localizations.dart';

import '../../services/notification_service.dart';

class MoodSettingsScreen extends StatefulWidget {
  const MoodSettingsScreen({Key? key}) : super(key: key);

  @override
  State<MoodSettingsScreen> createState() => _MoodSettingsScreenState();
}

class _MoodSettingsScreenState extends State<MoodSettingsScreen> {
  late bool _enableMoodNotifications;
  late List<TimeOfDay> _checkInTimes;

  @override
  void initState() {
    super.initState();
    final settingsService = context.read<settings.SettingsService>();
    _enableMoodNotifications = settingsService.settings.enableMoodNotifications;
    _checkInTimes = settingsService.settings.moodCheckInTimes.map((timeStr) {
      final parts = timeStr.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }).toList();
  }

  Future<void> _addCheckInTime() async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(DateTime.now().add(Duration(minutes: 1))));
    if (picked != null) {
      setState(() {
        _checkInTimes.add(picked);
        _checkInTimes.sort((a, b) => a.hour.compareTo(b.hour) != 0 ? a.hour.compareTo(b.hour) : a.minute.compareTo(b.minute));
      });
      _saveSettings();
    }
  }

  Future<void> _addSuggestedTimes() async {
    try {
      final settingsService = context.read<settings.SettingsService>();
      final suggestedTimes = await settingsService.getSuggestedMoodCheckInTimes();

      if (suggestedTimes.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('No mood history available for suggestions')));
        }
        return;
      }

      // Convert suggested strings to TimeOfDay
      final suggestedTimeOfDays = suggestedTimes.map((timeStr) {
        final parts = timeStr.split(':');
        return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }).toList();

      // Add new times that aren't already in the list
      int addedCount = 0;
      for (final time in suggestedTimeOfDays) {
        if (!_checkInTimes.any((existing) => existing.hour == time.hour && existing.minute == time.minute)) {
          _checkInTimes.add(time);
          addedCount++;
        }
      }

      if (addedCount > 0) {
        setState(() {
          _checkInTimes.sort((a, b) => a.hour.compareTo(b.hour) != 0 ? a.hour.compareTo(b.hour) : a.minute.compareTo(b.minute));
        });
        _saveSettings();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Added $addedCount suggested check-in times from your mood history')));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All suggested times are already in your list')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to get suggestions: $e')));
      }
    }
  }

  void _removeCheckInTime(int index) {
    setState(() {
      _checkInTimes.removeAt(index);
    });
    _saveSettings();
  }

  void _testMoodNotification() async {
    try {
      final l10n = AppLocalizations.of(context)!;
      final notificationService = NotificationService();
      await notificationService.showTestMoodNotificationNow(l10n: l10n);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test mood notification sent!')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to send test notification: $e')));
      }
    }
  }

  void _checkPendingNotifications() async {
    try {
      final notificationService = NotificationService();
      final pending = await notificationService.getPendingNotifications();
      final moodNotifications = pending.where((n) => n.id >= 100000 && n.id < 100010).toList();

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Pending Mood Notifications'),
            content: Column(
              children: [
                Text('${moodNotifications.length} mood notifications scheduled\nTotal pending: ${pending.length}'),
                for (var notification in moodNotifications) Text(notification.title.toString() + ' at ' + (notification.body?.toString() ?? '')),
              ],
            ),
            actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK'))],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to check pending notifications: $e')));
      }
    }
  }

  void _saveSettings() {
    final l10n = AppLocalizations.of(context)!;
    final settingsService = context.read<settings.SettingsService>();
    final timesAsString = _checkInTimes.map((t) => '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}').toList();
    settingsService.setMoodNotificationsEnabled(_enableMoodNotifications);
    settingsService.setMoodCheckInTimes(timesAsString);

    // Schedule or cancel mood notifications based on the updated settings
    final notificationService = NotificationService();
    if (_enableMoodNotifications) {
      notificationService.scheduleMoodCheckInNotifications(timesAsString, l10n: l10n);
    } else {
      notificationService.cancelMoodCheckInNotifications();
    }
  }

  Future<void> _confirmRemoveCheckInTime(int index) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteButton),
        content: const Text('Remove this check-in time?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancelButton)),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.deleteButton)),
        ],
      ),
    );
    if (result == true) {
      _removeCheckInTime(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    log(_checkInTimes.toString(), name: 'MoodSettingsScreen');
    return Scaffold(
      appBar: AppBar(title: Text(l10n.moodSettingsTitle), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            elevation: 2,
            child: SwitchListTile(
              title: Text(l10n.enableMoodNotifications),
              subtitle: Text('Receive periodic mood check-in reminders'),
              value: _enableMoodNotifications,
              onChanged: (value) {
                setState(() {
                  _enableMoodNotifications = value;
                });
                _saveSettings();
              },
            ),
          ),
          if (_enableMoodNotifications) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.moodCheckInTimes, style: Theme.of(context).textTheme.titleMedium),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _addSuggestedTimes,
                              icon: const Icon(Icons.auto_awesome),
                              label: Text(l10n.suggestTimes),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton.icon(
                              onPressed: _addCheckInTime,
                              icon: const Icon(Icons.add),
                              label: Text(l10n.add),
                              style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (_checkInTimes.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 32.0),
                          child: Text(
                            'No check-in times set. Add one to get started!',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _checkInTimes.length,
                        itemBuilder: (context, index) {
                          final time = _checkInTimes[index];
                          final formattedTime = time.format(context);
                          return Card(
                            elevation: 1,
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            child: ListTile(
                              leading: const Icon(Icons.access_time),
                              title: Text(formattedTime, style: Theme.of(context).textTheme.bodyLarge),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmRemoveCheckInTime(index),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Notification Tools', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _testMoodNotification,
                            icon: const Icon(Icons.notifications_active),
                            label: Text(l10n.testNotification),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              foregroundColor: Theme.of(context).colorScheme.onSecondary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _checkPendingNotifications,
                            icon: const Icon(Icons.list_alt),
                            label: Text(l10n.checkPendingNotifications),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.tertiary,
                              foregroundColor: Theme.of(context).colorScheme.onTertiary,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final l10n = AppLocalizations.of(context)!;
                          final notificationService = NotificationService();
                          await notificationService.scheduleTestMoodNotification(l10n: l10n);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Test mood notification scheduled for 1 minute from now!')));
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to schedule test notification: $e')));
                          }
                        }
                      },
                      icon: const Icon(Icons.schedule),
                      label: const Text('Test Scheduled Notification'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 8),
                    ElevatedButton.icon(
                      onPressed: () async {
                        try {
                          final notificationService = NotificationService();
                          await notificationService.cancelAllNotifications();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.allNotificationsCancelled)));
                          }
                        } catch (e) {
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to cancel notifications: $e')));
                          }
                        }
                      },
                      icon: const Icon(Icons.clear_all),
                      label: Text(l10n.cancelAllNotifications),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade100,
                        foregroundColor: Colors.red.shade800,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
