import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/category/category_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../models/task.dart';
import '../../models/repeat_rule.dart';
import '../design_system/ds_typography.dart';
import '../widgets/repeat_config_widget.dart';

class AddTaskScreen extends StatefulWidget {
  final Function(Task) onTaskAdded;

  const AddTaskScreen({super.key, required this.onTaskAdded});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addTaskTitle, style: DSTypography.title(context).copyWith(color: Theme.of(context).colorScheme.primary)),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
        actions: [
          TextButton.icon(
            onPressed: _handleAddTask,
            icon: Icon(Icons.add_circle, color: Colors.green),
            label: Text(AppLocalizations.of(context)!.addTaskButton, style: DSTypography.subtitle(context).copyWith(color: Colors.green, fontSize: 13)),
          ),
        ],
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
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
                      final pickedDate = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));

                      if (pickedDate != null) {
                        final pickedTime = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(pickedDate));

                        if (pickedTime != null) {
                          setState(() => selectedDueDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute));
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
                        selectedDueDate != null
                            ? '${selectedDueDate!.day}/${selectedDueDate!.month}/${selectedDueDate!.year} - ${((selectedDueDate!.hour % 12) == 0 ? 12 : (selectedDueDate!.hour % 12))}:${selectedDueDate!.minute.toString().padLeft(2, '0')} ${selectedDueDate!.hour >= 12 ? 'PM' : 'AM'}'
                            : AppLocalizations.of(context)!.selectDueDate,
                        style: TextStyle(color: selectedDueDate != null ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

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

                  const SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleAddTask() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.nameRequired), backgroundColor: Colors.red));
      return;
    }

    final now = DateTime.now();
    // Use timestamp + microseconds + random to avoid ID collisions
    final newId = '${now.millisecondsSinceEpoch}_${now.microsecond}_${now.hashCode.abs() % 10000}';
    final task = Task(
      id: newId,
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
