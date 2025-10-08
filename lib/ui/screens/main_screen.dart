// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_event.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/services/app_logging.dart';
import 'package:tazbeet/ui/screens/mood_settings_screen.dart';
import 'package:tazbeet/ui/screens/notifications_dashboard.dart';
import 'package:tazbeet/ui/screens/recurring_tasks_screen.dart';
import 'package:tazbeet/ui/screens/splash_screen.dart';
import 'package:tazbeet/ui/widgets/edit_task_dialog.dart';
import 'package:tazbeet/ui/widgets/empty_state.dart';
import 'package:tazbeet/ui/widgets/error_display.dart';
import 'package:tazbeet/ui/widgets/loading_skeleton.dart';
import 'package:tazbeet/ui/widgets/progress_indicator_card.dart';
import 'package:tazbeet/ui/widgets/quick_actions_card.dart';
import 'package:tazbeet/ui/widgets/task_item.dart';
import 'dart:async';

import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_event.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_event.dart';
import '../../blocs/auth/auth_state.dart';
import '../screens/profile_screen.dart';
import '../../blocs/user/user_event.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_state.dart';
import '../../models/task.dart';
import '../../services/tutorial_service.dart';

import '../widgets/hero_section.dart';
import '../widgets/search_bar.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/filter_dialog.dart';
import '../widgets/home_screen_body.dart';
import 'ambient_screen.dart';
import 'category_screen.dart';
import 'emergency_screen.dart';
import 'mood_screen.dart';
import 'pomodoro_screen.dart';
import 'progress_screen.dart';
import 'settings_screen.dart';
import 'task_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
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
  bool _isSearching = false;

  // Tutorial keys
  final GlobalKey _addTaskKey = GlobalKey();
  final GlobalKey _pomodoroKey = GlobalKey();
  final GlobalKey _categoryFilterKey = GlobalKey();
  final GlobalKey _moodTrackingKey = GlobalKey();
  final GlobalKey _taskDetailsKey = GlobalKey();

  final TutorialService _tutorialService = TutorialService();

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
    setState(() => _isConnected = connectivityResult != ConnectivityResult.none);

    if (_isConnected) {
      context.read<TaskListBloc>().add(LoadTasks());
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
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    moodTabController = TabController(length: 3, vsync: this);

    WidgetsBinding.instance.addObserver(this);

    // Load initial data
    context.read<TaskListBloc>().add(LoadTasks());
    context.read<CategoryBloc>().add(LoadCategories());
    context.read<UserBloc>().add(LoadUser());

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((result) {
      _isConnected = result != ConnectivityResult.none;
    });

    // Show tutorial for first time users
    _checkAndShowTutorial();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    moodTabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  bool hasShownTutorial = true;
  void _checkAndShowTutorial() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasShownTutorial = prefs.getBool('hasShownTutorial') ?? false;

    if (!hasShownTutorial) {
      // Wait for the widget to build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _tutorialService.initTargets(addTaskKey: _addTaskKey, pomodoroKey: _pomodoroKey, categoryFilterKey: _categoryFilterKey, moodTrackingKey: _moodTrackingKey, taskDetailsKey: _taskDetailsKey, context: context);
        _tutorialService.showTutorial(context, () {
          hasShownTutorial = true;
          prefs.setBool('hasShownTutorial', true);
        });
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<TaskListBloc>().add(LoadTasks());
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _searchController.clear();
      _filterPriority = null;
      _filterCompleted = null;
      _selectedCategoryId = null;
      _sortByPriority = false;
      _isSearching = false;
    });

    // Show Pomodoro tutorial step if Pomodoro tab selected and tutorial not shown
    if (index == 2) {
      SharedPreferences.getInstance().then((prefs) {
        bool hasShownPomodoroTutorial = prefs.getBool('hasShownPomodoroTutorial') ?? false;
        if (!hasShownPomodoroTutorial) {
          // Ensure targets are initialized before showing tutorial
          _tutorialService.initTargets(addTaskKey: _addTaskKey, pomodoroKey: _pomodoroKey, categoryFilterKey: _categoryFilterKey, moodTrackingKey: _moodTrackingKey, taskDetailsKey: _taskDetailsKey, context: context);
          _tutorialService.showTutorial(context, () {
            prefs.setBool('hasShownPomodoroTutorial', true);
          }, targetIds: ['Pomodoro']);
        }
      });
    }
  }

  void _showFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => FilterDialog(
        initialPriority: _filterPriority,
        initialCompleted: _filterCompleted,
        onPriorityChanged: (priority) {
          setState(() => _filterPriority = priority);
        },
        onCompletedChanged: (completed) {
          setState(() => _filterCompleted = completed);
        },
        onClear: () {
          setState(() {
            _filterPriority = null;
            _filterCompleted = null;
          });
        },
      ),
    );
  }

  void _showAddTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => AddTaskDialog(
        onTaskAdded: (task) {
          context.read<TaskListBloc>().add(AddTask(task));
          _showSuccessSnackBar(AppLocalizations.of(context)!.taskCompleted);
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthProfileIncomplete) {
          // Navigate to profile completion screen
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const ProfileScreen(isProfileCompletion: true)));
        }
      },
      child: Directionality(
        textDirection: (AppLocalizations.of(context)?.localeName ?? 'en') == 'ar' ? TextDirection.rtl : TextDirection.ltr,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark),
          child: Scaffold(
            appBar: _buildAppBar(),
            drawer: _buildDrawer(),
            body: _buildBody(),
            bottomNavigationBar: hasShownTutorial ? _buildBottomNavigationBar() : _buildBottomNavigationBarTutorial(),
            floatingActionButton: _buildFloatingActionButton(),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    AppLogging.logInfo(_getAppBarTitle());
    return AppBar(
      foregroundColor: Colors.white,
      title: /* _selectedIndex == 0 && !_isSearching && _searchController.text.isEmpty
          ? */ Text(
        _getAppBarTitle(),
        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
      ),
      /* : null */
      actions: _buildAppBarActions(),

      /* [
        ..._
       IconButton(
          icon: const Icon(Icons.telegram, color: Colors.red),
          onPressed: () {
            _checkAndShowTutorial();
            HapticFeedback.lightImpact();
          },
          tooltip: AppLocalizations.of(context)!.priorityLabel,
        ) ], */
      bottom: _selectedIndex == 4 ? _buildTabBar() : (_selectedIndex == 0 && (_isSearching || _searchController.text.isNotEmpty) ? _buildSearchBar() : null),
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withAlpha(204)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
      ),
    );
  }

  String _getAppBarTitle() {
    switch (_selectedIndex) {
      case 0:
        return AppLocalizations.of(context)?.appTitle ?? 'Tasks';
      case 1:
        return AppLocalizations.of(context)?.progressSaved ?? 'Progress';
      case 2:
        return AppLocalizations.of(context)?.pomodoroSection ?? 'Pomodoro';
      case 3:
        return AppLocalizations.of(context)?.allCategories ?? 'Categories';
      default:
        return AppLocalizations.of(context)?.moodTracking ?? 'Mood';
    }
  }

  List<Widget> _buildAppBarActions() {
    if (_selectedIndex == 0) {
      return [
        IconButton(
          icon: const Icon(Icons.sort, color: Colors.white),
          onPressed: () {
            _checkAndShowTutorial();
            HapticFeedback.lightImpact();
            setState(() => _sortByPriority = !_sortByPriority);
          },
          onLongPress: _showFilterDialog,
          tooltip: AppLocalizations.of(context)?.priorityLabel ?? 'Priority',
        ),
        IconButton(
          icon: Icon(_isSearching || _searchController.text.isNotEmpty ? Icons.close : Icons.search, color: Colors.white),
          onPressed: () {
            HapticFeedback.lightImpact();
            setState(() {
              if (_isSearching || _searchController.text.isNotEmpty) {
                _isSearching = false;
                _searchController.clear();
              } else {
                _isSearching = true;
              }
            });
          },
          tooltip: _isSearching || _searchController.text.isNotEmpty ? 'Close search' : (AppLocalizations.of(context)?.searchHint ?? 'Search'),
        ),
      ];
    } else if (_selectedIndex == 2) {
      return [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            //    showCustomizationSheet(context) ;
          },
          tooltip: AppLocalizations.of(context)!.settingsScreenTitle,
        ),
      ];
    } else if (_selectedIndex == 4) {
      return [
        IconButton(
          icon: const Icon(Icons.settings, color: Colors.white),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MoodSettingsScreen()));
          },
          tooltip: AppLocalizations.of(context)!.settingsScreenTitle,
        ),
      ];
    }
    return [];
  }

  PreferredSizeWidget _buildTabBar() {
    return TabBar(
      indicatorColor: Colors.white,
      controller: moodTabController,
      tabs: [
        Tab(
          text: AppLocalizations.of(context)?.today ?? 'Today',
          icon: const Icon(Icons.today, color: Colors.white),
        ),
        Tab(text: AppLocalizations.of(context)?.history ?? 'History', icon: const Icon(Icons.history)),
        Tab(text: AppLocalizations.of(context)?.insights ?? 'Insights', icon: const Icon(Icons.insights)),
      ],
    );
  }

  PreferredSizeWidget _buildSearchBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: CustomSearchBar(
          controller: _searchController,
          onChanged: _onSearchChanged,
          hintText: AppLocalizations.of(context)!.searchHint,
          autofocus: _isSearching,
          onSubmitted: (value) {
            setState(() {
              _isSearching = false;
              _searchController.clear();
            });
          },
        ),
      ),
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
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)])),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          String userName = AppLocalizations.of(context)!.appTitle;
          String? userPhotoUrl;

          if (state is UserLoaded) {
            userName = state.user.name;
            userPhotoUrl = state.user.profileImageUrl;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (userPhotoUrl != null && userPhotoUrl.isNotEmpty)
                ClipOval(
                  child: Image.network(
                    userPhotoUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                        child: Icon(Icons.person, size: 40, color: Theme.of(context).colorScheme.onPrimary),
                      );
                    },
                  ),
                )
              else
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(Icons.person, size: 40, color: Theme.of(context).colorScheme.onPrimary),
                ),
              const SizedBox(height: 12),
              Text(
                userName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              Text(AppLocalizations.of(context)!.splashTagline, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8))),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerItems() {
    return Column(
      children: [
        _buildDrawerItem(icon: Icons.home, title: AppLocalizations.of(context)!.homeScreenTitle, isSelected: _selectedIndex == 0, onTap: () => _onItemTapped(0)),
        _buildDrawerItem(icon: Icons.bar_chart, title: AppLocalizations.of(context)!.progressSaved, isSelected: _selectedIndex == 1, onTap: () => _onItemTapped(1)),
        _buildDrawerItem(icon: Icons.timer, title: AppLocalizations.of(context)!.pomodoroSection, isSelected: _selectedIndex == 2, onTap: () => _onItemTapped(2)),
        _buildDrawerItem(icon: Icons.folder, title: AppLocalizations.of(context)!.allCategories, isSelected: _selectedIndex == 3, onTap: () => _onItemTapped(3)),
        _buildDrawerItem(icon: Icons.mood, title: AppLocalizations.of(context)!.moodTracking, isSelected: _selectedIndex == 4, onTap: () => _onItemTapped(4)),
      ],
    );
  }

  Widget _buildDrawerItem({required IconData icon, required String title, required bool isSelected, required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface),
      title: Text(
        title,
        style: TextStyle(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
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
          title: Text(AppLocalizations.of(context)!.ambientMode),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AmbientScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.emergency),
          title: Text(AppLocalizations.of(context)!.emergency),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: Text(AppLocalizations.of(context)!.notificationsSection),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsDashboard()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.replay),
          title: Text(AppLocalizations.of(context)!.recurringTasksManager),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RecurringTasksScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: Text(AppLocalizations.of(context)!.settingsScreenTitle),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
          },
        ),
        ListTile(
          leading: Icon(Icons.logout, color: Colors.red),
          title: Text(AppLocalizations.of(context)!.signOut, style: const TextStyle(color: Colors.red)),
          onTap: () {
            context.read<AuthBloc>().add(AuthSignOutRequested());
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SplashScreen()), (route) => false);
          },
        ),
      ],
    );
  }

  Widget _buildBody() {
    return RefreshIndicator(onRefresh: _onRefresh, child: _isRefreshing && !_isConnected ? _buildOfflineView() : _screens[_selectedIndex]);
  }

  Widget _buildOfflineView() {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(Icons.wifi_off, size: 64, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.allSessionsComplete, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.allSessionsComplete,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
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
        BottomNavigationBarItem(icon: const Icon(Icons.home), label: AppLocalizations.of(context)?.homeScreenTitle ?? 'Home'),
        BottomNavigationBarItem(icon: const Icon(Icons.bar_chart), label: AppLocalizations.of(context)?.progressSaved ?? 'Progress'),
        BottomNavigationBarItem(icon: const Icon(Icons.timer), label: AppLocalizations.of(context)?.pomodoroSection ?? 'Pomodoro'),
        BottomNavigationBarItem(icon: const Icon(Icons.folder), label: AppLocalizations.of(context)?.allCategories ?? 'Categories'),
        BottomNavigationBarItem(icon: const Icon(Icons.mood), label: AppLocalizations.of(context)?.moodTracking ?? 'Mood'),
      ],
    );
  }

  Widget _buildBottomNavigationBarTutorial() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, AppLocalizations.of(context)?.homeScreenTitle ?? 'Home'),
            _buildNavItem(1, Icons.bar_chart, AppLocalizations.of(context)?.progressSaved ?? 'Progress'),
            _buildNavItem(2, Icons.timer, AppLocalizations.of(context)?.pomodoroSection ?? 'Pomodoro', key: _pomodoroKey),
            _buildNavItem(3, Icons.folder, AppLocalizations.of(context)?.allCategories ?? 'Categories'),
            _buildNavItem(4, Icons.mood, AppLocalizations.of(context)?.moodTracking ?? 'Mood', key: _moodTrackingKey),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, {GlobalKey? key}) {
    final isSelected = _selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        key: key,
        onTap: () => _onItemTapped(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant, size: 24),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    if (_selectedIndex != 0) return const SizedBox.shrink();

    return Semantics(
      label: AppLocalizations.of(context)!.addTaskTitle,
      child: Container(
        key: _addTaskKey,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primaryContainer], begin: Alignment.topLeft, end: Alignment.bottomRight),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))],
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

  List<Widget> get _screens => [
    HomeScreenBody(
      selectedCategoryId: _selectedCategoryId,
      sortByPriority: _sortByPriority,
      searchQuery: _searchController.text,
      filterPriority: _filterPriority,
      filterCompleted: _filterCompleted,
      onCategoryChanged: (id) => setState(() => _selectedCategoryId = id),
      categoryFilterKey: _categoryFilterKey,
    ),
    const ProgressScreen(),
    const PomodoroScreen(),
    const CategoryScreen(),
    const MoodScreen(),
  ];
}

