import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/repositories/task_repository.dart';
import '../../blocs/task_details/task_details_bloc.dart';
import '../../blocs/task_details/task_details_event.dart';
import '../../services/app_logging_service.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/edit_task_dialog.dart';
import 'task_details_screen.dart';

class SubtaskDetailsScreen extends StatefulWidget {
  final Task subtask;
  final Task? parentTask;

  const SubtaskDetailsScreen({super.key, required this.subtask, this.parentTask});

  @override
  State<SubtaskDetailsScreen> createState() => _SubtaskDetailsScreenState();
}

class _SubtaskDetailsScreenState extends State<SubtaskDetailsScreen> {
  late Task _currentSubtask;
  late Task? _parentTask;
  bool _hasChanges = false; // Track if any changes were made

  @override
  void initState() {
    super.initState();
    _currentSubtask = widget.subtask;
    _parentTask = widget.parentTask;

    AppLogging.logInfo('SubtaskDetailsScreen: Opened for subtask "${_currentSubtask.title}"', name: 'SubtaskNavigation');
    if (_parentTask != null) {
      AppLogging.logInfo('SubtaskDetailsScreen: Parent task "${_parentTask!.title}"', name: 'SubtaskNavigation');
    }
  }

  @override
  void dispose() {
    // Trigger parent refresh when leaving subtask details if changes were made
    _triggerParentRefresh();
    super.dispose();
  }

