import 'package:flutter/material.dart';
import 'package:tazbeet/ui/widgets/voice_task_fab.dart';
import 'package:tazbeet/ui/widgets/voice_task_tutorial.dart';
import 'package:tazbeet/ui/screens/voice_task_screen.dart';
import 'package:tazbeet/helpers/voice_task_permissions.dart';
import 'package:tazbeet/services/app_logging_service.dart';
import 'package:tazbeet/services/settings_service.dart';
import 'package:tazbeet/ui/themes/design_system.dart';

/// Voice Task Integration Service
class VoiceTaskIntegration {
  static final VoiceTaskIntegration _instance = VoiceTaskIntegration._internal();
  factory VoiceTaskIntegration() => _instance;
  VoiceTaskIntegration._internal();

  final SettingsService _settingsService = SettingsService();

  /// Check if voice tasks are enabled
  bool get isVoiceTaskEnabled {
    return _settingsService.voiceTaskEnabled;
  }

  /// Check if user has seen voice task tutorial
  bool get hasSeenTutorial {
    return _settingsService.hasSeenVoiceTaskTutorial;
  }

  /// Mark tutorial as seen
  Future<void> markTutorialSeen() async {
    await _settingsService.setHasSeenVoiceTaskTutorial(true);
    AppLogging.logInfo('Voice task tutorial marked as seen', name: 'VoiceTaskIntegration');
  }

  /// Show voice task tutorial if needed
  Widget? maybeShowTutorial({required BuildContext context, required VoidCallback onCompleted, VoidCallback? onSkipped}) {
    if (!hasSeenTutorial) {
      return VoiceTaskTutorial(
        onCompleted: () {
          markTutorialSeen();
          onCompleted();
        },
        onSkipped: () {
          markTutorialSeen();
          onSkipped?.call();
        },
      );
    }
    return null;
  }

  /// Check permissions and show dialog if needed
  Future<bool> ensurePermissions(BuildContext context) async {
    final hasPermission = await VoiceTaskPermissions.checkAndRequestPermissions();

    if (!hasPermission) {
      VoiceTaskPermissions.showPermissionDialog(
        context,
        onGranted: () {
          AppLogging.logInfo('Voice task permissions granted', name: 'VoiceTaskIntegration');
        },
        onDenied: () {
          VoiceTaskPermissions.showPermissionDeniedDialog(context);
        },
      );
      return false;
    }

    return true;
  }
}

/// Extension for easy voice task integration
extension VoiceTaskIntegrationExtension on Widget {
  /// Add voice task FAB to any screen
  Widget withVoiceTaskFab({Key? key, VoidCallback? onTaskCreated, bool showLabel = true, bool showTutorial = false}) {
    return Stack(
      children: [
        this,
        if (VoiceTaskIntegration().isVoiceTaskEnabled)
          Positioned(
            bottom: 20,
            right: 20,
            child: VoiceTaskFab(key: key, onTaskCreated: onTaskCreated, showLabel: showLabel),
          ),
      ],
    );
  }

  /// Add voice task button to any widget
  Widget withVoiceTaskButton({Key? key, VoidCallback? onTaskCreated, bool isCompact = false}) {
    return Stack(
      children: [
        this,
        if (VoiceTaskIntegration().isVoiceTaskEnabled)
          Positioned(
            top: 10,
            right: 10,
            child: VoiceTaskButton(key: key, onTaskCreated: onTaskCreated, isCompact: isCompact),
          ),
      ],
    );
  }
}

/// Voice Task Settings Widget
class VoiceTaskSettings extends StatefulWidget {
  const VoiceTaskSettings({super.key});

  @override
  State<VoiceTaskSettings> createState() => _VoiceTaskSettingsState();
}

class _VoiceTaskSettingsState extends State<VoiceTaskSettings> {
  final SettingsService _settingsService = SettingsService();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Voice Task Toggle
        SwitchListTile(
          title: const Text('Voice Task'),
          subtitle: const Text('Create tasks with your voice'),
          value: _settingsService.voiceTaskEnabled,
          onChanged: (value) async {
            await _settingsService.setVoiceTaskEnabled(value);
            setState(() {});

            if (value) {
              // Check permissions when enabling
              await VoiceTaskPermissions.checkAndRequestPermissions();
            }
          },
          secondary: const Icon(Icons.mic),
        ),

