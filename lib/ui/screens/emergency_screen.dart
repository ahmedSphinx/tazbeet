import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/emergency_service.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EmergencyService>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).emergencyControls),
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        elevation: 0,
      ),
      body: Consumer<EmergencyService>(
        builder: (context, emergencyService, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).emergencyMode,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).activateEmergencyMode,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 24),
                _buildEmergencyModeToggle(emergencyService),
                const SizedBox(height: 32),
                Text(
                  AppLocalizations.of(context).quickControls,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),
                _buildQuickControls(emergencyService),
                const SizedBox(height: 32),
                if (emergencyService.isSuspended)
                  _buildSuspensionStatus(emergencyService),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmergencyModeToggle(EmergencyService emergencyService) {
    return Card(
      color: emergencyService.isEmergencyMode
          ? Theme.of(context).colorScheme.errorContainer
          : Theme.of(context).colorScheme.surfaceContainerHighest,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  emergencyService.isEmergencyMode
                      ? Icons.warning_amber_rounded
                      : Icons.shield_outlined,
                  size: 32,
                  color: emergencyService.isEmergencyMode
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emergencyService.isEmergencyMode
                            ? AppLocalizations.of(context).emergencyModeActive
                            : AppLocalizations.of(context).emergencyMode,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: emergencyService.isEmergencyMode
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        emergencyService.isEmergencyMode
                            ? AppLocalizations.of(context).allRemindersSuspended
                            : AppLocalizations.of(context).suspendRemindersTimers,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: emergencyService.isEmergencyMode,
                  onChanged: (value) => emergencyService.toggleEmergencyMode(),
                  activeColor: Theme.of(context).colorScheme.error,
                  activeTrackColor: Theme.of(context).colorScheme.error.withValues(alpha: 0.5),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickControls(EmergencyService emergencyService) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildQuickControlButton(
                context,
                AppLocalizations.of(context).fifteenMinPause,
                Icons.pause_circle_outline,
                () => emergencyService.quickPause(duration: const Duration(minutes: 15)),
                emergencyService,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickControlButton(
                context,
                AppLocalizations.of(context).oneHourPause,
                Icons.hourglass_empty,
                () => emergencyService.suspendReminders(duration: const Duration(hours: 1)),
                emergencyService,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickControlButton(
                context,
                AppLocalizations.of(context).resumeAll,
                Icons.play_circle_outline,
                () => emergencyService.resumeReminders(),
                emergencyService,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Container(), // Empty space for layout
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickControlButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
    EmergencyService emergencyService,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuspensionStatus(EmergencyService emergencyService) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              Icons.timer_off,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).remindersSuspended,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context).timeRemaining(emergencyService.getSuspensionTimeRemaining()),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => emergencyService.resumeReminders(),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.primary,
              ),
              child: Text(AppLocalizations.of(context).resumeNow),
            ),
          ],
        ),
      ),
    );
  }
}
