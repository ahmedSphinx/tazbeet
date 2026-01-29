import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/notification/notification_event.dart';
import '../../blocs/notification/notification_state.dart';
import '../../l10n/app_localizations.dart';
import '../../models/notification_item.dart';
import '../../models/notification_preferences.dart';
import 'notification_history_screen.dart';

/// Comprehensive notification preferences screen with granular controls
class NotificationPreferencesScreen extends StatefulWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  State<NotificationPreferencesScreen> createState() => _NotificationPreferencesScreenState();
}

class _NotificationPreferencesScreenState extends State<NotificationPreferencesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(const LoadNotificationPreferences());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notificationPreferences),
        actions: [IconButton(icon: const Icon(Icons.info_outline), onPressed: () => _showInfoDialog(context), tooltip: 'Info')],
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is! NotificationLoaded) {
            return Center(child: Text(AppLocalizations.of(context)!.loadingPreferences));
          }

          final preferences = state.preferences;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Master Toggle
              _buildMasterToggle(preferences, theme),

              const SizedBox(height: 24),

              // Do Not Disturb Section
              _buildDNDSection(preferences, state, theme),

              const SizedBox(height: 24),

              // Smart Scheduling Section
              _buildSmartSchedulingSection(preferences, theme),

              const SizedBox(height: 24),

              // Type-Specific Preferences
              _buildTypePreferencesSection(preferences, theme),

              const SizedBox(height: 24),

              // Advanced Settings
              _buildAdvancedSettings(preferences, theme),

              const SizedBox(height: 24),

              // Quick Actions
              _buildQuickActions(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMasterToggle(NotificationPreferences preferences, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      child: SwitchListTile(
        title: Text(l10n.enableNotifications, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(l10n.masterToggleForAllNotifications),
        value: preferences.masterNotificationsEnabled,
        secondary: Icon(preferences.masterNotificationsEnabled ? Icons.notifications_active : Icons.notifications_off, color: preferences.masterNotificationsEnabled ? theme.colorScheme.primary : theme.colorScheme.outline),
        onChanged: (value) {
          final updatedPreferences = preferences.copyWith(masterNotificationsEnabled: value);
          context.read<NotificationBloc>().add(UpdateNotificationPreferences(updatedPreferences));
        },
      ),
    );
  }

  Widget _buildDNDSection(NotificationPreferences preferences, NotificationLoaded state, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    final quietHours = preferences.quietHours;
    final isDNDActive = state.isDoNotDisturbActive || quietHours.isQuietTimeNow();

    return Card(
      elevation: 2,
      color: isDNDActive ? theme.colorScheme.errorContainer.withValues(alpha: 0.3) : null,
      child: ExpansionTile(
        leading: Icon(isDNDActive ? Icons.do_not_disturb_on : Icons.do_not_disturb_off, color: isDNDActive ? theme.colorScheme.error : theme.colorScheme.primary),
        title: Text(l10n.doNotDisturb, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(isDNDActive ? l10n.activeNotificationsMuted : l10n.configureQuietHours),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Manual DND Toggle
                Row(
                  children: [
                    Expanded(child: Text(l10n.manualDND, style: theme.textTheme.titleSmall)),
                    Switch(
                      value: state.isDoNotDisturbActive,
                      onChanged: (value) {
                        context.read<NotificationBloc>().add(ToggleDoNotDisturb(value));
                      },
                    ),
                  ],
                ),

                if (state.isDoNotDisturbActive)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<NotificationBloc>().add(const ToggleDoNotDisturb(true, duration: Duration(hours: 1)));
                            },
                            icon: const Icon(Icons.timer),
                            label: Text(AppLocalizations.of(context)!.oneHour),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              context.read<NotificationBloc>().add(const ToggleDoNotDisturb(true, duration: Duration(hours: 3)));
                            },
                            icon: const Icon(Icons.timer),
                            label: Text(AppLocalizations.of(context)!.threeHours),
                          ),
                        ),
                      ],
                    ),
                  ),

                const Divider(height: 24),

                // Scheduled Quiet Hours
                SwitchListTile(
                  title: Text(l10n.scheduledQuietHours, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(quietHours.enabled ? 'Active ${quietHours.startHour}:${quietHours.startMinute.toString().padLeft(2, '0')} - ${quietHours.endHour}:${quietHours.endMinute.toString().padLeft(2, '0')}' : l10n.setAutomaticQuietHours),
                  value: quietHours.enabled,
                  onChanged: (value) {
                    final updatedQuietHours = quietHours.copyWith(enabled: value);
                    context.read<NotificationBloc>().add(UpdateQuietHours(updatedQuietHours));
                  },
                ),

                if (quietHours.enabled) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTimeSelector('Start', quietHours.startHour, quietHours.startMinute, (hour, minute) {
                          final updatedQuietHours = quietHours.copyWith(startHour: hour, startMinute: minute);
                          context.read<NotificationBloc>().add(UpdateQuietHours(updatedQuietHours));
                        }),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildTimeSelector('End', quietHours.endHour, quietHours.endMinute, (hour, minute) {
                          final updatedQuietHours = quietHours.copyWith(endHour: hour, endMinute: minute);
                          context.read<NotificationBloc>().add(UpdateQuietHours(updatedQuietHours));
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(l10n.allowUrgentNotifications, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text(l10n.emergencyAlertsWillBypassQuietHours),
                    value: quietHours.allowUrgentNotifications,
                    onChanged: (value) {
                      final updatedQuietHours = quietHours.copyWith(allowUrgentNotifications: value);
                      context.read<NotificationBloc>().add(UpdateQuietHours(updatedQuietHours));
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector(String label, int hour, int minute, Function(int, int) onChanged) {
    return InkWell(
      onTap: () async {
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay(hour: hour, minute: minute),
        );
        if (time != null) {
          onChanged(time.hour, time.minute);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).colorScheme.outline),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text('${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}', style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildSmartSchedulingSection(NotificationPreferences preferences, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      child: ExpansionTile(
        leading: Icon(Icons.psychology, color: theme.colorScheme.primary),
        title: Text(l10n.smartScheduling, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(l10n.intelligentNotificationManagement),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n.enableSmartScheduling, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(l10n.automaticallyOptimizeNotificationTiming),
                  value: preferences.enableSmartScheduling,
                  onChanged: (value) {
                    final updatedPreferences = preferences.copyWith(enableSmartScheduling: value);
                    context.read<NotificationBloc>().add(UpdateNotificationPreferences(updatedPreferences));
                  },
                ),
                if (preferences.enableSmartScheduling) ...[
                  const Divider(),
                  ListTile(
                    title: Text(l10n.maxNotificationsPerHour, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Slider(
                      value: preferences.maxNotificationsPerHour.toDouble(),
                      min: 1,
                      max: 20,
                      divisions: 19,
                      label: preferences.maxNotificationsPerHour.toString(),
                      onChanged: (value) {
                        final updatedPreferences = preferences.copyWith(maxNotificationsPerHour: value.toInt());
                        context.read<NotificationBloc>().add(UpdateNotificationPreferences(updatedPreferences));
                      },
                    ),
                    trailing: Text(preferences.maxNotificationsPerHour.toString(), style: theme.textTheme.titleMedium),
                  ),
                  ListTile(
                    title: Text(l10n.minimumMinutesBetweenSameType, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Slider(
                      value: preferences.minMinutesBetweenSameType.toDouble(),
                      min: 1,
                      max: 60,
                      divisions: 59,
                      label: '${preferences.minMinutesBetweenSameType} min',
                      onChanged: (value) {
                        final updatedPreferences = preferences.copyWith(minMinutesBetweenSameType: value.toInt());
                        context.read<NotificationBloc>().add(UpdateNotificationPreferences(updatedPreferences));
                      },
                    ),
                    trailing: Text('${preferences.minMinutesBetweenSameType}m', style: theme.textTheme.titleMedium),
                  ),
                ],
                const Divider(),
                SwitchListTile(
                  title: Text(l10n.groupSimilarNotifications, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(l10n.combineNotificationsOfTheSameType),
                  value: preferences.enableGrouping,
                  onChanged: (value) {
                    final updatedPreferences = preferences.copyWith(enableGrouping: value);
                    context.read<NotificationBloc>().add(UpdateNotificationPreferences(updatedPreferences));
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.respectSystemDND, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(l10n.honorDeviceDoNotDisturbSettings),
                  value: preferences.respectSystemDND,
                  onChanged: (value) {
                    final updatedPreferences = preferences.copyWith(respectSystemDND: value);
                    context.read<NotificationBloc>().add(UpdateNotificationPreferences(updatedPreferences));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypePreferencesSection(NotificationPreferences preferences, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      child: ExpansionTile(
        leading: Icon(Icons.tune, color: theme.colorScheme.primary),
        title: Text(l10n.notificationTypes, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(l10n.customizeEachNotificationType),
        initiallyExpanded: false,
        children: NotificationType.values.map((type) {
          final typePrefs = preferences.getPreferencesForType(type) ?? NotificationTypePreferences(type: type);
          return _buildTypePreferenceCard(type, typePrefs, theme);
        }).toList(),
      ),
    );
  }

  Widget _buildTypePreferenceCard(NotificationType type, NotificationTypePreferences typePrefs, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ExpansionTile(
        leading: Icon(_getTypeIcon(type), color: _getTypeColor(type)),
        title: Text(_getTypeLabel(type)),
        subtitle: Text(typePrefs.enabled ? '${l10n.enabled} • ${_getPriorityLabel(typePrefs.priority)}' : l10n.disabled),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n.enable, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  value: typePrefs.enabled,
                  onChanged: (value) {
                    final updatedTypePrefs = typePrefs.copyWith(enabled: value);
                    context.read<NotificationBloc>().add(UpdateTypePreferences(updatedTypePrefs));
                  },
                ),
                if (typePrefs.enabled) ...[
                  const Divider(),
                  ListTile(
                    title: Text('Priority', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    trailing: DropdownButton<NotificationPriority>(
                      value: typePrefs.priority,
                      items: NotificationPriority.values.map((priority) {
                        return DropdownMenuItem(value: priority, child: Text(_getPriorityLabel(priority)));
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          final updatedTypePrefs = typePrefs.copyWith(priority: value);
                          context.read<NotificationBloc>().add(UpdateTypePreferences(updatedTypePrefs));
                        }
                      },
                    ),
                  ),
                  SwitchListTile(
                    title: Text(l10n.sound, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    value: typePrefs.playSound,
                    onChanged: (value) {
                      final updatedTypePrefs = typePrefs.copyWith(playSound: value);
                      context.read<NotificationBloc>().add(UpdateTypePreferences(updatedTypePrefs));
                    },
                  ),
                  if (typePrefs.playSound)
                    ListTile(
                      title: Text(l10n.volume, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      subtitle: Slider(
                        value: typePrefs.volume,
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: '${(typePrefs.volume * 100).toInt()}%',
                        onChanged: (value) {
                          final updatedTypePrefs = typePrefs.copyWith(volume: value);
                          context.read<NotificationBloc>().add(UpdateTypePreferences(updatedTypePrefs));
                        },
                      ),
                      trailing: Text('${(typePrefs.volume * 100).toInt()}%'),
                    ),
                  SwitchListTile(
                    title: Text(l10n.vibration, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    value: typePrefs.vibrate,
                    onChanged: (value) {
                      final updatedTypePrefs = typePrefs.copyWith(vibrate: value);
                      context.read<NotificationBloc>().add(UpdateTypePreferences(updatedTypePrefs));
                    },
                  ),
                  SwitchListTile(
                    title: Text(l10n.showBadge, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    value: typePrefs.showBadge,
                    onChanged: (value) {
                      final updatedTypePrefs = typePrefs.copyWith(showBadge: value);
                      context.read<NotificationBloc>().add(UpdateTypePreferences(updatedTypePrefs));
                    },
                  ),
                  SwitchListTile(
                    title: Text(l10n.enableActions, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    subtitle: Text(l10n.showActionButtons),
                    value: typePrefs.enableActions,
                    onChanged: (value) {
                      final updatedTypePrefs = typePrefs.copyWith(enableActions: value);
                      context.read<NotificationBloc>().add(UpdateTypePreferences(updatedTypePrefs));
                    },
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSettings(NotificationPreferences preferences, ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: 2,
      child: ExpansionTile(
        leading: Icon(Icons.settings_applications, color: theme.colorScheme.primary),
        title: Text(l10n.advancedSettings, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(l10n.expertOptions),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  title: Text(l10n.badgeOnlyMode, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(l10n.badgeOnlyModeSubtitle),
                  value: preferences.badgeOnlyMode,
                  onChanged: (value) {
                    final updatedPreferences = preferences.copyWith(badgeOnlyMode: value);
                    context.read<NotificationBloc>().add(UpdateNotificationPreferences(updatedPreferences));
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.deliveryTracking, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(l10n.trackWhenNotificationsAreDelivered),
                  value: preferences.enableDeliveryTracking,
                  onChanged: (value) {
                    final updatedPreferences = preferences.copyWith(enableDeliveryTracking: value);
                    context.read<NotificationBloc>().add(UpdateNotificationPreferences(updatedPreferences));
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.analytics, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(l10n.trackNotificationInteractionStatistics),
                  value: preferences.enableAnalytics,
                  onChanged: (value) {
                    final updatedPreferences = preferences.copyWith(enableAnalytics: value);
                    context.read<NotificationBloc>().add(UpdateNotificationPreferences(updatedPreferences));
                  },
                ),
                SwitchListTile(
                  title: Text(l10n.adaptiveTiming, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(l10n.learnFromYourBehaviorToOptimizeNotificationTiming),
                  value: preferences.enableAdaptiveTiming,
                  onChanged: (value) {
                    final updatedPreferences = preferences.copyWith(enableAdaptiveTiming: value);
                    context.read<NotificationBloc>().add(UpdateNotificationPreferences(updatedPreferences));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, NotificationLoaded state) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<NotificationBloc>().add(const SendTestNotification(NotificationType.system, immediate: true));
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.testNotificationSent)));
            },
            icon: const Icon(Icons.send),
            label: Text(l10n.sendTestNotification),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () {
              context.read<NotificationBloc>().add(const OpenNotificationSettings());
            },
            icon: const Icon(Icons.settings),
            label: Text(l10n.openSystemSettings),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider.value(value: context.read<NotificationBloc>(), child: const NotificationHistoryScreen()),
                ),
              );
            },
            icon: const Icon(Icons.history),
            label: Text(l10n.viewHistory),
          ),
        ),
      ],
    );
  }

  void _showInfoDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.notificationPreferencesInfo),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.notificationPreferencesInfoDetails),
              const SizedBox(height: 16),
              Text(l10n.smartSchedulingInfo, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(l10n.dndInfo, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close))],
      ),
    );
  }

  // Helper methods
  String _getTypeLabel(NotificationType type) {
    final l10n = AppLocalizations.of(context)!;
    switch (type) {
      case NotificationType.taskReminder:
        return l10n.taskReminders;
      case NotificationType.taskDue:
        return l10n.taskDue;

      case NotificationType.taskCompleted:
        return l10n.taskCompletedChannelName;
      case NotificationType.moodCheckIn:
        return l10n.moodCheckIn;
      case NotificationType.pomodoroWork:
        return l10n.pomodoroWork;
      case NotificationType.pomodoroBreak:
        return l10n.pomodoroBreak;
      case NotificationType.pomodoroComplete:
        return l10n.pomodoroComplete;
      case NotificationType.emergency:
        return l10n.emergency;
      case NotificationType.system:
        return l10n.system;
      case NotificationType.userSignup:
        return 'New User';
    }
  }

  IconData _getTypeIcon(NotificationType type) {
    switch (type) {
      case NotificationType.taskReminder:
        return Icons.task_alt;
      case NotificationType.taskDue:
        return Icons.alarm;
      case NotificationType.taskCompleted:
        return Icons.check_circle;
      case NotificationType.moodCheckIn:
        return Icons.mood;
      case NotificationType.pomodoroWork:
        return Icons.work;
      case NotificationType.pomodoroBreak:
        return Icons.coffee;
      case NotificationType.pomodoroComplete:
        return Icons.done_all;
      case NotificationType.emergency:
        return Icons.warning;
      case NotificationType.system:
        return Icons.settings;
      case NotificationType.userSignup:
        return Icons.person_add;
    }
  }

  Color _getTypeColor(NotificationType type) {
    switch (type) {
      case NotificationType.taskReminder:
        return Colors.blue;
      case NotificationType.taskDue:
        return Colors.orange;
      case NotificationType.taskCompleted:
        return Colors.green;
      case NotificationType.moodCheckIn:
        return Colors.purple;
      case NotificationType.pomodoroWork:
        return Colors.red;
      case NotificationType.pomodoroBreak:
        return Colors.teal;
      case NotificationType.pomodoroComplete:
        return Colors.green;
      case NotificationType.emergency:
        return Colors.red;
      case NotificationType.system:
        return Colors.grey;
      case NotificationType.userSignup:
        return Colors.indigo;
    }
  }

  String _getPriorityLabel(NotificationPriority priority) {
    final l10n = AppLocalizations.of(context)!;
    switch (priority) {
      case NotificationPriority.low:
        return l10n.low;
      case NotificationPriority.medium:
        return l10n.medium;
      case NotificationPriority.high:
        return l10n.high;
      case NotificationPriority.urgent:
        return l10n.urgent;
    }
  }
}
