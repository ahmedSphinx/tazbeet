import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../repositories/task_repository.dart';
import '../../services/app_logging_service.dart';
import '../widgets/task_timeline_widget.dart';

class TaskTimelineScreen extends StatefulWidget {
  const TaskTimelineScreen({super.key});

  @override
  State<TaskTimelineScreen> createState() => _TaskTimelineScreenState();
}

class _TaskTimelineScreenState extends State<TaskTimelineScreen> {
  List<Task> _allTasks = [];
  List<Task> _filteredTasks = [];
  bool _isLoading = true;
  String _selectedFilter = 'all';
  String _selectedSort = 'date';

  final Map<String, String> _filterOptions = {'all': 'All Tasks', 'completed': 'Completed', 'pending': 'Pending', 'overdue': 'Overdue', 'today': 'Due Today', 'this_week': 'This Week'};

  final Map<String, String> _sortOptions = {'date': 'Date Modified', 'created': 'Date Created', 'priority': 'Priority', 'title': 'Title', 'due_date': 'Due Date'};

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    setState(() => _isLoading = true);

    try {
      final taskRepo = TaskRepository();
      final tasks = await taskRepo.getAllTasks();

      setState(() {
        _allTasks = tasks;
        _applyFiltersAndSort();
        _isLoading = false;
      });
    } catch (e) {
      AppLogging.logError('Error loading tasks for timeline: $e');
      setState(() => _isLoading = false);
    }
  }

  void _applyFiltersAndSort() {
    var filteredTasks = List<Task>.from(_allTasks);

    // Apply filter
    switch (_selectedFilter) {
      case 'completed':
        filteredTasks = filteredTasks.where((task) => task.isCompleted).toList();
        break;
      case 'pending':
        filteredTasks = filteredTasks.where((task) => !task.isCompleted).toList();
        break;
      case 'overdue':
        final now = DateTime.now();
        filteredTasks = filteredTasks.where((task) => task.dueDate != null && task.dueDate!.isBefore(now)).toList();
        break;
      case 'today':
        final now = DateTime.now();
        filteredTasks = filteredTasks.where((task) => task.dueDate != null && task.dueDate!.year == now.year && task.dueDate!.month == now.month && task.dueDate!.day == now.day).toList();
        break;
      case 'this_week':
        final now = DateTime.now();
        final weekStart = now.subtract(Duration(days: now.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        filteredTasks = filteredTasks.where((task) => task.dueDate != null && task.dueDate!.isAfter(weekStart) && task.dueDate!.isBefore(weekEnd)).toList();
        break;
    }

    // Apply sort
    switch (_selectedSort) {
      case 'date':
        filteredTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'created':
        filteredTasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'priority':
        const priorityOrder = [TaskPriority.high, TaskPriority.medium, TaskPriority.low];
        filteredTasks.sort((a, b) => priorityOrder.indexOf(a.priority).compareTo(priorityOrder.indexOf(b.priority)));
        break;
      case 'title':
        filteredTasks.sort((a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
        break;
      case 'due_date':
        filteredTasks.sort((a, b) {
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
    }

    setState(() {
      _filteredTasks = filteredTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Timeline'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadTasks)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Filter and sort controls
                _buildFilterControls(),

                // Timeline
                Expanded(
                  child: TaskTimelineWidget(
                    tasks: _filteredTasks,
                    onTaskTap: (task) => _showTaskDetails(task),
                    onTaskComplete: (task) => _toggleTaskCompletion(task),
                    onTaskEdit: (task) => _editTask(task),
                    showFocusModeInfo: true,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildFilterControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _filterOptions.entries.map((entry) {
                final isSelected = _selectedFilter == entry.key;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(entry.value),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedFilter = entry.key;
                        _applyFiltersAndSort();
                      });
                    },
                    backgroundColor: isSelected ? Theme.of(context).colorScheme.primary : null,
                    labelStyle: TextStyle(color: isSelected ? Colors.white : null),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 8),

          // Sort dropdown
          Row(
            children: [
              Text('Sort by:', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7))),
              const SizedBox(width: 8),
              DropdownButton<String>(
                value: _selectedSort,
                onChanged: (value) {
                  setState(() {
                    _selectedSort = value!;
                    _applyFiltersAndSort();
                  });
                },
                items: _sortOptions.entries.map((entry) {
                  return DropdownMenuItem<String>(value: entry.key, child: Text(entry.value));
                }).toList(),
              ),
              const Spacer(),
              Text('${_filteredTasks.length} tasks', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
            ],
          ),
        ],
      ),
    );
  }

  void _showTaskDetails(Task task) {
    // Navigate to task details screen
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskDetailsScreen(task: task)));
  }

  Future<void> _toggleTaskCompletion(Task task) async {
    try {
      final taskRepo = TaskRepository();
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await taskRepo.updateTask(updatedTask);

      // Show feedback
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(task.isCompleted ? 'Task marked as incomplete' : 'Task completed!'), backgroundColor: task.isCompleted ? Colors.orange : Colors.green, duration: const Duration(seconds: 2)));

      _loadTasks();
    } catch (e) {
      AppLogging.logError('Error toggling task completion: $e');
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error updating task'), backgroundColor: Colors.red));
    }
  }

  void _editTask(Task task) {
    // Navigate to edit task screen
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TaskEditScreen(task: task)));
  }
}

// Placeholder screens for navigation
class TaskDetailsScreen extends StatelessWidget {
  final Task task;

  const TaskDetailsScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Details')),
      body: Center(child: Text('Task details for: ${task.title}')),
    );
  }
}

class TaskEditScreen extends StatelessWidget {
  final Task task;

  const TaskEditScreen({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Task')),
      body: Center(child: Text('Edit task: ${task.title}')),
    );
  }
}