class HomeScreenBody extends StatefulWidget {
  final String? selectedCategoryId;
  final bool sortByPriority;
  final String searchQuery;
  final TaskPriority? filterPriority;
  final bool? filterCompleted;
  final Function(String?)? onCategoryChanged;
  final GlobalKey? categoryFilterKey;

  const HomeScreenBody({super.key, this.selectedCategoryId, this.sortByPriority = false, this.searchQuery = '', this.filterPriority, this.filterCompleted, this.onCategoryChanged, this.categoryFilterKey});

  @override
  State<HomeScreenBody> createState() => _HomeScreenBodyState();
}

class _HomeScreenBodyState extends State<HomeScreenBody> {
  String? _selectedCategoryId;

  @override
  Widget build(BuildContext context) {
    return BlocListener<TaskListBloc, TaskListState>(
      listener: (context, state) {
        if (state is TaskListError) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
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
        String userName = AppLocalizations.of(context)!.appTitle;
        if (userState is UserLoaded) {
          userName = userState.user.name;
        }

        return BlocBuilder<TaskListBloc, TaskListState>(
          builder: (context, taskState) {
            int todayTasks = 0;
            int completedTasks = 0;

            if (taskState is TaskListLoaded) {
              final today = DateTime.now();
              final todayStart = DateTime(today.year, today.month, today.day);
              final todayEnd = todayStart.add(const Duration(days: 1));

              todayTasks = taskState.tasks.where((task) {
                final taskDate = task.dueDate ?? task.createdAt;
                return taskDate.isAfter(todayStart) && taskDate.isBefore(todayEnd);
              }).length;

              completedTasks = taskState.tasks.where((task) => task.isCompleted).length;
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
        Navigator.push(context, MaterialPageRoute(builder: (context) => const PomodoroScreen()));
      },
      onViewProgress: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProgressScreen()));
      },
      onAddCategory: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const CategoryScreen()));
      },
    );
  }

  Widget _buildProgressSection() {
    return BlocBuilder<TaskListBloc, TaskListState>(
      builder: (context, taskState) {
        int todayTasks = 0;
        int completedTasks = 0;

        if (taskState is TaskListLoaded) {
          final today = DateTime.now();
          final todayStart = DateTime(today.year, today.month, today.day);
          final todayEnd = todayStart.add(const Duration(days: 1));

          todayTasks = taskState.tasks.where((task) {
            final taskDate = task.dueDate ?? task.createdAt;
            return taskDate.isAfter(todayStart) && taskDate.isBefore(todayEnd);
          }).length;

          completedTasks = taskState.tasks.where((task) => task.isCompleted).length;
        }

        return Row(
          children: [
            Expanded(
              child: ProgressIndicatorCard(
                title: AppLocalizations.of(context)!.daily,
                progress: todayTasks > 0 ? completedTasks / todayTasks : 0.0,
                currentValue: completedTasks,
                targetValue: 8,
                icon: Icons.today,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CircularProgressCard(title: AppLocalizations.of(context)!.weeklyProgress, progress: 0.75, centerText: '75%', color: Theme.of(context).colorScheme.secondary),
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
            key: widget.categoryFilterKey,
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildCategoryChip(null, AppLocalizations.of(context)!.allCategories, Icons.align_horizontal_left_rounded, Theme.of(context).colorScheme.primary),
                ...state.categories.map((category) => _buildCategoryChip(category.id, category.name, Icons.folder, (category.color))),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCategoryChip(String? categoryId, String label, IconData icon, Color color) {
    final isSelected = _selectedCategoryId == categoryId;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: isSelected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface)),
          ],
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedCategoryId = selected ? categoryId : null;
          });
          widget.onCategoryChanged?.call(_selectedCategoryId);
        },
        backgroundColor: !isSelected ? color.withValues(alpha: 0.4) : Theme.of(context).colorScheme.surface,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }

  Widget _buildTaskListSection() {
    return BlocBuilder<TaskListBloc, TaskListState>(
      builder: (context, state) {
        if (state is TaskListLoading) {
          return const LoadingSkeleton();
        } else if (state is TaskListLoaded) {
          return TaskListSection(
            tasks: state.tasks,
            selectedCategoryId: _selectedCategoryId,
            sortByPriority: widget.sortByPriority,
            searchQuery: widget.searchQuery,
            filterPriority: widget.filterPriority,
            filterCompleted: widget.filterCompleted,
            onTaskToggle: (taskId) {
              context.read<TaskListBloc>().add(ToggleTaskCompletion(taskId));
            },
            onTaskEdit: (task) {
              _showEditTaskDialog(task);
            },
            onTaskDelete: (taskId) {
              context.read<TaskListBloc>().add(DeleteTask(taskId));
            },
          );
        } else if (state is TaskListError) {
          return ErrorDisplay(
            message: state.message,
            onRetry: () {
              context.read<TaskListBloc>().add(LoadTasks());
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
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => AddTaskDialog(
        onTaskAdded: (task) {
          context.read<TaskListBloc>().add(AddTask(task));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.taskCompleted), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating));
        },
      ),
    );
  }

  void _showEditTaskDialog(Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => EditTaskDialog(
        task: task,
        onTaskUpdated: (updatedTask) {
          context.read<TaskListBloc>().add(UpdateTask(updatedTask));
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.settingsSaved), backgroundColor: Colors.blue, behavior: SnackBarBehavior.floating));
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
    // Memoize filtered and grouped tasks to avoid recomputation on rebuilds
    final groups = _applyFilters(tasks);

    if (groups.isEmpty || groups.values.every((list) => list.isEmpty)) {
      return const EmptyState();
    }

    final l10n = AppLocalizations.of(context)!;
    final groupOrder = ['Overdue', 'Today', 'Tomorrow', 'This Week', 'Later', 'No Date', 'Completed'];
    final groupTitles = {
      'Overdue': l10n.overdueTasks,
      'Today': l10n.todayTasks,
      'Tomorrow': l10n.tomorrowTasks,
      'This Week': l10n.thisWeekTasks,
      'Later': l10n.laterTasks,
      'No Date': l10n.noDateTasks,
      'Completed': l10n.completedTasks,
    };

    // Sort within groups by priority and due date
    for (var entry in groups.entries) {
      entry.value.sort((a, b) {
        int comp = b.priority.index.compareTo(a.priority.index);
        if (comp != 0) return comp;
        return (b.dueDate ?? b.createdAt).compareTo(a.dueDate ?? a.createdAt);
      });
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: groupOrder.where((k) => groups.containsKey(k) && groups[k]!.isNotEmpty).length,
      itemBuilder: (context, groupIndex) {
        final key = groupOrder.where((k) => groups.containsKey(k) && groups[k]!.isNotEmpty).elementAt(groupIndex);
        final tasksInGroup = groups[key]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 4, offset: const Offset(0, 2))],
              ),
              child: Row(
                children: [
                  Icon(_getGroupIcon(key), color: _getGroupColor(context, key)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(groupTitles[key] ?? key, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            AnimationLimiter(
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasksInGroup.length,
                itemBuilder: (context, index) {
                  final task = tasksInGroup[index];
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
                              task: task,
                              onEdit: () => onTaskEdit(task),
                              onDelete: () => onTaskDelete(task.id),
                              onToggle: task.subtasks.isEmpty
                                  ? () => onTaskToggle(task.id)
                                  : () async {
                                      await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetailsScreen(taskId: task.id)));
                                      context.read<TaskListBloc>().add(LoadTasks());
                                    },
                              onLongTap: () async {
                                await Navigator.push(context, MaterialPageRoute(builder: (context) => TaskDetailsScreen(taskId: task.id)));
                                context.read<TaskListBloc>().add(LoadTasks());
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Map<String, List<Task>> _applyFilters(List<Task> tasks) {
    // Filter tasks by category
    var filteredTasks = selectedCategoryId == null ? tasks : tasks.where((task) => task.categoryId == selectedCategoryId).toList();

    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final queryLower = searchQuery.toLowerCase();
      filteredTasks = filteredTasks.where((task) {
        final titleLower = task.title.toLowerCase();
        final descLower = task.description?.toLowerCase() ?? '';
        return titleLower.contains(queryLower) || descLower.contains(queryLower);
      }).toList();
    }

    // Apply priority filter
    if (filterPriority != null) {
      filteredTasks = filteredTasks.where((task) => task.priority == filterPriority).toList();
    }

    // Apply completion filter
    if (filterCompleted != null) {
      filteredTasks = filteredTasks.where((task) => task.isCompleted == filterCompleted).toList();
    }

    // Group tasks by due date categories
    Map<String, List<Task>> groups = {};
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final endOfToday = startOfToday.add(const Duration(days: 1));
    final startOfTomorrow = endOfToday;
    final endOfTomorrow = startOfTomorrow.add(const Duration(days: 1));
    final endOfWeek = startOfToday.add(Duration(days: 7 - now.weekday + 1));

    for (var task in filteredTasks) {
      String key;
      if (task.isCompleted) {
        key = 'Completed';
      } else {
        final due = task.dueDate;
        if (due == null) {
          key = 'No Date';
        } else if (due.isBefore(startOfToday)) {
          key = 'Overdue';
        } else if (due.isBefore(endOfToday)) {
          key = 'Today';
        } else if (due.isBefore(endOfTomorrow)) {
          key = 'Tomorrow';
        } else if (due.isBefore(endOfWeek)) {
          key = 'This Week';
        } else {
          key = 'Later';
        }
      }
      groups.putIfAbsent(key, () => []).add(task);
    }

    return groups;
  }

  IconData _getGroupIcon(String key) {
    switch (key) {
      case 'Overdue':
        return Icons.warning;
      case 'Today':
        return Icons.today;
      case 'Tomorrow':
        return Icons.schedule;
      case 'This Week':
        return Icons.calendar_view_week;
      case 'Later':
        return Icons.date_range;
      case 'No Date':
        return Icons.help_outline;
      case 'Completed':
        return Icons.check_circle;
      default:
        return Icons.list;
    }
  }

  Color _getGroupColor(BuildContext context, String key) {
    switch (key) {
      case 'Overdue':
        return Colors.red;
      case 'Today':
        return Colors.blue;
      case 'Tomorrow':
        return Colors.orange;
      case 'This Week':
        return Colors.green;
      case 'Later':
        return Colors.purple;
      case 'No Date':
        return Colors.grey;
      case 'Completed':
        return Colors.teal;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }
}

class FilterDialog extends StatefulWidget {
  final TaskPriority? initialPriority;
  final bool? initialCompleted;
  final Function(TaskPriority?) onPriorityChanged;
  final Function(bool?) onCompletedChanged;
  final VoidCallback onClear;

  const FilterDialog({super.key, this.initialPriority, this.initialCompleted, required this.onPriorityChanged, required this.onCompletedChanged, required this.onClear});

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  TaskPriority? _selectedPriority;
  bool? _selectedCompleted;

  @override
  void initState() {
    super.initState();
    _selectedPriority = widget.initialPriority;
    _selectedCompleted = widget.initialCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(
        children: [
          ListTile(title: Text(AppLocalizations.of(context)!.filterTasksTitle, style: Theme.of(context).textTheme.titleLarge)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.priorityLabel, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.allLabel),
                      selected: _selectedPriority == null,
                      onSelected: (selected) {
                        setState(() => _selectedPriority = null);
                        widget.onPriorityChanged(null);
                      },
                    ),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.highPriorityLabel),
                      selected: _selectedPriority == TaskPriority.high,
                      onSelected: (selected) {
                        setState(() => _selectedPriority = TaskPriority.high);
                        widget.onPriorityChanged(TaskPriority.high);
                      },
                    ),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.mediumPriorityLabel),
                      selected: _selectedPriority == TaskPriority.medium,
                      onSelected: (selected) {
                        setState(() => _selectedPriority = TaskPriority.medium);
                        widget.onPriorityChanged(TaskPriority.medium);
                      },
                    ),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.lowPriorityLabel),
                      selected: _selectedPriority == TaskPriority.low,
                      onSelected: (selected) {
                        setState(() => _selectedPriority = TaskPriority.low);
                        widget.onPriorityChanged(TaskPriority.low);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.statusLabel, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.allLabel),
                      selected: _selectedCompleted == null,
                      onSelected: (selected) {
                        setState(() => _selectedCompleted = null);
                        widget.onCompletedChanged(null);
                      },
                    ),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.incompleteLabel),
                      selected: _selectedCompleted == false,
                      onSelected: (selected) {
                        setState(() => _selectedCompleted = false);
                        widget.onCompletedChanged(false);
                      },
                    ),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.completedLabel),
                      selected: _selectedCompleted == true,
                      onSelected: (selected) {
                        setState(() => _selectedCompleted = true);
                        widget.onCompletedChanged(true);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          OverflowBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(AppLocalizations.of(context)!.cancelButton)),
              TextButton(
                onPressed: () {
                  widget.onClear();
                  setState(() {
                    _selectedPriority = null;
                    _selectedCompleted = null;
                  });
                },
                child: Text(AppLocalizations.of(context)!.clearAllButton),
              ),
              ElevatedButton(onPressed: () => Navigator.of(context).pop(), child: Text(AppLocalizations.of(context)!.applyButton)),
            ],
          ),
        ],
      ),
    );
  }
}
