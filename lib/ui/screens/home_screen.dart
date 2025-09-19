import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../l10n/generated/app_localizations.dart';
import '../../blocs/task/task_bloc.dart';
import '../../blocs/task/task_event.dart';
import '../../blocs/task/task_state.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_event.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_state.dart';
import '../../models/task.dart';
import '../../services/color_customization_service.dart';
import '../../services/settings_service.dart' as settings;
import '../../utils/date_formatter.dart';
import '../widgets/task_item.dart';
import 'ambient_screen.dart';
import 'category_screen.dart';
import 'emergency_screen.dart';
import 'mood_screen.dart';
import 'pomodoro_screen.dart';
import 'profile_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String? _selectedCategoryId;
  bool _sortByPriority = false;
  bool _isSearching = false;
  String _searchQuery = '';
  TaskPriority? _filterPriority;
  bool? _filterCompleted;

  final List<Widget> _screens = [
    HomeScreenBody(),
    const ProgressScreen(),
    const PomodoroScreen(),
    const CategoryScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSearching = false;
      _searchQuery = '';
      _filterPriority = null;
      _filterCompleted = null;
      _selectedCategoryId = null;
    });
  }

  void _showFilterDialog() {
    TaskPriority? tempPriority = _filterPriority;
    bool? tempCompleted = _filterCompleted;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(AppLocalizations.of(context).filterTasksTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(AppLocalizations.of(context).priorityLabel),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: Text(AppLocalizations.of(context).allLabel),
                    selected: tempPriority == null,
                    onSelected: (selected) {
                      setState(() {
                        tempPriority = selected ? null : tempPriority;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text(AppLocalizations.of(context).highPriorityLabel),
                    selected: tempPriority == TaskPriority.high,
                    onSelected: (selected) {
                      setState(() {
                        tempPriority = selected ? TaskPriority.high : null;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text(
                      AppLocalizations.of(context).mediumPriorityLabel,
                    ),
                    selected: tempPriority == TaskPriority.medium,
                    onSelected: (selected) {
                      setState(() {
                        tempPriority = selected ? TaskPriority.medium : null;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text(AppLocalizations.of(context).lowPriorityLabel),
                    selected: tempPriority == TaskPriority.low,
                    onSelected: (selected) {
                      setState(() {
                        tempPriority = selected ? TaskPriority.low : null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context).statusLabel),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  FilterChip(
                    label: Text(AppLocalizations.of(context).allLabel),
                    selected: tempCompleted == null,
                    onSelected: (selected) {
                      setState(() {
                        tempCompleted = selected ? null : tempCompleted;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text(AppLocalizations.of(context).incompleteLabel),
                    selected: tempCompleted == false,
                    onSelected: (selected) {
                      setState(() {
                        tempCompleted = selected ? false : null;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text(AppLocalizations.of(context).completedLabel),
                    selected: tempCompleted == true,
                    onSelected: (selected) {
                      setState(() {
                        tempCompleted = selected ? true : null;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(AppLocalizations.of(context).cancelButton),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _filterPriority = tempPriority;
                  _filterCompleted = tempCompleted;
                });
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).applyButton),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _filterPriority = null;
                  _filterCompleted = null;
                });
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context).clearAllButton),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedCategoryId;
    TaskPriority selectedPriority = TaskPriority.medium;
    DateTime? selectedDueDate;

    showDialog(
      context: context,
      builder: (context) => BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).addTaskTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'Enter task title',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Enter task description',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TaskPriority>(
                  value: selectedPriority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: TaskPriority.values
                      .map(
                        (priority) => DropdownMenuItem<TaskPriority>(
                          value: priority,
                          child: Text(priority.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedPriority = value;
                    }
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      selectedDueDate = pickedDate;
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Due Date (Optional)',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      selectedDueDate != null
                          ? DateFormatter.formatDate(selectedDueDate!)
                          : 'Select due date',
                      style: TextStyle(
                        color: selectedDueDate != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(100),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (state is CategoryLoaded && state.categories.isNotEmpty)
                  DropdownButtonFormField<String?>(
                    value: selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Category (Optional)',
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('No Category'),
                      ),
                      ...state.categories.map(
                        (category) => DropdownMenuItem<String?>(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      selectedCategoryId = value;
                    },
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    final task = Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      description: descriptionController.text.isEmpty
                          ? null
                          : descriptionController.text,
                      priority: selectedPriority,
                      dueDate: selectedDueDate,
                      categoryId: selectedCategoryId,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    context.read<TaskBloc>().add(AddTask(task));
                    Navigator.of(context).pop();
                  }
                },
                child: Text(AppLocalizations.of(context).addButton),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
    context.read<CategoryBloc>().add(LoadCategories());
    context.read<UserBloc>().add(LoadUser());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching && _selectedIndex == 0
            ? TextField(
                autofocus: true,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).searchHint,
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              )
            : Text(
                _selectedIndex == 0
                    ? AppLocalizations.of(context).appTitle
                    : _selectedIndex == 1
                    ? AppLocalizations.of(context).progressSaved
                    : _selectedIndex == 2
                    ? AppLocalizations.of(context).pomodoroSection
                    : _selectedIndex == 3
                    ? AppLocalizations.of(context).allCategories
                    : _selectedIndex == 4
                    ? AppLocalizations.of(context).settingsScreenTitle
                    : '',
              ),
        actions: _selectedIndex == 0
            ? [
                IconButton(
                  icon: Icon(_sortByPriority ? Icons.sort : Icons.filter_list),
                  onPressed: () {
                    if (_sortByPriority) {
                      setState(() {
                        _sortByPriority = !_sortByPriority;
                      });
                    } else {
                      _showFilterDialog();
                    }
                  },
                ),
                IconButton(
                  icon: Icon(_isSearching ? Icons.close : Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = !_isSearching;
                      if (!_isSearching) {
                        _searchQuery = '';
                        _filterPriority = null;
                        _filterCompleted = null;
                      }
                    });
                  },
                ),
              ]
            : _selectedIndex == 2
            ? [
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () {
                    // TODO: Open settings for timer customization
                  },
                ),
              ]
            : _selectedIndex == 3
            ? [
              /*   IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _showAddCategoryDialog,
                ), */
              ]
            : _selectedIndex == 4
            ? [
                TextButton(
                  onPressed: () {
                    context.read<settings.SettingsService>().resetToDefaults();
                    context.read<ColorCustomizationService>().resetToDefault();
                  },
                  child: Text(AppLocalizations.of(context).resetButton),
                ),
              ]
            : null,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  String userName = AppLocalizations.of(context).appTitle;
                  String? userPhotoUrl;
                  if (state is UserLoaded) {
                    userName = state.user.name;
                    userPhotoUrl = state.user.profileImageUrl;
                  }
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundImage:
                            userPhotoUrl != null && userPhotoUrl.isNotEmpty
                            ? NetworkImage(userPhotoUrl)
                            : null,
                        child: (userPhotoUrl == null || userPhotoUrl.isEmpty)
                            ? Icon(
                                Icons.person,
                                size: 40,
                                color: Theme.of(context).colorScheme.onPrimary,
                              )
                            : null,
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.primaryContainer,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          userName,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(AppLocalizations.of(context).homeScreenTitle),
              selected: _selectedIndex == 0,
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart),
              title: Text(AppLocalizations.of(context).progressSaved),
              selected: _selectedIndex == 1,
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            ListTile(
              leading: const Icon(Icons.timer),
              title: Text(AppLocalizations.of(context).pomodoroSection),
              selected: _selectedIndex == 2,
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder),
              title: Text(AppLocalizations.of(context).allCategories),
              selected: _selectedIndex == 3,
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context).settingsScreenTitle),
              selected: _selectedIndex == 4,
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(4);
              },
            ),

            const Divider(),
            ListTile(
              leading: const Icon(Icons.mood),
              title: const Text('Mood Tracking'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MoodScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.wb_sunny_outlined),
              title: const Text('Ambient Mode'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AmbientScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.emergency),
              title: const Text('Emergency'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmergencyScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text(
                'Sign Out',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                context.read<AuthBloc>().add(AuthSignOutRequested());
                Navigator.pop(context); // Close drawer
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context).homeScreenTitle,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart),
            label: AppLocalizations.of(context).progressSaved,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.timer),
            label: AppLocalizations.of(context).pomodoroSection,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.folder),
            label: AppLocalizations.of(context).allCategories,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context).settingsScreenTitle,
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? AnimationConfiguration.synchronized(
              duration: const Duration(milliseconds: 600),
              child: ScaleAnimation(
                scale: 1.0,
                child: FadeInAnimation(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primaryContainer,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: FloatingActionButton(
                      onPressed: _showAddTaskDialog,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  String? _selectedCategoryId;
  final bool _sortByPriority = false;
  final bool _isSearching = false;
  final String _searchQuery = '';
  TaskPriority? _filterPriority;
  bool? _filterCompleted;

  @override
  void initState() {
    super.initState();
    context.read<TaskBloc>().add(LoadTasks());
    context.read<CategoryBloc>().add(LoadCategories());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCategoryFilter(),
        TextButton(
          onPressed: () {
            for (var i = 0; i < 15; i++) {
              final task = Task(
                id:
                    DateTime.now().millisecondsSinceEpoch.toString() +
                    i.toString(),
                title: 'New Task $i',
                description: i.isEven
                    ? null
                    : 'This is a description for task $i',
                priority: TaskPriority.values[i % TaskPriority.values.length],
                dueDate: DateTime.now().add(Duration(days: i)),
                categoryId: 'Work',
                createdAt: DateTime.now(),
                updatedAt: DateTime.now(),
              );
              context.read<TaskBloc>().add(AddTask(task));
            }
          },
          child: Text('add'),
        ),

        Expanded(
          child: BlocBuilder<TaskBloc, TaskState>(
            builder: (context, state) {
              if (state is TaskLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is TaskLoaded) {
                var filteredTasks = _selectedCategoryId == null
                    ? state.tasks
                    : state.tasks
                          .where(
                            (task) => task.categoryId == _selectedCategoryId,
                          )
                          .toList();

                // Filter by search query
                if (_searchQuery.isNotEmpty) {
                  filteredTasks = filteredTasks.where((task) {
                    final titleLower = task.title.toLowerCase();
                    final descLower = task.description?.toLowerCase() ?? '';
                    final queryLower = _searchQuery.toLowerCase();
                    return titleLower.contains(queryLower) ||
                        descLower.contains(queryLower);
                  }).toList();
                }

                // Filter by priority
                if (_filterPriority != null) {
                  filteredTasks = filteredTasks
                      .where((task) => task.priority == _filterPriority)
                      .toList();
                }

                // Filter by completion status
                if (_filterCompleted != null) {
                  filteredTasks = filteredTasks
                      .where((task) => task.isCompleted == _filterCompleted)
                      .toList();
                }

                // Sort by priority if enabled (high priority first)
                if (_sortByPriority) {
                  filteredTasks.sort((a, b) {
                    // First sort by completion status (incomplete first)
                    if (a.isCompleted != b.isCompleted) {
                      return a.isCompleted ? 1 : -1;
                    }
                    // Then sort by priority (high first)
                    return b.priority.index.compareTo(a.priority.index);
                  });
                }

                if (filteredTasks.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildTaskList(filteredTasks);
              } else if (state is TaskError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryFilter() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded) {
          return Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip(null, 'All', Icons.all_inclusive),
                ...state.categories.map(
                  (category) => _buildCategoryChip(
                    category.id,
                    category.name,
                    Icons.folder,
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCategoryChip(String? categoryId, String label, IconData icon) {
    final isSelected = _selectedCategoryId == categoryId;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 4),
            Text(
              label == 'All'
                  ? AppLocalizations.of(context).allCategories
                  : label,
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategoryId = selected ? categoryId : null;
          });
        },
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: AnimationConfiguration.synchronized(
        duration: const Duration(milliseconds: 800),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleAnimation(
              scale: 0.8,
              child: FadeInAnimation(
                delay: const Duration(milliseconds: 200),
                child: Icon(
                  Icons.task_alt,
                  size: 80,
                  color: Theme.of(
                    context,
                  ).colorScheme.primary.withValues(alpha: 0.5),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FadeInAnimation(
              delay: const Duration(milliseconds: 400),
              child: Text(
                'No tasks yet',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 8),
            FadeInAnimation(
              delay: const Duration(milliseconds: 600),
              child: Text(
                AppLocalizations.of(context).tapToAddFirstTask,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    return AnimationLimiter(
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 500),
            child: SlideAnimation(
              verticalOffset: 60.0,
              curve: Curves.easeOutCubic,
              child: FadeInAnimation(
                curve: Curves.easeOut,
                child: ScaleAnimation(
                  scale: 0.95,
                  curve: Curves.easeOutBack,
                  child: TaskItem(
                    task: tasks[index],
                    onToggle: () {
                      context.read<TaskBloc>().add(
                        ToggleTaskCompletion(tasks[index].id),
                      );
                    },
                    onEdit: () {
                      _showEditTaskDialog(tasks[index]);
                    },
                    onDelete: () {
                      _showDeleteConfirmation(tasks[index]);
                    },
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddTaskDialog() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    String? selectedCategoryId;
    TaskPriority selectedPriority = TaskPriority.medium;
    DateTime? selectedDueDate;

    showDialog(
      context: context,
      builder: (context) => BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).addTaskTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'Enter task title',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Enter task description',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TaskPriority>(
                  value: selectedPriority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: TaskPriority.values
                      .map(
                        (priority) => DropdownMenuItem<TaskPriority>(
                          value: priority,
                          child: Text(priority.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedPriority = value;
                    }
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      selectedDueDate = pickedDate;
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Due Date (Optional)',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      selectedDueDate != null
                          ? DateFormatter.formatDate(selectedDueDate!)
                          : 'Select due date',
                      style: TextStyle(
                        color: selectedDueDate != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(100),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (state is CategoryLoaded && state.categories.isNotEmpty)
                  DropdownButtonFormField<String?>(
                    value: selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Category (Optional)',
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('No Category'),
                      ),
                      ...state.categories.map(
                        (category) => DropdownMenuItem<String?>(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      selectedCategoryId = value;
                    },
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    final task = Task(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      title: titleController.text,
                      description: descriptionController.text.isEmpty
                          ? null
                          : descriptionController.text,
                      priority: selectedPriority,
                      dueDate: selectedDueDate,
                      categoryId: selectedCategoryId,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    context.read<TaskBloc>().add(AddTask(task));
                    Navigator.of(context).pop();
                  }
                },
                child: Text(AppLocalizations.of(context).addButton),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    final titleController = TextEditingController(text: task.title);
    final descriptionController = TextEditingController(text: task.description);
    String? selectedCategoryId = task.categoryId;
    TaskPriority selectedPriority = task.priority;
    DateTime? selectedDueDate = task.dueDate;

    showDialog(
      context: context,
      builder: (context) => BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context).editTaskTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Task Title',
                    hintText: 'Enter task title',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description (Optional)',
                    hintText: 'Enter task description',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<TaskPriority>(
                  value: selectedPriority,
                  decoration: const InputDecoration(labelText: 'Priority'),
                  items: TaskPriority.values
                      .map(
                        (priority) => DropdownMenuItem<TaskPriority>(
                          value: priority,
                          child: Text(priority.name.toUpperCase()),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      selectedPriority = value;
                    }
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: selectedDueDate ?? DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      selectedDueDate = pickedDate;
                    }
                  },
                  child: InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Due Date (Optional)',
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    child: Text(
                      selectedDueDate != null
                          ? DateFormatter.formatDate(selectedDueDate!)
                          : 'Select due date',
                      style: TextStyle(
                        color: selectedDueDate != null
                            ? Theme.of(context).colorScheme.onSurface
                            : Theme.of(
                                context,
                              ).colorScheme.onSurface.withAlpha(100),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (state is CategoryLoaded && state.categories.isNotEmpty)
                  DropdownButtonFormField<String?>(
                    value: selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Category (Optional)',
                    ),
                    items: [
                      const DropdownMenuItem<String?>(
                        value: null,
                        child: Text('No Category'),
                      ),
                      ...state.categories.map(
                        (category) => DropdownMenuItem<String?>(
                          value: category.id,
                          child: Text(category.name),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      selectedCategoryId = value;
                    },
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titleController.text.isNotEmpty) {
                    final updatedTask = task.copyWith(
                      title: titleController.text,
                      description: descriptionController.text.isEmpty
                          ? null
                          : descriptionController.text,
                      priority: selectedPriority,
                      dueDate: selectedDueDate,
                      categoryId: selectedCategoryId,
                      updatedAt: DateTime.now(),
                    );
                    context.read<TaskBloc>().add(UpdateTask(updatedTask));
                    Navigator.of(context).pop();
                  }
                },
                child: Text(AppLocalizations.of(context).updateButton),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteConfirmation(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context).deleteTaskTitle),
        content: Text(
          AppLocalizations.of(context).confirmDeleteTask(task.title),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(AppLocalizations.of(context).cancelButton),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<TaskBloc>().add(DeleteTask(task.id));
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context).deleteButton),
          ),
        ],
      ),
    );
  }
}