        // Tutorial Reset
        ListTile(
          title: const Text('Show Tutorial Again'),
          subtitle: const Text('Reset voice task tutorial'),
          leading: const Icon(Icons.school),
          onTap: () async {
            await _settingsService.setHasSeenVoiceTaskTutorial(false);
            setState(() {});

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tutorial will show next time you use voice tasks'), duration: Duration(seconds: 2)));
          },
        ),

        // Permissions Status
        FutureBuilder<bool>(
          future: VoiceTaskPermissions.checkMicrophonePermission(),
          builder: (context, snapshot) {
            final hasPermission = snapshot.data ?? false;

            return ListTile(
              title: const Text('Microphone Permission'),
              subtitle: Text(hasPermission ? 'Granted' : 'Not granted', style: TextStyle(color: hasPermission ? Colors.green : Colors.red)),
              leading: Icon(hasPermission ? Icons.check_circle : Icons.error, color: hasPermission ? Colors.green : Colors.red),
              onTap: hasPermission
                  ? null
                  : () {
                      VoiceTaskPermissions.showPermissionDialog(context, onGranted: () => setState(() {}), onDenied: () {});
                    },
            );
          },
        ),

        // Voice Task Stats
        FutureBuilder<Map<String, int>>(
          future: _getVoiceTaskStats(),
          builder: (context, snapshot) {
            final stats = snapshot.data ?? {};

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(title: const Text('Voice Tasks Created'), subtitle: Text('${stats['total'] ?? 0} tasks created'), leading: const Icon(Icons.mic)),
                ListTile(title: const Text('Success Rate'), subtitle: Text('${stats['successRate'] ?? 0}% accuracy'), leading: const Icon(Icons.trending_up)),
              ],
            );
          },
        ),
      ],
    );
  }

  Future<Map<String, int>> _getVoiceTaskStats() async {
    // TODO: Implement voice task statistics
    // This would query the database for voice task metrics
    return {'total': 0, 'successRate': 0};
  }
}

/// Voice Task Quick Access Widget
class VoiceTaskQuickAccess extends StatelessWidget {
  const VoiceTaskQuickAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(AppRadius.md)),
      child: Row(
        children: [
          Icon(Icons.mic, color: Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(child: Text('Try voice tasks! Tap the microphone to create tasks instantly.', style: Theme.of(context).textTheme.bodySmall)),
          VoiceTaskButton(
            onTaskCreated: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Voice task created!'), backgroundColor: Colors.green, duration: Duration(seconds: 2)));
            },
            isCompact: true,
          ),
        ],
      ),
    );
  }
}

/// Voice Task Floating Action Menu
class VoiceTaskActionMenu extends StatelessWidget {
  const VoiceTaskActionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'voice_task',
          child: Row(
            children: [
              const Icon(Icons.mic),
              const SizedBox(width: AppSpacing.sm),
              const Text('Voice Task'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'voice_screen',
          child: Row(
            children: [
              const Icon(Icons.mic),
              const SizedBox(width: AppSpacing.sm),
              const Text('Voice Screen'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'tutorial',
          child: Row(
            children: [
              const Icon(Icons.school),
              const SizedBox(width: AppSpacing.sm),
              const Text('Show Tutorial'),
            ],
          ),
        ),
      ],
      onSelected: (value) {
        switch (value) {
          case 'voice_task':
            // Trigger voice task recording
            break;
          case 'voice_screen':
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => const VoiceTaskScreen()));
            break;
          case 'tutorial':
            showDialog(
              context: context,
              builder: (context) => VoiceTaskTutorial(
                onCompleted: () {
                  Navigator.of(context).pop();
                },
                onSkipped: () {
                  Navigator.of(context).pop();
                },
              ),
            );
            break;
        }
      },
    );
  }
}
