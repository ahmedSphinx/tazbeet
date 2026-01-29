import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../l10n/app_localizations.dart';
import '../../models/voice_task_result.dart';
import '../../models/task.dart';
import '../../blocs/task_list/task_list_bloc.dart';
import '../../blocs/task_list/task_list_event.dart';
import '../../ui/themes/design_system.dart';

/// Voice Task Confirmation Screen
class VoiceTaskConfirmation extends StatefulWidget {
  final VoiceTaskResult result;
  final VoidCallback? onCancelled;
  final VoidCallback? onCompleted;

  const VoiceTaskConfirmation({super.key, required this.result, this.onCancelled, this.onCompleted});

  @override
  State<VoiceTaskConfirmation> createState() => _VoiceTaskConfirmationState();
}

class _VoiceTaskConfirmationState extends State<VoiceTaskConfirmation> {
  List<ParsedTask> _selectedTasks = [];
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _selectedTasks = List.from(widget.result.tasks);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.mic, color: Theme.of(context).colorScheme.primary, size: 24),
                const SizedBox(width: AppSpacing.sm),
                Text('Voice Tasks Created', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                IconButton(onPressed: widget.onCancelled, icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Confidence indicator
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(color: _getConfidenceColor().withValues(alpha: 0.1), borderRadius: BorderRadius.circular(AppRadius.md)),
              child: Row(
                children: [
                  Icon(_getConfidenceIcon(), color: _getConfidenceColor(), size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    '${(widget.result.confidence * 100).toInt()}% confidence',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: _getConfidenceColor(), fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Original transcription
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Original:', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                  const SizedBox(height: AppSpacing.xs),
                  Text(widget.result.originalTranscription, style: Theme.of(context).textTheme.bodyMedium),
                  if (widget.result.audioPath != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Icon(Icons.audiotrack, size: 16, color: Theme.of(context).colorScheme.primary),
                        const SizedBox(width: AppSpacing.xs),
                        Text('Audio saved', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.primary)),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Tasks list
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _selectedTasks.length,
                itemBuilder: (context, index) {
                  final task = _selectedTasks[index];
                  return _buildTaskItem(task, index);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(onPressed: widget.onCancelled, child: Text(l10n.cancelButton)),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _selectedTasks.isEmpty ? null : _saveTasks,
                    child: _isSaving ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text('Save ${_selectedTasks.length} Task${_selectedTasks.length > 1 ? 's' : ''}'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskItem(ParsedTask task, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2)),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Slidable(
        key: ValueKey(task),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(onPressed: (_) => _toggleTaskSelection(index), backgroundColor: Colors.blue, foregroundColor: Colors.white, icon: _selectedTasks.contains(task) ? Icons.check_circle : Icons.check_circle_outline, label: _selectedTasks.contains(task) ? 'Selected' : 'Select'),
            SlidableAction(onPressed: (_) => _removeTask(index), backgroundColor: Colors.red, foregroundColor: Colors.white, icon: Icons.delete, label: 'Remove'),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and priority
              Row(
                children: [
                  Expanded(
                    child: Text(task.title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500)),
                  ),
                  _buildPriorityIndicator(task.priority),
                ],
              ),
              const SizedBox(height: AppSpacing.xs),

              // Date and time
              if (task.dueDate != null) ...[
                Row(
                  children: [
                    Icon(Icons.schedule, size: 16, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: AppSpacing.xs),
                    Text(_formatDate(task.dueDate!), style: Theme.of(context).textTheme.bodyMedium),
                    if (task.reminderDate != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(4)),
                        child: Text('🔔 ${_formatTime(task.reminderDate!)}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
              ],

              // Category
              if (task.categoryId != null) ...[
                Row(
                  children: [
                    Icon(Icons.label, size: 16, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: AppSpacing.xs),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(4)),
                      child: Text(task.categoryId!, style: TextStyle(color: Theme.of(context).colorScheme.onPrimaryContainer, fontSize: 12)),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityIndicator(TaskPriority priority) {
    Color color;
    String label;

    switch (priority) {
      case TaskPriority.high:
        color = Colors.red;
        label = 'High';
        break;
      case TaskPriority.medium:
        color = Colors.orange;
        label = 'Medium';
        break;
      case TaskPriority.low:
        color = Colors.green;
        label = 'Low';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
      ),
    );
  }

  void _toggleTaskSelection(int index) {
    setState(() {
      final task = widget.result.tasks[index];
      if (_selectedTasks.contains(task)) {
        _selectedTasks.remove(task);
      } else {
        _selectedTasks.add(task);
      }
    });
  }

  void _removeTask(int index) {
    setState(() {
      _selectedTasks.remove(widget.result.tasks[index]);
    });
  }

  Future<void> _saveTasks() async {
    setState(() {
      _isSaving = true;
    });

    try {
      for (final parsedTask in _selectedTasks) {
        final task = parsedTask.toTask();
        context.read<TaskListBloc>().add(AddTask(task));
      }

      // Wait a bit for the tasks to be processed
      await Future.delayed(const Duration(milliseconds: 500));

      widget.onCompleted?.call();
    } catch (e) {
      // Handle error
      setState(() {
        _isSaving = false;
      });
    }
  }

  Color _getConfidenceColor() {
    if (widget.result.confidence >= 0.9) {
      return Colors.green;
    } else if (widget.result.confidence >= 0.7) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  IconData _getConfidenceIcon() {
    if (widget.result.confidence >= 0.9) {
      return Icons.check_circle;
    } else if (widget.result.confidence >= 0.7) {
      return Icons.warning;
    } else {
      return Icons.error;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) {
      return 'Today';
    } else if (taskDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
