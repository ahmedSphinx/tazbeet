import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/notification/notification_bloc.dart';
import '../../blocs/notification/notification_event.dart';
import '../../blocs/notification/notification_state.dart';
import '../../l10n/app_localizations.dart';
import '../../models/notification_item.dart';
import '../screens/notification_history_screen.dart';
import '../screens/notification_preferences_screen.dart';

/// Quick action buttons for notification management
class NotificationQuickActions extends StatelessWidget {
  final bool showDNDToggle;
  final bool showTestButton;
  final bool showClearButton;
  final bool showSettingsButton;

  const NotificationQuickActions({super.key, this.showDNDToggle = true, this.showTestButton = true, this.showClearButton = true, this.showSettingsButton = true});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationBloc, NotificationState>(
      builder: (context, state) {
        if (state is! NotificationLoaded) {
          return const SizedBox.shrink();
        }

        return Card(
          elevation: 2,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Quick Actions', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [if (showDNDToggle) _buildDNDButton(context, state), if (showTestButton) _buildTestButton(context), if (showClearButton) _buildClearButton(context, state), if (showSettingsButton) _buildSettingsButton(context), _buildHistoryButton(context, state), _buildPermissionsButton(context, state)],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDNDButton(BuildContext context, NotificationLoaded state) {
    final isDNDActive = state.isDoNotDisturbActive || state.preferences.quietHours.isQuietTimeNow();

    return ActionChip(
      avatar: Icon(isDNDActive ? Icons.do_not_disturb_on : Icons.do_not_disturb_off, size: 20),
      label: Text(isDNDActive ? 'DND On' : 'DND Off'),
      backgroundColor: isDNDActive ? Colors.red.withValues(alpha: 0.1) : null,
      side: BorderSide(color: isDNDActive ? Colors.red : Theme.of(context).colorScheme.outline),
      onPressed: () {
        context.read<NotificationBloc>().add(ToggleDoNotDisturb(!isDNDActive));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isDNDActive ? 'Do Not Disturb disabled' : 'Do Not Disturb enabled')));
      },
    );
  }

  Widget _buildTestButton(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.send, size: 20),
      label: Text(AppLocalizations.of(context)!.testButton),
      onPressed: () {
        context.read<NotificationBloc>().add(const SendTestNotification(NotificationType.system, immediate: true));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.testNotificationSent)));
      },
    );
  }

  Widget _buildClearButton(BuildContext context, NotificationLoaded state) {
    final hasNotifications = state.allNotifications.isNotEmpty;

    return ActionChip(avatar: const Icon(Icons.clear_all, size: 20), label: Text(AppLocalizations.of(context)!.clearAllButton), onPressed: hasNotifications ? () => _showClearDialog(context) : null);
  }

  Widget _buildSettingsButton(BuildContext context) {
    return ActionChip(
      avatar: const Icon(Icons.settings, size: 20),
      label: const Text('Settings'),
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPreferencesScreen()));
      },
    );
  }

  Widget _buildHistoryButton(BuildContext context, NotificationLoaded state) {
    final count = state.allNotifications.length;

    return ActionChip(
      avatar: const Icon(Icons.history, size: 20),
      label: Text('History${count > 0 ? " ($count)" : ""}'),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BlocProvider.value(value: context.read<NotificationBloc>(), child: const NotificationHistoryScreen()),
          ),
        );
      },
    );
  }

  Widget _buildPermissionsButton(BuildContext context, NotificationLoaded state) {
    final granted = state.permissionsGranted;

    return ActionChip(
      avatar: Icon(granted ? Icons.check_circle : Icons.error, size: 20),
      label: Text(granted ? 'Permissions OK' : 'Grant Permissions'),
      backgroundColor: granted ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
      side: BorderSide(color: granted ? Colors.green : Colors.orange),
      onPressed: () {
        if (granted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Notification permissions are granted')));
        } else {
          context.read<NotificationBloc>().add(const RequestNotificationPermissions());
        }
      },
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.clearAllNotifications),
        content: Text(AppLocalizations.of(context)!.clearAllNotificationsConfirmation),
        actions: [
          TextButton(onPressed: () => Navigator.pop(dialogContext), child: Text(AppLocalizations.of(context)!.cancelButton)),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<NotificationBloc>().add(const CancelAllNotifications());
              context.read<NotificationBloc>().add(const ClearNotificationHistory());
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('All notifications cleared')));
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
