import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/category/category_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import '../../blocs/category/category_bloc.dart';

import '../../models/task.dart';
import '../../models/repeat_rule.dart';
import 'repeat_config_widget.dart';

class AddTaskDialog extends StatefulWidget {
  final Function(Task) onTaskAdded;
  final bool isSubtask;

  const AddTaskDialog({super.key, required this.onTaskAdded, this.isSubtask = false});

  @override
  State<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends State<AddTaskDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String? selectedCategoryId;
  TaskPriority selectedPriority = TaskPriority.medium;
  DateTime? selectedDueDate;
  RepeatRule? selectedRepeatRule;
  bool _showRepeatSettings = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),

          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8, // Limit height to 80% of screen
            ),
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.isSubtask ? AppLocalizations.of(context)!.addSubtask : AppLocalizations.of(context)!.addTaskTitle, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 24),
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
                  if (!widget.isSubtask) ...[
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
                  ],
                  if (!widget.isSubtask) ...[
                    const SizedBox(height: 16),

                    InkWell(
                      onTap: () async {
                        final pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));

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

                    const SizedBox(height: 16),
                  ],
                  if (!widget.isSubtask)
                    if (state is CategoryLoaded && state.categories.isNotEmpty)
                      DropdownButtonFormField<String?>(
                        value: selectedCategoryId,
                        decoration: InputDecoration(labelText: AppLocalizations.of(context)!.categoryLabel),
                        items: [
                          DropdownMenuItem<String?>(value: null, child: Text(AppLocalizations.of(context)!.noCategory)),
                          ...state.categories.map((category) => DropdownMenuItem<String?>(value: category.id, child: Text(category.name))),
                        ],
                        onChanged: (value) {
                          selectedCategoryId = value;
                        },
                      ),

                  // Repeat Settings Section
                  const SizedBox(height: 16),
                  if (!widget.isSubtask) const Divider(),
                  if (!widget.isSubtask) const SizedBox(height: 16),
                  if (!widget.isSubtask)
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

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(AppLocalizations.of(context)!.cancelButton)),
                      const SizedBox(width: 8),
                      ElevatedButton(onPressed: _handleAddTask, child: Text(AppLocalizations.of(context)!.addTaskButton)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _handleAddTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.nameRequired), backgroundColor: Colors.red));
      return;
    }

    final task = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      priority: selectedPriority,
      dueDate: selectedDueDate,
      categoryId: selectedCategoryId,
      repeatRule: selectedRepeatRule,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    widget.onTaskAdded(task);
    if (!widget.isSubtask) {
      Navigator.of(context).pop();
    }
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
