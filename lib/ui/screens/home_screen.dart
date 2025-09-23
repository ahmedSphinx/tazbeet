import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../../l10n/generated/app_localizations.dart';
import '../../blocs/task/task_bloc.dart';
import '../../blocs/task/task_event.dart';
import '../../blocs/task/task_state.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_event.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_state.dart';
import '../../models/task.dart';

import '../widgets/task_item.dart';
import '../widgets/hero_section.dart';
import '../widgets/quick_actions_card.dart';
import '../widgets/progress_indicator_card.dart' hide CircularProgressCard;
import '../widgets/search_bar.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/empty_state.dart';
import '../widgets/error_display.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/edit_task_dialog.dart';
import '../widgets/circular_progress_card.dart';
import 'ambient_screen.dart';
import 'category_screen.dart';
import 'emergency_screen.dart';
import 'mood_screen.dart';
import 'pomodoro_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController _moodTabController;
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  Timer? _debounceTimer;
  bool _isRefreshing = false;
  bool _isConnected = true;
  int _selectedIndex = 0;
  String? _selectedCategoryId;
  TaskPriority? _filterPriority;
  bool? _filterCompleted;
  bool _sortByPriority = false;

  // Debounced search functionality
  void _onSearchChanged(String value) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      setState(() {});
    });
  }

  // Pull-to-refresh functionality
  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);

    // Check connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    setState(
      () => _isConnected = connectivityResult != ConnectivityResult.none,
    );

    if (_isConnected) {
      context.read<TaskBloc>().add(LoadTasks());
      context.read<CategoryBloc>().add(LoadCategories());
      context.read<UserBloc>().add(LoadUser());

      // Wait for data to load
      await Future.delayed(const Duration(seconds: 1));
    }

    setState(() => _isRefreshing = false);
  }

  @override
  void initState() {
    super.initState();
    _moodTabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    _searchController = TextEditingController();

    // Load initial data
    context.read<TaskBloc>().add(LoadTasks());
    context.read<CategoryBloc>().add(LoadCategories());
    context.read<UserBloc>().add(LoadUser());

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() => _isConnected = result != ConnectivityResult.none);
    });
  }

  @override
  void dispose() {
    _moodTabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _searchController.clear();
      _filterPriority = null;
      _filterCompleted = null;
      _selectedCategoryId = null;
      _sortByPriority = false;
    });
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => const FilterDialog(),
    );
  }

  void _showAddTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddTaskDialog(
        onTaskAdded: (task) {
          context.read<TaskBloc>().add(AddTask(task));
          _showSuccessSnackBar(AppLocalizations.of(context).taskCompleted);
        },
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: AppLocalizations.of(context).localeName == 'ar'
          ? TextDirection.rtl
          : TextDirection.ltr,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              Theme.of(context).brightness == Brightness.dark
              ? Brightness.light
              : Brightness.dark,
        ),
        child: Scaffold(
          appBar: _buildAppBar(),
          drawer: _buildDrawer(),
          body: _buildBody(),
          bottomNavigationBar: _buildBottomNavigationBar(),
          floatingActionButton: _buildFloatingActionButton(),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: _selectedIndex == 0 && _searchController.text.isNotEmpty
          ? CustomSearchBar(
              controller: _searchController,
              onChanged: _onSearchChanged,
              hintText: AppLocalizations.of(context).searchHint,
            )
          : Text(
              _getAppBarTitle(),
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
      actions: _buildAppBarActions(),
      bottom: _selectedIndex == 4 ? _buildTabBar() : null,
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return AppLocalizations.of(context).appTitle;
      case 1:
        return AppLocalizations.of(context).progressSaved;
      case 2:
        return AppLocalizations.of(context).pomodoroSection;
      case 3:
        return AppLocalizations.of(context).allCategories;
      case 4:
        return AppLocalizations.of(context).moodTracking;
      default:
        return AppLocalizations.of(context).appTitle;
    }
  }

  List<Widget> _buildAppBarActions() {
    if (_selectedIndex == 0) {
      return [
        IconButton(
          icon: Icon(
            _sortByPriority ? Icons.sort : Icons.filter_list,
            color: Colors.white,
          ),
          onPressed: () {
            if (_sortByPriority) {
              setState(() => _sortByPriority = !_sortByPriority);
            } else {
              _showFilterDialog();
            }
          },
          tooltip: _sortByPriority
              ? AppLocalizations.of(context).priorityLabel
              : AppLocalizations.of(context).filterTasksTitle,
        ),
        IconButton(
          icon: Icon(
            _searchController.text.isNotEmpty ? Icons.close : Icons.search,
            color: Colors.white,
          ),
          onPressed: () {
            if (_searchController.text.isNotEmpty) {
              _searchController.clear();
              setState(() {});
            } else {
              // Focus search - handled by CustomSearchBar
            }
          },
          tooltip: AppLocalizations.of(context).searchHint,
        ),
      ];
    } else if (_selectedIndex == 2) {
      return [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            // TODO: Open pomodoro settings
          },
          tooltip: AppLocalizations.of(context).settingsScreenTitle,
        ),
      ];
    }
    return [];
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      controller: _moodTabController,
      tabs: [
        Tab(
          text: AppLocalizations.of(context).today,
          icon: const Icon(Icons.today),
        ),
        Tab(
          text: AppLocalizations.of(context).history,
          icon: const Icon(Icons.history),
        ),
        Tab(
          text: AppLocalizations.of(context).insights,
          icon: const Icon(Icons.insights),
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          /*  const Divider(),
          _buildDrawerItems(),
          const Divider(), */
          _buildDrawerFooter(),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          String userName = AppLocalizations.of(context).appTitle;
          String? userPhotoUrl;

          if (state is UserLoaded) {
            userName = state.user.name;
            userPhotoUrl = state.user.profileImageUrl;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: userPhotoUrl != null && userPhotoUrl.isNotEmpty
                    ? NetworkImage(userPhotoUrl)
                    : null,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: (userPhotoUrl == null || userPhotoUrl.isEmpty)
                    ? Icon(
                        Icons.person,
                        size: 40,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : null,
              ),
              const SizedBox(height: 12),
              Text(
                userName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                AppLocalizations.of(context).splashTagline,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerItems() {
    return Column(
      children: [
        _buildDrawerItem(
          icon: Icons.home,
          title: AppLocalizations.of(context).homeScreenTitle,
          isSelected: _selectedIndex == 0,
          onTap: () => _onItemTapped(0),
        ),
        _buildDrawerItem(
          icon: Icons.bar_chart,
          title: AppLocalizations.of(context).progressSaved,
          isSelected: _selectedIndex == 1,
          onTap: () => _onItemTapped(1),
        ),
        _buildDrawerItem(
          icon: Icons.timer,
          title: AppLocalizations.of(context).pomodoroSection,
          isSelected: _selectedIndex == 2,
          onTap: () => _onItemTapped(2),
        ),
        _buildDrawerItem(
          icon: Icons.folder,
          title: AppLocalizations.of(context).allCategories,
          isSelected: _selectedIndex == 3,
          onTap: () => _onItemTapped(3),
        ),
        _buildDrawerItem(
          icon: Icons.mood,
          title: AppLocalizations.of(context).moodTracking,
          isSelected: _selectedIndex == 4,
          onTap: () => _onItemTapped(4),
        ),
      ],
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.onSurface,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  Widget _buildDrawerFooter() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.wb_sunny_outlined),
          title: Text(AppLocalizations.of(context).ambientMode),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AmbientScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.emergency),
          title: Text(AppLocalizations.of(context).emergency),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EmergencyScreen()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(AppLocalizations.of(context).settingsScreenTitle),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            );
          },
        ),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.red),
          title: Text(
            AppLocalizations.of(context).signOut,
            style: const TextStyle(color: Colors.red),
          ),
          onTap: () {
            context.read<AuthBloc>().add(AuthSignOutRequested());
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: _isRefreshing && !_isConnected
          ? _buildOfflineView()
          : _screens[_selectedIndex],
    );
  }

  Widget _buildOfflineView() {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.wifi_off,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context).allSessionsComplete,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).allSessionsComplete,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
      type: BottomNavigationBarType.shifting,
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
          icon: const Icon(Icons.mood),
          label: AppLocalizations.of(context).moodTracking,
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    if (_selectedIndex != 0) return const SizedBox.shrink();

    return Semantics(
      label: AppLocalizations.of(context).addTaskTitle,
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
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: FloatingActionButton(
          onPressed: _showAddTaskDialog,
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }

  final List<Widget> _screens = [
    const HomeScreenBody(),
    const ProgressScreen(),
    const PomodoroScreen(),
    const CategoryScreen(),
    const MoodScreen(),
  ];
}

