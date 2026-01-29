import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tazbeet/providers/voice_task_provider.dart';
import 'package:tazbeet/ui/widgets/voice_task_integration.dart';
import 'package:tazbeet/ui/themes/design_system.dart';
import '../../l10n/app_localizations.dart';

/// Voice Task Dashboard Widget
class VoiceTaskDashboard extends StatelessWidget {
  const VoiceTaskDashboard({super.key});

  Widget _buildStatusCard(BuildContext context, String title, Widget content, Widget icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          content,
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Analytics', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.md),

        // Stats Grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: 1.5,
          children: [
            _buildAnalyticsCard(context, 'Total Sessions', '0', Icons.analytics, Colors.purple),
            _buildAnalyticsCard(context, 'Success Rate', '0%', Icons.trending_up, Colors.green),
            _buildAnalyticsCard(context, 'Avg Confidence', '0%', Icons.psychology, Colors.blue),
            _buildAnalyticsCard(context, 'Recent Sessions', '0', Icons.history, Colors.orange),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Category Breakdown
        Text('Task Categories', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: AppSpacing.sm),
        Container(height: 150, child: const Center(child: Text('No data yet'))),
      ],
    );
  }

  Widget _buildAnalyticsCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Consumer<VoiceTaskProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.settingsTitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.md),

            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.enableVoiceTasks),
              subtitle: Text(AppLocalizations.of(context)!.createTasksWithYourVoice),
              value: provider.isEnabled,
              onChanged: (value) {
                // TODO: Implement settings update
              },
              secondary: const Icon(Icons.mic),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => VoiceTaskProvider(),
      child: Consumer<VoiceTaskProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.voiceTasks), backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary, elevation: 0),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Quick Access
                  if (provider.isEnabled) const VoiceTaskQuickAccess(),
                  const SizedBox(height: AppSpacing.lg),

                  // Status Cards
                  Row(
                    children: [
                      Expanded(child: _buildStatusCard(context, 'Status', Text(provider.isEnabled ? 'Enabled' : 'Disabled'), Icon(provider.isEnabled ? Icons.check_circle : Icons.error, color: provider.isEnabled ? Colors.green : Colors.red), Colors.blue)),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(child: _buildStatusCard(context, 'Permissions', Text(provider.hasPermissions ? 'Granted' : 'Not Granted'), Icon(provider.hasPermissions ? Icons.check_circle : Icons.error, color: provider.hasPermissions ? Colors.green : Colors.red), Colors.orange)),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  // Analytics Section
                  _buildAnalyticsSection(context),
                  const SizedBox(height: AppSpacing.lg),

                  // Settings Section
                  _buildSettingsSection(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class VoiceTaskDashboardContent extends StatelessWidget {
  const VoiceTaskDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.voiceTasks), backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Theme.of(context).colorScheme.onPrimary, elevation: 0),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Quick Access
            Consumer<VoiceTaskProvider>(
              builder: (context, provider, child) {
                if (provider.isEnabled) {
                  return const VoiceTaskQuickAccess();
                }
                return const SizedBox();
              },
            ),
            const SizedBox(height: AppSpacing.lg),

            // Status Cards
            Row(
              children: [
                Expanded(
                  child: _buildStatusCard(
                    context,
                    'Status',
                    Consumer<VoiceTaskProvider>(
                      builder: (context, provider, child) {
                        return Text(provider.isEnabled ? 'Enabled' : 'Disabled');
                      },
                    ),
                    Consumer<VoiceTaskProvider>(
                      builder: (context, provider, child) {
                        return Icon(provider.isEnabled ? Icons.check_circle : Icons.error, color: provider.isEnabled ? Colors.green : Colors.red);
                      },
                    ),
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildStatusCard(
                    context,
                    'Permissions',
                    Consumer<VoiceTaskProvider>(
                      builder: (context, provider, child) {
                        return Text(provider.hasPermissions ? 'Granted' : 'Not Granted');
                      },
                    ),
                    Consumer<VoiceTaskProvider>(
                      builder: (context, provider, child) {
                        return Icon(provider.hasPermissions ? Icons.check_circle : Icons.error, color: provider.hasPermissions ? Colors.green : Colors.red);
                      },
                    ),
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),

            // Analytics Section
            _buildAnalyticsSection(context),
            const SizedBox(height: AppSpacing.lg),

            // Settings Section
            _buildSettingsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, String title, Widget content, Widget icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          content,
        ],
      ),
    );
  }

  Widget _buildAnalyticsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Analytics', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: AppSpacing.md),

        // Stats Grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          childAspectRatio: 1.5,
          children: [
            _buildAnalyticsCard(context, 'Total Sessions', '0', Icons.analytics, Colors.purple),
            _buildAnalyticsCard(context, 'Success Rate', '0%', Icons.trending_up, Colors.green),
            _buildAnalyticsCard(context, 'Avg Confidence', '0%', Icons.psychology, Colors.blue),
            _buildAnalyticsCard(context, 'Recent Sessions', '0', Icons.history, Colors.orange),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),

        // Category Breakdown
        Text('Task Categories', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: AppSpacing.sm),
        Container(height: 150, child: const Center(child: Text('No data yet'))),
      ],
    );
  }

  Widget _buildAnalyticsCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: AppSpacing.sm),
              Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Consumer<VoiceTaskProvider>(
      builder: (context, provider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(AppLocalizations.of(context)!.settingsTitle, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppSpacing.md),

            SwitchListTile(
              title: Text(AppLocalizations.of(context)!.enableVoiceTasks),
              subtitle: Text(AppLocalizations.of(context)!.createTasksWithYourVoice),
              value: provider.isEnabled,
              onChanged: (value) {
                // TODO: Implement settings update
              },
              secondary: const Icon(Icons.mic),
            ),
          ],
        );
      },
    );
  }
}
