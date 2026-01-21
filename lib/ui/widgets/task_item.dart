import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:confetti/confetti.dart';
import '../../l10n/app_localizations.dart';
import '../../models/task.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_state.dart';
import '../../utils/date_formatter.dart';
import 'priority_indicator.dart';
import '../themes/design_system.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback? onTap;
  final VoidCallback? onLongTap;
  final bool batchSelectionMode;
  final Function(String)? onTaskSelected;
  final bool selected;
  final VoidCallback? onStartPomodoro;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    this.onTap,
    this.onLongTap,
    this.batchSelectionMode = false,
    this.onTaskSelected,
    this.selected = false,
    this.onStartPomodoro,
  });

  double _calculateProgress() {
    if (task.subtasks.isEmpty) return task.isCompleted ? 1.0 : 0.0;
    int total = 0;
    int completed = 0;
    void count(Task t) {
      total++;
      if (t.isCompleted) completed++;
      for (var s in t.subtasks) {
        count(s);
      }
    }

    for (var s in task.subtasks) {
      count(s);
    }
    return total > 0 ? completed / total : 0.0;
  }

  void _handleToggle(BuildContext context) {
    onToggle();
    HapticFeedback.mediumImpact();
    if (!task.isCompleted) {
      // Show confetti when marking as completed
      final controller = ConfettiController(duration: const Duration(milliseconds: 600));
      controller.play();
      showDialog(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => Stack(
          children: [
            Center(
              child: ConfettiWidget(
                confettiController: controller,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: [Colors.green, Colors.blue, Colors.orange],
                numberOfParticles: 20,
                maxBlastForce: 20,
                minBlastForce: 8,
                emissionFrequency: 0.1,
                gravity: 0.2,
              ),
            ),
          ],
        ),
      );
      Future.delayed(const Duration(milliseconds: 700), () {
        controller.stop();
        if (Navigator.of(context, rootNavigator: true).canPop()) {
          Navigator.of(context, rootNavigator: true).pop();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();
    return Hero(
      tag: 'task-${task.id}',
      child: Semantics(
        label: 'Task: ${task.title}',
        hint: task.isCompleted ? 'Completed task, swipe to mark incomplete' : 'Incomplete task, swipe to mark complete',
        child: Slidable(
          startActionPane: ActionPane(
            motion: const BehindMotion(),
            children: [
              CustomSlidableAction(
                onPressed: (_) => onToggle(),
                backgroundColor: task.isCompleted ? Colors.orange : Colors.green,
                foregroundColor: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(task.isCompleted ? Icons.undo : Icons.check, key: ValueKey(task.isCompleted), size: 28),
                    ),
                    const SizedBox(height: 4),
                    Text(task.isCompleted ? 'Mark Incomplete' : AppLocalizations.of(context)!.completedLabel, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          endActionPane: ActionPane(
            motion: const BehindMotion(),
            children: [
              CustomSlidableAction(
                onPressed: (_) => onEdit(),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white, // L10n: Methods can't be invoked in constant expressions.
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // L10n: Methods can't be invoked in constant expressions.
                  children: [
                    const Icon(Icons.edit, size: 28),
                    const SizedBox(height: 4),
                    Text(AppLocalizations.of(context)!.editButton, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
              CustomSlidableAction(
                onPressed: (_) => onDelete(),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white, // L10n: Methods can't be invoked in constant expressions.
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.delete, size: 28),
                    const SizedBox(height: 4),
                    Text(AppLocalizations.of(context)!.deleteButton, style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          child: Stack(
            children: [
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: batchSelectionMode ? 0.6 : 1.0,
                child: ListTile(
                  leading: Tooltip(
                    message: task.isCompleted ? 'Mark as incomplete' : 'Mark as complete',
                    child: AnimatedContainer(
                      duration: AppAnimations.normal,
                      curve: AppAnimations.standard,
                      transform: Matrix4.identity()..scale(task.isCompleted ? 1.1 : 1.0),
                      child: AnimatedOpacity(
                        duration: AppAnimations.fast,
                        opacity: task.isCompleted ? 0.7 : 1.0,
                        child: SizedBox(
                          width: AppSizes.touchTarget,
                          height: AppSizes.touchTarget,
                          child: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) => _handleToggle(context),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xs)),
                            activeColor: AppColors.completed,
                            checkColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  title: AnimatedDefaultTextStyle(
                    duration: AppAnimations.normal,
                    curve: AppAnimations.standard,
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      decoration: task.isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                      color: task.isCompleted ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6) : Theme.of(context).colorScheme.onSurface,
                      fontWeight: task.isCompleted ? FontWeight.normal : FontWeight.w500,
                    ),
                    child: Text(task.title),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (task.description != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                          child: Text(
                            task.description!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.bodySmall.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7)),
                          ),
                        ),
                      if (task.dueDate != null)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(
                            DateFormatter.formatDate(task.dueDate!, context),
                            style: context.bodySmall.copyWith(
                              color: DateFormatter.isOverdue(task.dueDate!) ? AppColors.overdue : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.63),
                              fontWeight: DateFormatter.isOverdue(task.dueDate!) ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      if (task.categoryId != null)
                        Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.xs),
                          child: BlocBuilder<CategoryBloc, CategoryState>(
                            builder: (context, state) {
                              if (state is CategoryLoaded) {
                                final category = state.categories.where((cat) => cat.id == task.categoryId).firstOrNull;
                                if (category != null) {
                                  return Row(
                                    children: [
                                      Icon(Icons.folder, size: AppSizes.iconSmall, color: category.color),
                                      const SizedBox(width: AppSpacing.xs),
                                      Text(
                                        category.name,
                                        style: context.bodySmall.copyWith(color: category.color, fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  );
                                }
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ),
                      if (task.subtasks.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        LinearProgressIndicator(value: progress, backgroundColor: Colors.red.withValues(alpha: 0.2), valueColor: AlwaysStoppedAnimation<Color>(progress == 1.0 ? Colors.green : Colors.blue)),
                        const SizedBox(height: 4),
                        Text('${(progress * 100).round()}% ${AppLocalizations.of(context)!.completedLabel}', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                      // Pomodoro integration indicators
                      if (task.pomodoroCount > 0) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.timer_outlined, size: 14, color: Colors.blue[600]),
                            const SizedBox(width: 4),
                            Text(
                              '${task.pomodoroCount} sessions',
                              style: TextStyle(fontSize: 11, color: Colors.blue[600], fontWeight: FontWeight.w500),
                            ),
                            if (task.estimatedSessions > 0) ...[const SizedBox(width: 8), Text('/ ${task.estimatedSessions} est.', style: TextStyle(fontSize: 11, color: Colors.grey[600]))],
                            if (task.timeSpent.inMinutes > 0) ...[const SizedBox(width: 8), Text('• ${task.timeSpent.inMinutes}min', style: TextStyle(fontSize: 11, color: Colors.grey[600]))],
                          ],
                        ),
                        // Pomodoro progress bar
                        if (task.estimatedSessions > 0) ...[
                          const SizedBox(height: 4),
                          LinearProgressIndicator(
                            value: (task.pomodoroCount / task.estimatedSessions).clamp(0.0, 1.0),
                            backgroundColor: Colors.blue.withValues(alpha: 0.2),
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue.shade600),
                            minHeight: 3,
                          ),
                        ],
                      ],
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Pomodoro quick action button
                      if (onStartPomodoro != null)
                        Tooltip(
                          message: 'Start Pomodoro session',
                          child: IconButton(
                            icon: Icon(Icons.timer_outlined, size: 20, color: task.pomodoroCount > 0 ? Colors.blue[600] : Colors.grey[600]),
                            onPressed: onStartPomodoro,
                            visualDensity: VisualDensity.compact,
                          ),
                        ),
                      // Priority indicator
                      Tooltip(
                        message: 'Priority: ${task.priority.name}',
                        child: PriorityIndicator(priority: task.priority),
                      ),
                    ],
                  ),
                  onTap: batchSelectionMode ? () => onTaskSelected?.call(task.id) : (onTap ?? () => _handleToggle(context)),
                  onLongPress: batchSelectionMode ? () => onTaskSelected?.call(task.id) : (onLongTap ?? () => _handleToggle(context)),
                ),
              ),
              if (batchSelectionMode)
                Positioned(
                  left: 8,
                  top: 8,
                  child: Checkbox(
                    value: selected,
                    onChanged: (_) => onTaskSelected?.call(task.id),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
