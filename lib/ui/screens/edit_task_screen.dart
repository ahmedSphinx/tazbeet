import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import '../../l10n/app_localizations.dart';
import '../../models/task.dart';
import '../../models/repeat_rule.dart';
import '../widgets/repeat_config_widget.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onTaskUpdated;

  const EditTaskScreen({super.key, required this.task, required this.onTaskUpdated});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TaskPriority selectedPriority;
  DateTime? selectedDueDate;
  RepeatRule? selectedRepeatRule;
  bool _showRepeatSettings = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description ?? '');
    selectedPriority = widget.task.priority;
    selectedDueDate = widget.task.dueDate;
    selectedRepeatRule = widget.task.repeatRule;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editTaskTitle),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
        actions: [TextButton(onPressed: _handleUpdateTask, child: Text(AppLocalizations.of(context)!.updateButton))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.taskTitleLabel,
                  hintText: AppLocalizations.of(context)!.taskTitleLabel,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                autofocus: true,
                inputFormatters: [LengthLimitingTextInputFormatter(100)],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.taskDescriptionLabel,
                  hintText: AppLocalizations.of(context)!.taskDescriptionLabel,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 3,
                inputFormatters: [LengthLimitingTextInputFormatter(500)],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<TaskPriority>(
                value: selectedPriority,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.priorityLabel,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: TaskPriority.values.map((priority) {
                  return DropdownMenuItem(
                    value: priority,
                    child: Text(
                      _getPriorityLabel(priority, context),
                      style: TextStyle(color: _getPriorityColor(priority), fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedPriority = value);
                  }
                },
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () async {
                  final pickedDate = await showDatePicker(context: context, initialDate: selectedDueDate ?? DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));
                  if (pickedDate != null) {
                    setState(() => selectedDueDate = pickedDate);
                  }
                },
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.dueDateLabel,
                    suffixIcon: const Icon(Icons.calendar_today),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    selectedDueDate != null ? '${selectedDueDate!.day}/${selectedDueDate!.month}/${selectedDueDate!.year}' : AppLocalizations.of(context)!.selectDueDate,
                    style: TextStyle(color: selectedDueDate != null ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                  ),
                ),
              ),

              // Subtasks Section
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtasks (${widget.task.subtasks.length})', style: Theme.of(context).textTheme.titleMedium),
                  TextButton.icon(onPressed: () => _showAddSubtaskDialog(), icon: const Icon(Icons.add), label: Text(AppLocalizations.of(context)!.addSubtask)),
                ],
              ),
              if (widget.task.subtasks.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.task.subtasks.length,
                    itemBuilder: (context, index) {
                      final subtask = widget.task.subtasks[index];
                      return ListTile(
                        leading: Checkbox(
                          value: subtask.isCompleted,
                          onChanged: (value) {
                            _toggleSubtaskCompletion(index, value ?? false);
                          },
                        ),
                        title: Text(subtask.title, style: TextStyle(decoration: subtask.isCompleted ? TextDecoration.lineThrough : null)),
                        trailing: IconButton(icon: const Icon(Icons.delete, size: 20), onPressed: () => _deleteSubtask(index)),
                        dense: true,
                      );
                    },
                  ),
                ),
              ],

              // Repeat Settings Section
              if (selectedRepeatRule != null || _showRepeatSettings) ...[
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(AppLocalizations.of(context)!.repeatSettings, style: Theme.of(context).textTheme.titleMedium),
                    IconButton(
                      onPressed: () => setState(() {
                        _showRepeatSettings = !_showRepeatSettings;
                      }),
                      icon: Icon(_showRepeatSettings ? Icons.expand_less : Icons.expand_more),
                    ),
                  ],
                ),
                if (_showRepeatSettings) ...[
                  const SizedBox(height: 16),
                  RepeatConfigWidget(
                    initialRepeatRule: selectedRepeatRule,
                    onRepeatRuleChanged: (repeatRule) {
                      setState(() {
                        selectedRepeatRule = repeatRule;
                      });
                    },
                  ),
                ],
              ],

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddSubtaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => _AddSubtaskDialog(
        parentTask: widget.task,
        onSubtaskAdded: (subtask) {
          setState(() {
            widget.task.subtasks.add(subtask);
          });
        },
      ),
    );
  }

  void _toggleSubtaskCompletion(int index, bool isCompleted) {
    setState(() {
      widget.task.subtasks[index] = widget.task.subtasks[index].copyWith(isCompleted: isCompleted, updatedAt: DateTime.now());
    });
  }

  void _deleteSubtask(int index) {
    setState(() {
      widget.task.subtasks.removeAt(index);
    });
  }

  void _handleUpdateTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.nameRequired), backgroundColor: Colors.red));
      return;
    }

    final updatedTask = widget.task.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      priority: selectedPriority,
      dueDate: selectedDueDate,
      repeatRule: selectedRepeatRule,
      updatedAt: DateTime.now(),
    );

    widget.onTaskUpdated(updatedTask);
    Navigator.of(context).pop();
  }

  String _getPriorityLabel(TaskPriority priority, BuildContext context) {
    switch (priority) {
      case TaskPriority.high:
        return AppLocalizations.of(context)!.highPriorityLabel;
      case TaskPriority.medium:
        return AppLocalizations.of(context)!.mediumPriorityLabel;
      case TaskPriority.low:
        return AppLocalizations.of(context)!.lowPriorityLabel;
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }
}

class _AddSubtaskDialog extends StatefulWidget {
  final Task parentTask;
  final Function(Task) onSubtaskAdded;

  const _AddSubtaskDialog({required this.parentTask, required this.onSubtaskAdded});

  @override
  State<_AddSubtaskDialog> createState() => _AddSubtaskDialogState();
}

class _AddSubtaskDialogState extends State<_AddSubtaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Add Subtask', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Subtask Title',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Description (optional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _saveSubtask, child: const Text('Add')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveSubtask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please enter a subtask title')));
      return;
    }

    final now = DateTime.now();
    final subtask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      isCompleted: false,
      parentId: widget.parentTask.id,
      maxSubtaskDepth: widget.parentTask.maxSubtaskDepth,
      strictCompletionMode: widget.parentTask.strictCompletionMode,
      createdAt: now,
      updatedAt: now,
    );

    widget.onSubtaskAdded(subtask);
    Navigator.of(context).pop();
  }
}
