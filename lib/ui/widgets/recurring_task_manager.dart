import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/task_list/task_list_bloc.dart';
import '../../blocs/task_list/task_list_event.dart';
import '../../services/recurring_task_service.dart';
import '../../services/app_logging_service.dart';

class RecurringTaskManager extends StatefulWidget {
  const RecurringTaskManager({super.key});

  @override
  State<RecurringTaskManager> createState() => _RecurringTaskManagerState();
}

class _RecurringTaskManagerState extends State<RecurringTaskManager> {
  bool _isProcessing = false;
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    try {
      final stats = await RecurringTaskService().getRecurringStats();
      setState(() {
        _stats = stats;
      });
    } catch (e) {
      AppLogging.logError('Failed to load recurring task stats: $e');
    }
  }

  Future<void> _processRecurringTasks() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      await RecurringTaskService().processNow();
      await _loadStats();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Recurring tasks processed successfully'), backgroundColor: Colors.green));

        // Refresh task list
        context.read<TaskListBloc>().add(LoadTasks());
      }
    } catch (e) {
      AppLogging.logError('Failed to process recurring tasks: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error processing recurring tasks: $e'), backgroundColor: Colors.red));
      }
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Recurring Tasks', style: Theme.of(context).textTheme.titleLarge),
                if (_stats != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: _stats!['isProcessing'] == true ? Colors.orange : Colors.green, borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      _stats!['isProcessing'] == true ? 'Active' : 'Idle',
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            if (_stats != null) ...[
              _buildStatRow('Total Recurring Tasks', _stats!['totalRecurringTasks'].toString()),
              _buildStatRow('Active Recurring Tasks', _stats!['activeRecurringTasks'].toString()),
              _buildStatRow('Total Instances', _stats!['totalRecurringInstances'].toString()),
              _buildStatRow('Tasks Needing Instances', _stats!['tasksNeedingInstances'].toString()),
              const SizedBox(height: 16),
            ],

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isProcessing ? null : _processRecurringTasks,
                icon: _isProcessing ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.refresh),
                label: Text(_isProcessing ? 'Processing...' : 'Process Recurring Tasks Now'),
                style: ElevatedButton.styleFrom(backgroundColor: _isProcessing ? Colors.grey : Theme.of(context).primaryColor, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
              ),
            ),

            const SizedBox(height: 12),

            Text('Background processing runs automatically every hour. Use the button above for immediate processing.', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
