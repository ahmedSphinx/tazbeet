import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
        title: const Text('Emergency Controls'),
      ),
      body: Consumer<EmergencyService>(
        builder: (context, emergencyService, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Emergency Mode',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Activate emergency mode to suspend all reminders and timers',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),
                _buildEmergencyModeToggle(emergencyService),
                const SizedBox(height: 32),
                const Text(
                  'Quick Controls',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
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
          : Theme.of(context).colorScheme.surface,
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
                            ? 'Emergency Mode Active'
                            : 'Emergency Mode',
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
                            ? 'All reminders and timers are suspended'
                            : 'Suspend all reminders and timers immediately',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: emergencyService.isEmergencyMode,
                  onChanged: (value) => emergencyService.toggleEmergencyMode(),
                  activeColor: Theme.of(context).colorScheme.error,
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
                '15 Min Pause',
                Icons.pause_circle_outline,
                () => emergencyService.quickPause(duration: const Duration(minutes: 15)),
                emergencyService,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickControlButton(
                context,
                '1 Hour Pause',
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
                'Resume All',
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
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildSuspensionStatus(EmergencyService emergencyService) {
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
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
                  const Text(
                    'Reminders Suspended',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Time remaining: ${emergencyService.getSuspensionTimeRemaining()}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => emergencyService.resumeReminders(),
              child: const Text('Resume Now'),
            ),
          ],
        ),
      ),
    );
  }
}
