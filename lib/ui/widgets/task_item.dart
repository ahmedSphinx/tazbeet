import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/task.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_state.dart';
import '../../utils/date_formatter.dart';
import 'priority_indicator.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
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
                  child: Icon(
                    task.isCompleted ? Icons.undo : Icons.check,
                    key: ValueKey(task.isCompleted),
                    size: 28,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  task.isCompleted ? 'Mark Incomplete' : 'Complete',
                  style: const TextStyle(fontSize: 12),
                ),
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
            foregroundColor: Colors.white,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.edit, size: 28),
                SizedBox(height: 4),
                Text('Edit', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          CustomSlidableAction(
            onPressed: (_) => onDelete(),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete, size: 28),
                SizedBox(height: 4),
                Text('Delete', style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: task.isCompleted
              ? Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.surface,
          boxShadow: task.isCompleted
              ? []
              : [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: ListTile(
          leading: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            transform: Matrix4.identity()..scale(task.isCompleted ? 1.1 : 1.0),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: task.isCompleted ? 0.7 : 1.0,
              child: Checkbox(
                value: task.isCompleted,
                onChanged: (_) => onToggle(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                activeColor: Colors.green,
                checkColor: Colors.white,
              ),
            ),
          ),
          title: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            style: TextStyle(
              decoration: task.isCompleted
                  ? TextDecoration.lineThrough
                  : TextDecoration.none,
              color: task.isCompleted
                  ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: task.isCompleted ? FontWeight.normal : FontWeight.w500,
            ),
            child: Text(task.title),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (task.description != null)
                Text(
                  task.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface.withAlpha(180),
                  ),
                ),
              if (task.dueDate != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    DateFormatter.formatDate(task.dueDate!),
                    style: TextStyle(
                      color: DateFormatter.isOverdue(task.dueDate!)
                          ? Colors.redAccent
                          : Theme.of(context).colorScheme.onSurface.withAlpha(160),
                      fontWeight: DateFormatter.isOverdue(task.dueDate!)
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                ),
              if (task.categoryId != null)
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoryLoaded) {
                      final category = state.categories
                          .where((cat) => cat.id == task.categoryId)
                          .firstOrNull;
                      if (category != null) {
                        return Row(
                          children: [
                            Icon(
                              Icons.folder,
                              size: 14,
                              color: category.color,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              category.name,
                              style: TextStyle(
                                fontSize: 12,
                                color: category.color,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        );
                      }
                    }
                    return const SizedBox.shrink();
                  },
                ),
            ],
          ),
          trailing: PriorityIndicator(priority: task.priority),
          onTap: onToggle,
        ),
      ),
    );
  }


}