class HomeScreenBody extends StatefulWidget {
  const HomeScreenBody({super.key});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  String? _selectedCategoryId;
  final bool _sortByPriority = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskBloc, TaskState>(
      listener: (context, state) {
        if (state is TaskError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            /*    // Hero Section
            _buildHeroSection(), */

            /*  // Quick Actions Card
            Padding(
              padding: const EdgeInsets.all(16),
              child: _buildQuickActionsCard(),
            ), */

            /*   // Progress Cards Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildProgressSection(),
            ), */
            const SizedBox(height: 24),

            // Category Filter
            _buildCategoryFilter(),

            // Task List
            _buildTaskListSection(),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        String userName = AppLocalizations.of(context).appTitle;
        if (userState is UserLoaded) {
          userName = userState.user.name;
        }

        return BlocBuilder<TaskBloc, TaskState>(
          builder: (context, taskState) {
            int todayTasks = 0;
            int completedTasks = 0;

            if (taskState is TaskLoaded) {
              final today = DateTime.now();
              final todayStart = DateTime(today.year, today.month, today.day);
              final todayEnd = todayStart.add(const Duration(days: 1));

              todayTasks = taskState.tasks.where((task) {
                final taskDate = task.dueDate ?? task.createdAt;
                return taskDate.isAfter(todayStart) &&
                    taskDate.isBefore(todayEnd);
              }).length;

              completedTasks = taskState.tasks
                  .where((task) => task.isCompleted)
                  .length;
            }

            return HeroSection(
              userName: userName,
              todayTasks: todayTasks,
              completedTasks: completedTasks,
              onViewAllTasks: () {
                // Navigate to all tasks view
              },
            );
          },
        );
      },
    );
  }

