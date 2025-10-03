
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import '../../models/task.dart';
import '../../blocs/task_details/task_details_bloc.dart';
import '../../blocs/task_details/task_details_event.dart';
import '../../services/task_sound_service.dart';
import 'add_task_dialog.dart';

class SubtaskWidget extends StatefulWidget {
  final Task subtask;
  final int depth;
  final int maxDepth;
  final Function(Task) onToggle;
  final Function(Task) onEdit;
  final Function(String) onDelete;
  final Function(Task)? onAddNested;
  final bool strictMode;
  final bool isParentCompleted;

  const SubtaskWidget({
    super.key,
    required this.subtask,
    required this.depth,
    required this.maxDepth,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
    this.onAddNested,
    this.strictMode = true,
    this.isParentCompleted = false,
  });

  @override
  State<SubtaskWidget> createState() => _SubtaskWidgetState();
}

class _SubtaskWidgetState extends State<SubtaskWidget> with TickerProviderStateMixin {
  bool _isExpanded = false;
  bool _isEditing = false;
  late bool _isCompleted;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _isCompleted = widget.subtask.isCompleted;
    _titleController = TextEditingController(text: widget.subtask.title);
    _descriptionController = TextEditingController(text: widget.subtask.description ?? '');

    _animationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);

    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));
  }

  @override
  void didUpdateWidget(SubtaskWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.subtask.isCompleted != widget.subtask.isCompleted) {
      _isCompleted = widget.subtask.isCompleted;
    }
    if (oldWidget.subtask.title != widget.subtask.title) {
      _titleController.text = widget.subtask.title;
    }
    if (oldWidget.subtask.description != widget.subtask.description) {
      _descriptionController.text = widget.subtask.description ?? '';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  final TaskSoundService _taskSoundService = TaskSoundService();

  @override
  Widget build(BuildContext context) {
    final canHaveChildren = widget.depth < widget.maxDepth;
    final hasChildren = widget.subtask.subtasks.isNotEmpty;
    final completedChildren = widget.subtask.subtasks.where((s) => s.isCompleted).length;
    final progress = hasChildren ? completedChildren / widget.subtask.subtasks.length : 0.0;

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(opacity: _opacityAnimation.value, child: child),
        );
      },
      child: Opacity(
        opacity: widget.isParentCompleted ? 0.5 : 1.0,
        child: Container(
          margin: EdgeInsets.only(left: widget.depth * 20.0, bottom: 8.0),
          child: Card(
            elevation: _isCompleted ? 1 : 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: _isCompleted ? Colors.green.withValues(alpha: 0.3) : Colors.transparent, width: 1),
            ),
            child: Column(
              children: [
                // Main subtask item
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Checkbox with animation
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(shape: BoxShape.circle, color: _isCompleted ? Colors.green.withValues(alpha: 0.1) : Colors.transparent),
                            child: Checkbox(
                              value: _isCompleted,
                              onChanged: widget.isParentCompleted
                                  ? null
                                  : (value) async {
                                      if (value == true && !_isCompleted) {
                                        setState(() => _isCompleted = true);
                                        await _taskSoundService.playTaskCompletionSound();
                                      } else {
                                        setState(() => _isCompleted = value ?? false);
                                      }

                                      HapticFeedback.lightImpact();
                                      _animateToggle();

                                      final toggledSubtask = widget.subtask.copyWith(isCompleted: value ?? false, updatedAt: DateTime.now());
                                      widget.onToggle(toggledSubtask);
                                    },
                              activeColor: Colors.green,
                              checkColor: Colors.white,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // Title and description
                          Expanded(child: _isEditing ? _buildEditMode() : _buildDisplayMode()),

                          // Action buttons
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (hasChildren) ...[
                                IconButton(
                                  icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more, size: 20, color: Colors.blue),
                                  onPressed: () => setState(() => _isExpanded = !_isExpanded),
                                  tooltip: _isExpanded ? 'Collapse' : 'Expand',
                                ),
                              ],
                              IconButton(
                                icon: Icon(_isEditing ? Icons.check : Icons.edit, size: 20),
                                onPressed: widget.isParentCompleted
                                    ? null
                                    : () {
                                        if (_isEditing) {
                                          _saveEdit();
                                        } else {
                                          setState(() => _isEditing = true);
                                        }
                                      },
                                tooltip: _isEditing ? AppLocalizations.of(context)!.saveButton : AppLocalizations.of(context)!.editButton,
                              ),
                              PopupMenuButton<String>(
                                enabled: !widget.isParentCompleted,
                                icon: const Icon(Icons.more_vert, size: 20),
                                onSelected: widget.isParentCompleted
                                    ? null
                                    : (value) {
                                        switch (value) {
                                          case 'edit':
                                            setState(() => _isEditing = true);
                                            break;
                                          case 'delete':
                                            _showDeleteConfirmation();
                                            break;
                                          case 'duplicate':
                                            _duplicateSubtask();
                                            break;
                                        }
                                      },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'edit',
                                    child: Row(children: [const Icon(Icons.edit, size: 16), const SizedBox(width: 8), Text(AppLocalizations.of(context)!.editButton)]),
                                  ),
                                  PopupMenuItem(
                                    value: 'duplicate',
                                    child: Row(children: [const Icon(Icons.copy, size: 16), const SizedBox(width: 8), Text(AppLocalizations.of(context)!.duplicateTask)]),
                                  ),
                                  PopupMenuItem(
                                    value: 'delete',
                                    child: Row(
                                      children: [
                                        const Icon(Icons.delete, color: Colors.red, size: 16),
                                        const SizedBox(width: 8),
                                        Text(AppLocalizations.of(context)!.deleteButton, style: const TextStyle(color: Colors.red)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Progress bar for subtasks
                      if (hasChildren && widget.subtask.subtasks.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.withValues(alpha: 0.2), valueColor: AlwaysStoppedAnimation<Color>(progress == 1.0 ? Colors.green : Colors.blue)),
                        const SizedBox(height: 4),
                        Text('${(progress * 100).round()}% complete', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ],
                  ),
                ),

                // Expanded children
                if (hasChildren && _isExpanded) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: widget.subtask.subtasks
                          .map(
                            (subtask) => SubtaskWidget(
                              subtask: subtask,
                              depth: widget.depth + 1,
                              maxDepth: widget.maxDepth,
                              onToggle: widget.onToggle,
                              onEdit: widget.onEdit,
                              onDelete: widget.onDelete,
                              onAddNested: (newSubtask) => context.read<TaskDetailsBloc>().add(AddSubtask(subtask.id, newSubtask)),
                              strictMode: widget.strictMode,
                              isParentCompleted: subtask.isCompleted,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],

                // Add subtask button
                if (canHaveChildren && _isExpanded) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: TextButton.icon(
                      icon: Icon(Icons.add, color: widget.isParentCompleted ? Colors.grey : Colors.blue),
                      label: Text(AppLocalizations.of(context)!.addSubtask, style: TextStyle(color: widget.isParentCompleted ? Colors.grey : Colors.blue)),
                      onPressed: widget.isParentCompleted ? null : () => _showAddSubtaskDialog(),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(color: widget.isParentCompleted ? Colors.grey : Colors.blue, width: 1),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _animateToggle() {
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
  }

  Widget _buildDisplayMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.subtask.title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, decoration: _isCompleted ? TextDecoration.lineThrough : null, color: _isCompleted ? Colors.grey[600] : Theme.of(context).textTheme.bodyLarge?.color),
        ),
        if (widget.subtask.description != null && widget.subtask.description!.isNotEmpty) ...[
          const SizedBox(height: 4),
          Text(
            widget.subtask.description!,
            style: TextStyle(fontSize: 14, color: Colors.grey[600], decoration: _isCompleted ? TextDecoration.lineThrough : null),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  Widget _buildEditMode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _titleController,
          decoration: InputDecoration(hintText: AppLocalizations.of(context)!.taskTitleLabel, border: InputBorder.none, contentPadding: EdgeInsets.zero),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          maxLines: 1,
          onSubmitted: (_) => _saveEdit(),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: _descriptionController,
          decoration: InputDecoration(hintText: AppLocalizations.of(context)!.taskDescriptionLabel, border: InputBorder.none, contentPadding: EdgeInsets.zero),
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          maxLines: 2,
          onSubmitted: (_) => _saveEdit(),
        ),
      ],
    );
  }

  void _saveEdit() {
    final newTitle = _titleController.text.trim();
    if (newTitle.isNotEmpty) {
      final updatedSubtask = widget.subtask.copyWith(title: newTitle, description: _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null, updatedAt: DateTime.now());
      widget.onEdit(updatedSubtask);
      setState(() => _isEditing = false);
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteSubtask),
        content: Text('Are you sure you want to delete this subtask?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancelButton)),
          TextButton(
            onPressed: () {
              widget.onDelete(widget.subtask.id);
              Navigator.pop(context);
            },
            child: Text(AppLocalizations.of(context)!.deleteButton, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _duplicateSubtask() {
    final duplicatedSubtask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: '${widget.subtask.title} (Copy)',
      description: widget.subtask.description,
      isCompleted: false,
      parentId: widget.subtask.id,
      maxSubtaskDepth: widget.subtask.maxSubtaskDepth,
      strictCompletionMode: widget.subtask.strictCompletionMode,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    // Add the duplicated subtask to the current subtask's subtasks
    final updatedSubtask = widget.subtask.copyWith(subtasks: [...widget.subtask.subtasks, duplicatedSubtask], updatedAt: DateTime.now());

    widget.onEdit(updatedSubtask);
  }

  void _showAddSubtaskDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(child: AddTaskDialog(onTaskAdded: (subtask) => widget.onAddNested?.call(subtask), isSubtask: true)),
    );
  }
}