  void _triggerParentRefresh() {
    if (_parentTask != null && _hasChanges) {
      AppLogging.logInfo('SubtaskDetailsScreen: Triggering parent task refresh due to subtask changes', name: 'SubtaskNavigation');

      // Use a post-frame callback to ensure the navigation completes before triggering refresh
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          // Find and refresh the parent TaskDetailsScreen
          final parentContext = _parentTask!.id.isNotEmpty ? _findParentTaskDetailsContext() : null;
          if (parentContext != null) {
            // Trigger refresh in parent screen
            final bloc = parentContext.read<TaskDetailsBloc>();
            bloc.add(LoadTaskDetails(_parentTask!.id));
            AppLogging.logInfo('SubtaskDetailsScreen: Parent task refresh triggered successfully', name: 'SubtaskNavigation');
          }
        } catch (e) {
          AppLogging.logError('SubtaskDetailsScreen: Failed to trigger parent refresh: $e', name: 'SubtaskNavigation');
        }
      });
    }
  }

  BuildContext? _findParentTaskDetailsContext() {
    // Try to find the parent TaskDetailsScreen context
    // This is a best-effort approach - in some navigation scenarios it might not work
    try {
      // Look for the nearest TaskDetailsBloc in the widget tree
      return context.findAncestorStateOfType<State<TaskDetailsScreen>>()?.context;
    } catch (e) {
      AppLogging.logError('SubtaskDetailsScreen: Could not find parent TaskDetailsScreen context: $e', name: 'SubtaskNavigation');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          _currentSubtask.title,
          style: TextStyle(fontWeight: FontWeight.w600, color: colorScheme.onSurface),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: colorScheme.shadow,
        surfaceTintColor: colorScheme.surfaceTint,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () {
            AppLogging.logInfo('SubtaskDetailsScreen: Navigating back to parent', name: 'SubtaskNavigation');
            Navigator.of(context).pop();
          },
        ),
        actions: [
          // Level Three Button
          IconButton(
            onPressed: () => _addLevelThreeSubtask(context),
            icon: const Icon(Icons.add_circle_outline),
            tooltip: l10n.addLevelThreeSubtask,
            style: IconButton.styleFrom(foregroundColor: colorScheme.primary, backgroundColor: colorScheme.primary.withValues(alpha: 0.1)),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {});
          _updateParentTask();
          AppLogging.logInfo('SubtaskDetailsScreen: Manual refresh triggered for subtask "${_currentSubtask.title}"', name: 'SubtaskRefresh');
        },
        color: colorScheme.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Task Path
              if (_parentTask != null) _buildTaskPath(context, l10n),

              const SizedBox(height: 16),

              // Subtask Details Card
              _buildSubtaskDetails(context, l10n),

              const SizedBox(height: 16),

              // Progress Card (if has sub-subtasks)
              if (_currentSubtask.subtasks.isNotEmpty) _buildProgressCard(context, l10n),

              const SizedBox(height: 16),

              // Sub-subtasks Section
              if (_currentSubtask.subtasks.isNotEmpty) _buildSubtasksSection(context, l10n),

              const SizedBox(height: 16),

              // Actions Card
              _buildActionsCard(context, l10n),

              const SizedBox(height: 32), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskPath(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(colors: [colorScheme.primary.withValues(alpha: 0.05), colorScheme.secondary.withValues(alpha: 0.05)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.account_tree_outlined, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      l10n.taskPath,
                      style: theme.textTheme.titleSmall?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          _parentTask!.title,
                          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.7)),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.chevron_right, size: 16, color: colorScheme.primary),
                      ),
                      Flexible(
                        child: Text(
                          _currentSubtask.title,
                          style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.primary, fontWeight: FontWeight.w600),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubtaskDetails(BuildContext context, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(colors: [colorScheme.surface, colorScheme.surface.withValues(alpha: 0.95)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: colorScheme.primary.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.task_alt, color: colorScheme.primary, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    l10n.subtaskDetails,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onSurface),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Description
              if (_currentSubtask.description != null && _currentSubtask.description!.isNotEmpty) ...[_buildDetailSection(context, l10n.taskDescription, _currentSubtask.description!, Icons.description_outlined, colorScheme.primary), const SizedBox(height: 16)],

              // Status
              _buildDetailRow(context, l10n.status, _currentSubtask.isCompleted ? l10n.completed : l10n.pending, _currentSubtask.isCompleted ? Icons.check_circle : Icons.pending, _currentSubtask.isCompleted ? Colors.green : Colors.orange),

              const SizedBox(height: 12),

              // Priority
              _buildDetailRow(context, l10n.priority, _getPriorityText(_currentSubtask.priority, l10n), Icons.flag, _getPriorityColor(_currentSubtask.priority)),

              // Due Date
              if (_currentSubtask.dueDate != null) ...[const SizedBox(height: 12), _buildDetailRow(context, l10n.dueDate, _formatDate(_currentSubtask.dueDate!), Icons.calendar_today, Colors.blue)],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection(BuildContext context, String title, String content, IconData icon, Color color) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(color: color, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface)),
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(BuildContext context, AppLocalizations l10n) {
    final progress = _currentSubtask.getCompletionProgress();

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.progress, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade300, valueColor: AlwaysStoppedAnimation<Color>(Colors.green)),
            const SizedBox(height: 8),
            Text('${_getCompletedSubtasksCount(_currentSubtask)}/${_getTotalSubtasksCount(_currentSubtask)} ${l10n.subtasks}'),
          ],
        ),
      ),
    );
  }

  Widget _buildSubtasksSection(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with Add Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("${l10n.subtasks} (${_currentSubtask.subtasks.length})", style: Theme.of(context).textTheme.titleLarge),
                IconButton(onPressed: () => _addSubSubtask(context), icon: const Icon(Icons.add), tooltip: l10n.addSubSubtask),
              ],
            ),
            const SizedBox(height: 16),

            // Subtasks List or Empty State
            if (_currentSubtask.subtasks.isEmpty)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inbox, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(l10n.noSubtasksYet, style: TextStyle(color: Colors.grey[600], fontSize: 16)),
                    const SizedBox(height: 8),
                    TextButton.icon(onPressed: () => _addSubSubtask(context), icon: const Icon(Icons.add), label: Text(l10n.addFirstSubtask)),
                  ],
                ),
              )
            else
              Column(
                children: _currentSubtask.subtasks.asMap().entries.map((entry) {
                  final index = entry.key;
                  final subSubtask = entry.value;
                  return _buildEnhancedSubSubtaskTile(context, subSubtask, index, l10n);
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedSubSubtaskTile(BuildContext context, Task subSubtask, int index, AppLocalizations l10n) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Row
            Row(
              children: [
                // Checkbox
                Checkbox(
                  value: subSubtask.isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _currentSubtask = _currentSubtask.copyWith(subtasks: _currentSubtask.subtasks.map((s) => s.id == subSubtask.id ? s.copyWith(isCompleted: value ?? false) : s).toList());
                    });
                    _updateParentTask();
                  },
                ),

                // Title and Description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subSubtask.title,
                        style: TextStyle(fontWeight: FontWeight.w500, decoration: subSubtask.isCompleted ? TextDecoration.lineThrough : null, color: subSubtask.isCompleted ? Colors.grey : null),
                      ),
                      if (subSubtask.description != null && subSubtask.description!.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          subSubtask.description!,
                          style: TextStyle(fontSize: 12, color: Colors.grey[600], decoration: subSubtask.isCompleted ? TextDecoration.lineThrough : null),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // Action Buttons
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert),
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _editSubSubtask(context, subSubtask);
                        break;
                      case 'duplicate':
                        _duplicateSubSubtask(context, subSubtask);
                        break;
                      case 'delete':
                        _deleteSubSubtask(context, subSubtask);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')]),
                    ),
                    const PopupMenuItem(
                      value: 'duplicate',
                      child: Row(children: [Icon(Icons.copy), SizedBox(width: 8), Text('Duplicate')]),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Additional Details Row
            if (subSubtask.dueDate != null || subSubtask.subtasks.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  if (subSubtask.dueDate != null) ...[Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]), const SizedBox(width: 4), Text(_formatDate(subSubtask.dueDate!), style: TextStyle(fontSize: 12, color: Colors.grey[600]))],
                  if (subSubtask.dueDate != null && subSubtask.subtasks.isNotEmpty) ...[const SizedBox(width: 12)],
                  if (subSubtask.subtasks.isNotEmpty) ...[Icon(Icons.subdirectory_arrow_right, size: 14, color: Colors.grey[600]), const SizedBox(width: 4), Text("${subSubtask.subtasks.length} sub-subtasks", style: TextStyle(fontSize: 12, color: Colors.grey[600]))],
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _addSubSubtask(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: AddTaskDialog(
          onTaskAdded: (newSubSubtask) {
            setState(() {
              _currentSubtask = _currentSubtask.copyWith(subtasks: [..._currentSubtask.subtasks, newSubSubtask]);
            });
            _updateParentTask();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.subSubtaskAdded), backgroundColor: Colors.green));
            AppLogging.logInfo('SubtaskDetailsScreen: Sub-subtask added successfully', name: 'SubtaskNavigation');
          },
          isSubtask: true,
        ),
      ),
    );
  }

  void _addLevelThreeSubtask(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addLevelThreeSubtask),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.levelThreeSubtaskDescription),
            const SizedBox(height: 16),
            Text(
              "This will create a level-3 subtask under \"${_currentSubtask.title}\"",
              style: TextStyle(fontSize: 14, color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.of(context).pop();
              _showLevelThreeTaskDialog(context);
            },
            icon: const Icon(Icons.add),
            label: Text(l10n.add),
            style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white),
          ),
        ],
      ),
    );
  }

  void _showLevelThreeTaskDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.addLevelThreeSubtask),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: l10n.taskTitle, hintText: l10n.enterTaskTitle, border: const OutlineInputBorder()),
              autofocus: true, // User-initiated dialog should focus for good UX
            ),
            const SizedBox(height: 16),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: l10n.taskDescription, hintText: l10n.enterTaskDescription, border: const OutlineInputBorder()),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isNotEmpty) {
                final levelThreeTask = Task(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
                  priority: TaskPriority.medium,
                  isCompleted: false,
                  subtasks: [],
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                );

                setState(() {
                  _currentSubtask = _currentSubtask.copyWith(subtasks: [..._currentSubtask.subtasks, levelThreeTask]);
                });
                _updateParentTask();

                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.levelThreeSubtaskAdded), backgroundColor: Colors.green));
                AppLogging.logInfo('SubtaskDetailsScreen: Level-3 subtask added successfully', name: 'SubtaskNavigation');
              }
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  void _editSubSubtask(BuildContext context, Task subSubtask) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        task: subSubtask,
        onTaskUpdated: (updatedSubSubtask) {
          setState(() {
            _currentSubtask = _currentSubtask.copyWith(subtasks: _currentSubtask.subtasks.map((s) => s.id == subSubtask.id ? updatedSubSubtask : s).toList());
          });
          _updateParentTask();
          AppLogging.logInfo('SubtaskDetailsScreen: Sub-subtask edited successfully', name: 'SubtaskNavigation');
        },
      ),
    );
  }

  void _duplicateSubSubtask(BuildContext context, Task subSubtask) {
    final l10n = AppLocalizations.of(context)!;
    final duplicatedSubSubtask = subSubtask.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString(), title: "${subSubtask.title} (Copy)", isCompleted: false, subtasks: [], createdAt: DateTime.now(), updatedAt: DateTime.now());

    setState(() {
      _currentSubtask = _currentSubtask.copyWith(subtasks: [..._currentSubtask.subtasks, duplicatedSubSubtask]);
    });
    _updateParentTask();

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.subSubtaskDuplicated), backgroundColor: Colors.green));
    AppLogging.logInfo('SubtaskDetailsScreen: Sub-subtask duplicated successfully', name: 'SubtaskNavigation');
  }

  void _deleteSubSubtask(BuildContext context, Task subSubtask) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteSubSubtask),
        content: Text(l10n.deleteSubSubtaskConfirmation.replaceAll('@taskName', subSubtask.title)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentSubtask = _currentSubtask.copyWith(subtasks: _currentSubtask.subtasks.where((s) => s.id != subSubtask.id).toList());
              });
              _updateParentTask();

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.subSubtaskDeleted), backgroundColor: Colors.green));
              AppLogging.logInfo('SubtaskDetailsScreen: Sub-subtask deleted successfully', name: 'SubtaskNavigation');
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsCard(BuildContext context, AppLocalizations l10n) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.actions, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),

            // Primary Actions Row
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _currentSubtask = _currentSubtask.copyWith(isCompleted: !_currentSubtask.isCompleted);
                      });
                      _updateParentTask();
                    },
                    icon: Icon(_currentSubtask.isCompleted ? Icons.undo : Icons.check),
                    label: Text(_currentSubtask.isCompleted ? l10n.markAsIncomplete : l10n.markAsComplete),
                    style: ElevatedButton.styleFrom(backgroundColor: _currentSubtask.isCompleted ? Colors.orange : Colors.green, foregroundColor: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _editSubtask(context),
                    icon: const Icon(Icons.edit),
                    label: Text(l10n.editSubtask),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.blue, foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Secondary Actions Row
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _duplicateSubtask(context),
                    icon: const Icon(Icons.copy),
                    label: Text(l10n.duplicateSubtask),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.purple),
                      foregroundColor: Colors.purple,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _deleteSubtask(context),
                    icon: const Icon(Icons.delete),
                    label: Text(l10n.deleteSubtask),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.red),
                      foregroundColor: Colors.red,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateParentTask() {
    if (_parentTask != null) {
      // Mark that changes were made
      _hasChanges = true;

      // Update the parent task with the modified subtask
      final updatedParent = _parentTask!.copyWith(subtasks: _parentTask!.subtasks.map((s) => s.id == _currentSubtask.id ? _currentSubtask : s).toList());

      // Update the parent task in the repository
      context
          .read<TaskRepository>()
          .updateTask(updatedParent)
          .then((_) {
            AppLogging.logInfo('SubtaskDetailsScreen: Updated parent task with subtask changes', name: 'SubtaskNavigation');
          })
          .catchError((error) {
            AppLogging.logError('SubtaskDetailsScreen: Failed to update parent task: $error', name: 'SubtaskNavigation');
          });
    }
  }

  void _editSubtask(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => EditTaskDialog(
        task: _currentSubtask,
        onTaskUpdated: (updatedSubtask) {
          setState(() {
            _currentSubtask = updatedSubtask;
          });
          _updateParentTask();
          AppLogging.logInfo('SubtaskDetailsScreen: Subtask edited successfully', name: 'SubtaskNavigation');
        },
      ),
    );
  }

  void _duplicateSubtask(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final duplicatedSubtask = _currentSubtask.copyWith(id: DateTime.now().millisecondsSinceEpoch.toString(), title: "${_currentSubtask.title} (Copy)", isCompleted: false, subtasks: [], createdAt: DateTime.now(), updatedAt: DateTime.now());

    if (_parentTask != null) {
      final updatedParent = _parentTask!.copyWith(subtasks: [..._parentTask!.subtasks, duplicatedSubtask]);

      context
          .read<TaskRepository>()
          .updateTask(updatedParent)
          .then((_) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.subtaskDuplicated), backgroundColor: Colors.green));
            AppLogging.logInfo('SubtaskDetailsScreen: Subtask duplicated successfully', name: 'SubtaskNavigation');
          })
          .catchError((error) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to duplicate subtask: $error"), backgroundColor: Colors.red));
            AppLogging.logError('SubtaskDetailsScreen: Failed to duplicate subtask: $error', name: 'SubtaskNavigation');
          });
    }
  }

  void _deleteSubtask(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteSubtask),
        content: Text(l10n.deleteSubtaskConfirmation.replaceAll('@taskName', _currentSubtask.title)),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog

              if (_parentTask != null) {
                // Mark that changes were made
                _hasChanges = true;

                final updatedParent = _parentTask!.copyWith(subtasks: _parentTask!.subtasks.where((s) => s.id != _currentSubtask.id).toList());

                context
                    .read<TaskRepository>()
                    .updateTask(updatedParent)
                    .then((_) {
                      // Trigger parent refresh immediately since we're deleting
                      _triggerImmediateParentRefresh();
                      Navigator.of(context).pop(); // Go back to parent
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.subtaskDeleted), backgroundColor: Colors.green));
                      AppLogging.logInfo('SubtaskDetailsScreen: Subtask deleted successfully and parent refresh triggered', name: 'SubtaskNavigation');
                    })
                    .catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to delete subtask: $error"), backgroundColor: Colors.red));
                      AppLogging.logError('SubtaskDetailsScreen: Failed to delete subtask: $error', name: 'SubtaskNavigation');
                    });
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _triggerImmediateParentRefresh() {
    if (_parentTask != null) {
      AppLogging.logInfo('SubtaskDetailsScreen: Triggering immediate parent task refresh after deletion', name: 'SubtaskNavigation');

      // Use a post-frame callback to ensure the navigation completes before triggering refresh
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          // Find and refresh the parent TaskDetailsScreen
          final parentContext = _findParentTaskDetailsContext();
          if (parentContext != null) {
            // Trigger refresh in parent screen
            final bloc = parentContext.read<TaskDetailsBloc>();
            bloc.add(LoadTaskDetails(_parentTask!.id));
            AppLogging.logInfo('SubtaskDetailsScreen: Immediate parent task refresh triggered successfully', name: 'SubtaskNavigation');
          }
        } catch (e) {
          AppLogging.logError('SubtaskDetailsScreen: Failed to trigger immediate parent refresh: $e', name: 'SubtaskNavigation');
        }
      });
    }
  }

  String _getPriorityText(TaskPriority priority, AppLocalizations l10n) {
    switch (priority) {
      case TaskPriority.high:
        return l10n.highPriority;
      case TaskPriority.medium:
        return l10n.mediumPriority;
      case TaskPriority.low:
        return l10n.lowPriority;
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int _getCompletedSubtasksCount(Task task) {
    int count = 0;
    for (var subtask in task.subtasks) {
      if (subtask.isCompleted) count++;
    }
    return count;
  }

  int _getTotalSubtasksCount(Task task) {
    return task.subtasks.length;
  }
}