  Widget _buildQuickActionsCard() {
    return QuickActionsCard(
      onAddTask: () {
        // Show add task dialog
        _showAddTaskDialog();
      },
      onStartPomodoro: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PomodoroScreen()),
        );
      },
      onViewProgress: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ProgressScreen()),
        );
      },
      onAddCategory: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CategoryScreen()),
        );
      },
    );
  }

  Widget _buildProgressSection() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, taskState) {
        int todayTasks = 0;
        int completedTasks = 0;

        if (taskState is TaskLoaded) {
          final today = DateTime.now();
          final todayStart = DateTime(today.year, today.month, today.day);
          final todayEnd = todayStart.add(const Duration(days: 1));

          todayTasks = taskState.tasks.where((task) {
            final taskDate = task.dueDate ?? task.createdAt;
            return taskDate.isAfter(todayStart) && taskDate.isBefore(todayEnd);
          }).length;

          completedTasks = taskState.tasks
              .where((task) => task.isCompleted)
              .length;
        }

        return Row(
          children: [
            Expanded(
              child: ProgressIndicatorCard(
                title: AppLocalizations.of(context).daily,
                progress: todayTasks > 0 ? completedTasks / todayTasks : 0.0,
                currentValue: completedTasks,
                targetValue: 8,
                icon: Icons.today,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CircularProgressCard(
                title: AppLocalizations.of(context).weeklyProgress,
                progress: 0.75,
                centerText: '75%',
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryFilter() {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded && state.categories.isNotEmpty) {
          return Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip(
                  null,
                  AppLocalizations.of(context).allCategories,
                  Icons.align_horizontal_left_rounded,
                  Theme.of(context).colorScheme.primary,
                ),
                ...state.categories.map(
                  (category) => _buildCategoryChip(
                    category.id,
                    category.name,
                    Icons.folder,
                    (category.color),
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

  Widget _buildCategoryChip(
    String? categoryId,
    String label,
    IconData icon,
    Color color,
  ) {
    final isSelected = _selectedCategoryId == categoryId;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? Theme.of(context).colorScheme.onPrimaryContainer
                    : Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategoryId = selected ? categoryId : null;
          });
        },
        backgroundColor: !isSelected
            ? color.withValues(alpha: 0.4)
            : Theme.of(context).colorScheme.surface,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget _buildTaskListSection() {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        if (state is TaskLoading) {
          return const LoadingSkeleton();
        } else if (state is TaskLoaded) {
          return TaskListSection(
            tasks: state.tasks,
            selectedCategoryId: _selectedCategoryId,
            sortByPriority: _sortByPriority,
            searchQuery:
                (context
                    .findAncestorStateOfType<_HomeScreenState>()
                    ?._searchController
                    .text) ??
                '',
            filterPriority: (context
                .findAncestorStateOfType<_HomeScreenState>()
                ?._filterPriority),
            filterCompleted: (context
                .findAncestorStateOfType<_HomeScreenState>()
                ?._filterCompleted),
            onTaskToggle: (taskId) {
              context.read<TaskBloc>().add(ToggleTaskCompletion(taskId));
            },
            onTaskEdit: (task) {
              _showEditTaskDialog(task);
            },
            onTaskDelete: (taskId) {
              context.read<TaskBloc>().add(DeleteTask(taskId));
            },
          );
        } else if (state is TaskError) {
          return ErrorDisplay(
            message: state.message,
            onRetry: () {
              context.read<TaskBloc>().add(LoadTasks());
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showAddTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddTaskDialog(
        onTaskAdded: (task) {
          context.read<TaskBloc>().add(AddTask(task));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).taskCompleted),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => EditTaskDialog(
        task: task,
        onTaskUpdated: (updatedTask) {
          context.read<TaskBloc>().add(UpdateTask(updatedTask));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context).settingsSaved),
              backgroundColor: Colors.blue,
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }
}

// New optimized widgets will be created below
class TaskListSection extends StatelessWidget {
  final List<Task> tasks;
  final String? selectedCategoryId;
  final bool sortByPriority;
  final String searchQuery;
  final TaskPriority? filterPriority;
  final bool? filterCompleted;
  final Function(String) onTaskToggle;
  final Function(Task) onTaskEdit;
  final Function(String) onTaskDelete;

  const TaskListSection({
    super.key,
    required this.tasks,
    this.selectedCategoryId,
    this.sortByPriority = false,
    this.searchQuery = '',
    this.filterPriority,
    this.filterCompleted,
    required this.onTaskToggle,
    required this.onTaskEdit,
    required this.onTaskDelete,
  });

  @override
  Widget build(BuildContext context) {
    var filteredTasks = _applyFilters(tasks);

    if (filteredTasks.isEmpty) {
      return const EmptyState();
    }

    return AnimationLimiter(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: filteredTasks.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredList(
            position: index,
            duration: const Duration(milliseconds: 375),
            child: SlideAnimation(
              verticalOffset: 50.0,
              curve: Curves.easeOutCubic,
              child: FadeInAnimation(
                curve: Curves.easeOut,
                child: ScaleAnimation(
                  scale: 0.95,
                  curve: Curves.easeOutBack,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: TaskItem(
                      task: filteredTasks[index],
                      onToggle: () => onTaskToggle(filteredTasks[index].id),
                      onEdit: () => onTaskEdit(filteredTasks[index]),
                      onDelete: () => onTaskDelete(filteredTasks[index].id),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Task> _applyFilters(List<Task> tasks) {
    var filteredTasks = selectedCategoryId == null
        ? tasks
        : tasks.where((task) => task.categoryId == selectedCategoryId).toList();

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      filteredTasks = filteredTasks.where((task) {
        final titleLower = task.title.toLowerCase();
        final descLower = task.description?.toLowerCase() ?? '';
        final queryLower = searchQuery.toLowerCase();
        return titleLower.contains(queryLower) ||
            descLower.contains(queryLower);
      }).toList();
    }

    // Apply priority filter
    if (filterPriority != null) {
      filteredTasks = filteredTasks
          .where((task) => task.priority == filterPriority)
          .toList();
    }

    // Apply completion filter
    if (filterCompleted != null) {
      filteredTasks = filteredTasks
          .where((task) => task.isCompleted == filterCompleted)
          .toList();
    }

    // Apply sorting
    if (sortByPriority) {
      filteredTasks.sort((a, b) {
        if (a.isCompleted != b.isCompleted) {
          return a.isCompleted ? 1 : -1;
        }
        return b.priority.index.compareTo(a.priority.index);
      });
    }

    return filteredTasks;
  }
}

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Wrap(
        children: [
          ListTile(
            title: Text(
              AppLocalizations.of(context).filterTasksTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).priorityLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: Text(AppLocalizations.of(context).allLabel),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: Text(
                        AppLocalizations.of(context).highPriorityLabel,
                      ),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: Text(
                        AppLocalizations.of(context).mediumPriorityLabel,
                      ),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: Text(
                        AppLocalizations.of(context).lowPriorityLabel,
                      ),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context).statusLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    FilterChip(
                      label: Text(AppLocalizations.of(context).allLabel),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: Text(AppLocalizations.of(context).incompleteLabel),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                    FilterChip(
                      label: Text(AppLocalizations.of(context).completedLabel),
                      selected: false,
                      onSelected: (selected) {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          OverflowBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context).cancelButton),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context).applyButton),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context).clearAllButton),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
