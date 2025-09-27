import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import '../../blocs/task_list/task_list_bloc.dart';
import '../../blocs/task_list/task_list_event.dart';
import '../../models/task.dart';
import '../../services/repeat_service.dart';

class RecurringTasksManager extends StatefulWidget {
  const RecurringTasksManager({Key? key}) : super(key: key);

  @override
  State<RecurringTasksManager> createState() => _RecurringTasksManagerState();
}

class _RecurringTasksManagerState extends State<RecurringTasksManager> {
  final RepeatService _repeatService = RepeatService();
  Map<String, int> _stats = {};
  List<Task> _tasksNeedingInstances = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecurringData();
  }

  Future<void> _loadRecurringData() async {
    setState(() => _isLoading = true);

    try {
      final stats = await _repeatService.getRecurringTaskStats();
      final tasksNeedingInstances = await _repeatService.getTasksNeedingRecurringInstances();

      setState(() {
        _stats = stats;
        _tasksNeedingInstances = tasksNeedingInstances;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.error}: $e')));
    }
  }

  Future<void> _generateRecurringInstances() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.generateRecurringInstances),
        content: Text('This will generate new instances for all recurring tasks that need them. Continue?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(AppLocalizations.of(context)!.cancelButton)),
          ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: Text(AppLocalizations.of(context)!.generateRecurringInstances)),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);

      try {
        for (final task in _tasksNeedingInstances) {
          final nextInstance = await _repeatService.generateNextRecurringTask(task);
          if (nextInstance != null) {
            context.read<TaskListBloc>().add(AddTask(nextInstance));
          }
        }

        await _loadRecurringData();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.recurringInstancesGenerated)));
      } catch (e) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.errorGeneratingInstances}: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.repeat, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(AppLocalizations.of(context)!.recurringTasksManager, style: theme.textTheme.titleLarge),
                const Spacer(),
                IconButton(onPressed: _loadRecurringData, icon: const Icon(Icons.refresh), tooltip: AppLocalizations.of(context)!.refreshRecurringTasks),
              ],
            ),

            const SizedBox(height: 16),

            // Statistics Cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(title: AppLocalizations.of(context)!.activeRecurringTasks, value: _stats['activeRecurringTasks']?.toString() ?? '0', icon: Icons.repeat_one, color: Colors.blue),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(title: AppLocalizations.of(context)!.totalRecurringInstances, value: _stats['totalRecurringInstances']?.toString() ?? '0', icon: Icons.copy_all, color: Colors.green),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _StatCard(title: AppLocalizations.of(context)!.tasksNeedingInstances, value: _tasksNeedingInstances.length.toString(), icon: Icons.add_circle_outline, color: Colors.orange),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Tasks Needing Instances
            if (_tasksNeedingInstances.isNotEmpty) ...[
              Text('${AppLocalizations.of(context)!.tasksNeedingInstances}:', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              ..._tasksNeedingInstances
                  .take(3)
                  .map(
                    (task) => ListTile(
                      title: Text(task.title),
                      subtitle: Text('Next: ${task.repeatRule?.getDisplayText() ?? ''}'),
                      leading: const Icon(Icons.schedule),
                      trailing: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () async {
                          final nextInstance = await _repeatService.generateNextRecurringTask(task);
                          if (nextInstance != null) {
                            context.read<TaskListBloc>().add(AddTask(nextInstance));
                            await _loadRecurringData();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.recurringInstancesGenerated} for "${task.title}"')));
                          }
                        },
                        tooltip: AppLocalizations.of(context)!.generateNextInstance,
                      ),
                    ),
                  ),
              if (_tasksNeedingInstances.length > 3) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton(onPressed: _generateRecurringInstances, child: Text('${AppLocalizations.of(context)!.generateAllInstances} (${_tasksNeedingInstances.length})')),
                ),
              ],
            ] else ...[
              Center(
                child: Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 48),
                    const SizedBox(height: 8),
                    Text(AppLocalizations.of(context)!.allRecurringUpToDate, style: theme.textTheme.bodyMedium),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _tasksNeedingInstances.isEmpty ? null : _generateRecurringInstances,
                    icon: const Icon(Icons.auto_awesome),
                    label: Text(AppLocalizations.of(context)!.generateAllInstances),
                    style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary, foregroundColor: theme.colorScheme.onPrimary),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.title, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: color),
            ),
            Text(title, style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
