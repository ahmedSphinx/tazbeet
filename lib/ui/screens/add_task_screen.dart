import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/category/category_bloc.dart';
import '../../l10n/app_localizations.dart';
import '../../models/task.dart';
import '../../models/repeat_rule.dart';
import '../../models/pomodoro_plan.dart';
import '../../services/pomodoro_planner_service.dart';
import '../design_system/ds_typography.dart';
import '../design_system/ds_spacing.dart';
import '../design_system/ds_border_radius.dart';
import '../design_system/ds_colors.dart';
import '../design_system/ds_components.dart';
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

  // Pomodoro Planning State
  final PomodoroPlannerService _plannerService = PomodoroPlannerService();
  PomodoroPlan? suggestedPomodoroPlan;
  int focusScore = 5; // 1-10 scale
  bool enablePomodoroOptimization = true;
  bool _showPomodoroSettings = false;

  @override
  void initState() {
    super.initState();
    // Add listener to update pomodoro plan when title changes
    _titleController.addListener(_onTitleChanged);
  }

  void _onTitleChanged() {
    if (enablePomodoroOptimization) {
      _updatePomodoroPlan();
    }
  }

  @override
  void dispose() {
    _titleController.removeListener(_onTitleChanged);
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.addTaskTitle,
          style: DSTypography.title(context).copyWith(color: colorScheme.primary, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop(), tooltip: MaterialLocalizations.of(context).closeButtonTooltip),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: DSSpacing.sm),
            child: TextButton(
              onPressed: _handleAddTask,
              style: TextButton.styleFrom(
                foregroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md),
              ),
              child: Text(
                AppLocalizations.of(context)!.addTaskButton.toUpperCase(),
                style: DSTypography.subtitle(context).copyWith(color: Colors.green, fontWeight: FontWeight.bold, letterSpacing: 1.1),
              ),
            ),
          ),
        ],
        elevation: 0,
        backgroundColor: colorScheme.surface,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // SECTION 1: BASIC INFO
                _buildFormSection(
                  column: [
                    TextField(
                      controller: _titleController,
                      style: DSTypography.headline(context),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.taskTitleLabel,
                        hintText: AppLocalizations.of(context)!.taskTitleLabel,
                        labelStyle: TextStyle(color: colorScheme.primary),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: DSBorderRadius.mdRadius,
                          borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: DSBorderRadius.mdRadius,
                          borderSide: BorderSide(color: colorScheme.primary, width: 2),
                        ),
                        contentPadding: const EdgeInsets.all(DSSpacing.md),
                      ),
                      autofocus: true,
                      inputFormatters: [LengthLimitingTextInputFormatter(100)],
                    ),
                    const SizedBox(height: DSSpacing.lg),
                    TextField(
                      controller: _descriptionController,
                      style: DSTypography.body(context),
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.taskDescriptionLabel,
                        hintText: AppLocalizations.of(context)!.taskDescriptionLabel,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        border: OutlineInputBorder(
                          borderRadius: DSBorderRadius.mdRadius,
                          borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.5)),
                        ),
                        contentPadding: const EdgeInsets.all(DSSpacing.md),
                      ),
                      maxLines: 3,
                      inputFormatters: [LengthLimitingTextInputFormatter(500)],
                    ),
                  ],
                ),

                const SizedBox(height: DSSpacing.lg),

                // SECTION 2: TASK DETAILS
                DSSectionHeader(title: AppLocalizations.of(context)!.details, icon: Icons.tune),
                _buildFormSection(
                  column: [
                    DropdownButtonFormField<TaskPriority>(
                      value: selectedPriority,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.priority,
                        border: OutlineInputBorder(borderRadius: DSBorderRadius.mdRadius),
                        prefixIcon: Icon(Icons.priority_high, color: _getPriorityColor(selectedPriority)),
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
                          HapticFeedback.lightImpact();
                          setState(() => selectedPriority = value);
                        }
                      },
                    ),
                    const SizedBox(height: DSSpacing.md),
                    InkWell(
                      onTap: () async {
                        HapticFeedback.mediumImpact();
                        final pickedDate = await showDatePicker(context: context, initialDate: selectedDueDate ?? DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime.now().add(const Duration(days: 365)));

                        if (pickedDate != null && context.mounted) {
                          // For today, ensure time is at least 1 minute in the future
                          final now = DateTime.now();
                          final initialTime = (pickedDate.year == now.year && pickedDate.month == now.month && pickedDate.day == now.day)
                              ? TimeOfDay.fromDateTime(now.add(const Duration(minutes: 1)))
                              : TimeOfDay.fromDateTime(selectedDueDate ?? DateTime.now());

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
                          prefixIcon: const Icon(Icons.calendar_today),
                          border: OutlineInputBorder(borderRadius: DSBorderRadius.mdRadius),
                        ),
                        child: Text(
                          selectedDueDate != null
                              ? '${selectedDueDate!.day}/${selectedDueDate!.month}/${selectedDueDate!.year} - ${((selectedDueDate!.hour % 12) == 0 ? 12 : (selectedDueDate!.hour % 12))}:${selectedDueDate!.minute.toString().padLeft(2, '0')} ${selectedDueDate!.hour >= 12 ? 'PM' : 'AM'}'
                              : AppLocalizations.of(context)!.selectDueDate,
                          style: TextStyle(
                            color: selectedDueDate != null ? colorScheme.onSurface : colorScheme.onSurface.withValues(alpha: 0.6),
                            fontWeight: selectedDueDate != null ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: DSSpacing.md),
                    if (state is CategoryLoaded && state.categories.isNotEmpty)
                      DropdownButtonFormField<String?>(
                        value: selectedCategoryId,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.categoryLabel,
                          prefixIcon: const Icon(Icons.folder_outlined),
                          border: OutlineInputBorder(borderRadius: DSBorderRadius.mdRadius),
                        ),
                        items: [
                          DropdownMenuItem<String?>(value: null, child: Text(AppLocalizations.of(context)!.noCategory)),
                          ...state.categories.map((category) => DropdownMenuItem<String?>(value: category.id, child: Text(category.name))),
                        ],
                        onChanged: (value) {
                          selectedCategoryId = value;
                        },
                      ),
                  ],
                ),

                const SizedBox(height: DSSpacing.lg),

                // SECTION 3: REPEAT SETTINGS
                DSSectionHeader(
                  title: AppLocalizations.of(context)!.repeatSettings,
                  icon: Icons.repeat,
                  actionIcon: _showRepeatSettings ? Icons.expand_less : Icons.expand_more,
                  onActionTap: () => setState(() => _showRepeatSettings = !_showRepeatSettings),
                ),
                if (_showRepeatSettings)
                  _buildFormSection(
                    column: [
                      RepeatConfigWidget(
                        initialRepeatRule: selectedRepeatRule,
                        onRepeatRuleChanged: (repeatRule) {
                          setState(() {
                            selectedRepeatRule = repeatRule;
                          });
                        },
                      ),
                    ],
                  ),

                const SizedBox(height: DSSpacing.lg),

                // SECTION 4: POMODORO PLANNING
                DSSectionHeader(
                  title: AppLocalizations.of(context)!.pomodoroPlanning,
                  icon: Icons.timer,
                  actionIcon: _showPomodoroSettings ? Icons.expand_less : Icons.expand_more,
                  onActionTap: () => setState(() => _showPomodoroSettings = !_showPomodoroSettings),
                ),
                if (_showPomodoroSettings)
                  _buildFormSection(
                    column: [
                      SwitchListTile(
                        title: Text(AppLocalizations.of(context)!.enablePomodoroOptimization, style: DSTypography.body(context).copyWith(fontWeight: FontWeight.bold)),
                        subtitle: Text(AppLocalizations.of(context)!.automaticallyPlanWorkSessions),
                        value: enablePomodoroOptimization,
                        activeColor: colorScheme.primary,
                        onChanged: (value) {
                          setState(() {
                            enablePomodoroOptimization = value;
                            if (value && _titleController.text.isNotEmpty) {
                              _updatePomodoroPlan();
                            }
                          });
                        },
                      ),
                      if (enablePomodoroOptimization) ...[
                        const Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: DSSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(AppLocalizations.of(context)!.focusDifficulty(focusScore), style: DSTypography.subtitle(context)),
                              const SizedBox(height: DSSpacing.xs),
                              Slider(
                                value: focusScore.toDouble(),
                                min: 1,
                                max: 10,
                                divisions: 9,
                                label: '$focusScore',
                                activeColor: colorScheme.primary,
                                inactiveColor: colorScheme.primary.withValues(alpha: 0.2),
                                onChanged: (value) {
                                  setState(() {
                                    focusScore = value.round();
                                    _updatePomodoroPlan();
                                  });
                                },
                              ),
                              Text(AppLocalizations.of(context)!.easyFocusDeepFocusRequired, style: DSTypography.caption(context).copyWith(color: colorScheme.onSurface.withValues(alpha: 0.6))),
                            ],
                          ),
                        ),
                        if (suggestedPomodoroPlan != null) _buildPomodoroPlanPreview(context),
                      ],
                    ],
                  ),
                const SizedBox(height: DSSpacing.xl * 2),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFormSection({required List<Widget> column}) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: DSBorderRadius.lgRadius,
        side: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(DSSpacing.md),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: column),
      ),
    );
  }

  Widget _buildPomodoroPlanPreview(BuildContext context) {
    if (suggestedPomodoroPlan == null) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.only(top: DSSpacing.md),
      padding: const EdgeInsets.all(DSSpacing.md),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [colorScheme.primaryContainer.withValues(alpha: 0.7), colorScheme.primaryContainer.withValues(alpha: 0.4)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: DSBorderRadius.mdRadius,
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.auto_awesome, size: 18, color: colorScheme.primary),
              const SizedBox(width: DSSpacing.sm),
              Text(
                AppLocalizations.of(context)!.suggestedPlan,
                style: DSTypography.body(context).copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: DSSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPlanStat(context, Icons.repeat, suggestedPomodoroPlan!.totalSessions.toString(), AppLocalizations.of(context)!.workSessions),
              _buildPlanStat(context, Icons.timer_outlined, suggestedPomodoroPlan!.workDuration.toString(), AppLocalizations.of(context)!.minPerSession),
              _buildPlanStat(context, Icons.schedule, (suggestedPomodoroPlan!.totalSessions * suggestedPomodoroPlan!.workDuration).toString(), AppLocalizations.of(context)!.minsTotal),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlanStat(BuildContext context, IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.7)),
        const SizedBox(height: 4),
        Text(value, style: DSTypography.headline(context).copyWith(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: DSTypography.caption(context), textAlign: TextAlign.center),
      ],
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

    // Create pomodoro plan if optimization is enabled
    PomodoroPlan? pomodoroPlan;
    if (enablePomodoroOptimization) {
      final tempTask = Task(
        id: newId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
        priority: selectedPriority,
        focusScore: focusScore,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      pomodoroPlan = _plannerService.createOptimalPlan(tempTask);
    }

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
      // Enhanced pomodoro fields
      focusScore: focusScore,
      isPomodoroOptimized: enablePomodoroOptimization,
      pomodoroPlan: pomodoroPlan,
      estimatedDuration: pomodoroPlan != null ? Duration(minutes: pomodoroPlan.totalSessions * pomodoroPlan.workDuration) : const Duration(minutes: 25),
    );

    widget.onTaskAdded(task);
    Navigator.of(context).pop();
  }

  void _updatePomodoroPlan() {
    if (_titleController.text.trim().isEmpty) {
      setState(() {
        suggestedPomodoroPlan = null;
      });
      return;
    }

    final tempTask = Task(
      id: 'temp',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty ? null : _descriptionController.text.trim(),
      priority: selectedPriority,
      focusScore: focusScore,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    setState(() {
      suggestedPomodoroPlan = _plannerService.createOptimalPlan(tempTask);
    });
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
    return DSColors.getPriorityColor(priority, Theme.of(context).brightness == Brightness.dark);
  }
}
