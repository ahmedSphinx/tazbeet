import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  const TaskItem({super.key, required this.task, required this.onToggle, required this.onEdit, required this.onDelete, this.onTap, this.onLongTap});

  double _calculateProgress() {
    if (task.subtasks.isEmpty) return task.isCompleted ? 1.0 : 0.0;
    int total = 0;
    int completed = 0;
    void count(Task t) {
      total++;
      if (t.isCompleted) completed++;
      for (var s in t.subtasks) count(s);
    }

    for (var s in task.subtasks) count(s);
    return total > 0 ? completed / total : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final progress = _calculateProgress();
    return Slidable(
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
      child: AnimatedContainer(
        duration: AppAnimations.normal,
        curve: AppAnimations.standard,
        margin: const EdgeInsets.only(bottom: AppSpacing.cardSpacing),
        decoration: task.isCompleted ? AppCardStyles.standard(context).copyWith(color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)) : AppCardStyles.standard(context),
        child: ListTile(
          leading: AnimatedContainer(
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
                  onChanged: (_) => onToggle(),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.xs)),
                  activeColor: AppColors.completed,
                  checkColor: Colors.white,
                ),
              ),
            ),
          ),
          title: AnimatedDefaultTextStyle(
            duration: AppAnimations.normal,
            curve: AppAnimations.standard,
            style: context.titleMedium.copyWith(
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
                    DateFormatter.formatDate(task.dueDate!),
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
                Text('${(progress * 100).round()}% complete', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ],
          ),
          trailing: PriorityIndicator(priority: task.priority),
          onTap: onTap ?? onToggle,
          onLongPress: onLongTap ?? onToggle,
        ),
      ),
    );
  }
}
