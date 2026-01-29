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
  late List<Task> _subtasks; // Local copy of subtasks to avoid mutating original

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task.title);
    _descriptionController = TextEditingController(text: widget.task.description ?? '');
    selectedPriority = widget.task.priority;
    selectedDueDate = widget.task.dueDate;
    selectedRepeatRule = widget.task.repeatRule;
    _subtasks = List.from(widget.task.subtasks); // Create a local copy
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
               // autofocus: false, // Prevent keyboard auto-opening
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
                  labelText: AppLocalizations.of(context)!.priority,
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
                    // For today, ensure time is at least 1 minute in the future
                    final now = DateTime.now();
                    final initialTime = (pickedDate.year == now.year && pickedDate.month == now.month && pickedDate.day == now.day) ? TimeOfDay.fromDateTime(now.add(const Duration(minutes: 1))) : TimeOfDay.fromDateTime(pickedDate);

                    final pickedTime = await showTimePicker(context: context, initialTime: initialTime);

                    if (pickedTime != null) {
                      final finalDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
                      // Ensure the final datetime is not in the past
                      if (finalDateTime.isBefore(DateTime.now().subtract(const Duration(minutes: 1)))) {
                        setState(() => selectedDueDate = DateTime.now().add(const Duration(minutes: 1)));
                      } else {
                        setState(() => selectedDueDate = finalDateTime);
                      }
                    } else {
                      setState(() => selectedDueDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day));
                    }
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
                  Text('${AppLocalizations.of(context)!.subtasks} (${_subtasks.length})', style: Theme.of(context).textTheme.titleMedium),
                  TextButton.icon(onPressed: () => _showAddSubtaskDialog(), icon: const Icon(Icons.add), label: Text(AppLocalizations.of(context)!.addSubtask)),
                ],
              ),
              if (_subtasks.isNotEmpty) ...[
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _subtasks.length,
                    itemBuilder: (context, index) {
                      final subtask = _subtasks[index];
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
            _subtasks.add(subtask);
          });
        },
      ),
    );
  }

  void _toggleSubtaskCompletion(int index, bool isCompleted) {
    setState(() {
      _subtasks[index] = _subtasks[index].copyWith(isCompleted: isCompleted, updatedAt: DateTime.now());
    });
  }

  void _deleteSubtask(int index) {
    setState(() {
      _subtasks.removeAt(index);
    });
  }

  void _handleUpdateTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.nameRequired), backgroundColor: Colors.red));
      return;
    }

    final updatedTask = widget.task.copyWith(title: _titleController.text.trim(), description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(), priority: selectedPriority, dueDate: selectedDueDate, repeatRule: selectedRepeatRule, subtasks: _subtasks, updatedAt: DateTime.now());

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
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.addSubtask, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: l10n.taskTitleLabel,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              autofocus: true, // User-initiated dialog should focus for good UX
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: l10n.taskDescriptionLabel,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancelButton)),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _saveSubtask, child: Text(l10n.addTaskButton)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _saveSubtask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.nameRequired)));
      return;
    }

    final now = DateTime.now();
    // Use timestamp + microseconds + hash to avoid ID collisions
    final newId = '${now.millisecondsSinceEpoch}_${now.microsecond}_${widget.parentTask.id.hashCode.abs() % 10000}';
    final subtask = Task(
      id: newId,
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
