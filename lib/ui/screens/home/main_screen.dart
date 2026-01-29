// ignore_for_file: unused_element, unrelated_type_equality_checks

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_event.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/services/app_logging_service.dart';
import 'package:tazbeet/ui/screens/mood_settings_screen.dart';
import 'package:tazbeet/ui/screens/recurring_tasks_screen.dart';
import 'package:tazbeet/ui/screens/splash_screen.dart';
import 'package:tazbeet/ui/widgets/empty_state.dart';
import 'package:tazbeet/ui/screens/analytics/pomodoro_analytics_screen.dart';
import 'package:tazbeet/ui/widgets/focus_mode_widgets.dart';
import 'dart:async';

import '../../../blocs/category/category_bloc.dart';
import '../../../blocs/category/category_event.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../widgets/task_item.dart';
import '../profile_screen.dart';
import '../../../blocs/user/user_event.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_state.dart';
import '../../../blocs/notification/notification_bloc.dart';
import '../../../blocs/notification/notification_event.dart';
import '../../../models/task.dart';
import '../../../services/analytics_service.dart';
import '../admin_panel_screen.dart';

import '../../widgets/search_bar.dart';
import '../../widgets/add_task_dialog.dart';
import '../../widgets/sync_status_indicator.dart';
import '../ambient_screen.dart';
import 'category_screen.dart';
import '../emergency_screen.dart';
import 'home_screen.dart';
import 'mood/ultimate_mood_screen.dart';
import 'pomodoro/pomodoro_home_screen.dart';
import 'progress_screen.dart';
import '../settings_screen.dart';
import '../task_details_screen.dart';
import '../../widgets/common/quick_actions_fab.dart';
import '../../controllers/navigation_controller.dart';
import '../../controllers/tutorial_manager.dart';
import '../../controllers/search_manager.dart';
import '../../controllers/animation_manager.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MainScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  late ScrollController _scrollController;
  late TextEditingController _searchController;
  late TabController moodTabController;
  bool _isRefreshing = false;
  bool _isConnected = true;
  int _selectedIndex = 0;
  bool _isSearching = false;

  // Track selection mode state for back button handling
  bool _isSelectionModeActive = false;

  // Handle selection mode changes from HomeScreen
  void _handleSelectionModeChanged(bool isActive) {
    setState(() {
      _isSelectionModeActive = isActive;
    });
  }

  // New focused controllers
  late final NavigationController _navigationController;
  late final TutorialManager _tutorialManager;
  late final SearchManager _searchManager;
  late final AnimationManager _animationManager;

  // Temporary: Keep old animation controllers for compatibility
  late AnimationController _categorySearchAnimationController;
  late AnimationController _categoryFabAnimationController;
  late Animation<double> _categorySearchFadeAnimation;

  // Screens list - created once to preserve state
  late final List<Widget> _screens;

  // Tutorial keys
  final GlobalKey _addTaskKey = GlobalKey();
  final GlobalKey _pomodoroKey = GlobalKey();
  final GlobalKey _categoryFilterKey = GlobalKey();
  final GlobalKey _moodTrackingKey = GlobalKey();
  final GlobalKey _taskDetailsKey = GlobalKey();

  // Pull-to-refresh functionality
  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);

    // Check connectivity (returns List<ConnectivityResult>)
    final connectivityResults = await Connectivity().checkConnectivity();
    setState(() => _isConnected = connectivityResults.isNotEmpty && !connectivityResults.contains(ConnectivityResult.none));

    if (_isConnected) {
      context.read<TaskListBloc>().add(LoadTasks());
      context.read<CategoryBloc>().add(LoadCategories());
      context.read<UserBloc>().add(LoadUser(forceRefresh: true));

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

    // Initialize new focused controllers
    _navigationController = NavigationController();
    _tutorialManager = TutorialManager();
    _searchManager = SearchManager();
    _animationManager = AnimationManager();
    _animationManager.initialize(this);

    // Add listener to sync _selectedIndex with NavigationController
    _navigationController.addListener(() {
      if (mounted) {
        setState(() {
          _selectedIndex = _navigationController.selectedIndex;
        });
      }
    });

    // Initialize old animation controllers for compatibility
    _categorySearchAnimationController = AnimationController(duration: const Duration(milliseconds: 300), vsync: this);
    _categoryFabAnimationController = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _categorySearchFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _categorySearchAnimationController, curve: Curves.easeInOut));

    // Initialize screens once to preserve state across tab switches
    _screens = [HomeScreen(scaffoldGlobalKey: _scaffoldGlobleKey, onTabSwitchRequested: (index) => _onItemTapped(index), onSelectionModeChanged: _handleSelectionModeChanged), const ProgressScreen(), const PomodoroHomeScreen(), const CategoryScreen(), UltimateMoodScreen(tabController: moodTabController)];

    WidgetsBinding.instance.addObserver(this);

    // Load initial data
    context.read<TaskListBloc>().add(LoadTasks());
    context.read<CategoryBloc>().add(LoadCategories());
    context.read<UserBloc>().add(LoadUser(forceRefresh: true));

    // Listen for connectivity changes
    Connectivity().onConnectivityChanged.listen((results) {
      _isConnected = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    });

    // Show tutorial for first time users
    _checkAndShowTutorial();

    // Prevent keyboard auto-opening on app launch
   /*  WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        FocusScope.of(context).unfocus();
      }
    }); */
  }

  // Debounced search functionality
  void _onSearchChanged(String value) {
    _searchManager.onSearchChanged(value);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    moodTabController.dispose();
    _scrollController.dispose();
    _searchController.dispose();
    _navigationController.dispose();
    _tutorialManager.dispose();
    _searchManager.dispose();
    _animationManager.dispose();
    super.dispose();
  }

  void _checkAndShowTutorial() async {
    await _tutorialManager.checkAndShowTutorial(context, addTaskKey: _addTaskKey, pomodoroKey: _pomodoroKey, categoryFilterKey: _categoryFilterKey, moodTrackingKey: _moodTrackingKey, taskDetailsKey: _taskDetailsKey);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<TaskListBloc>().add(LoadTasks());
      context.read<NotificationBloc>().add(const VerifyScheduledReminders());
    }
  }

  void _onItemTapped(int index) {
    _navigationController.navigateToTab(index);
    // Reset category search animations when switching away from categories
    if (index != 3) {
      _categorySearchAnimationController.reverse();
      _categoryFabAnimationController.forward();
    }
    // Reset search state when switching tabs
    if (index != 0) {
      _searchController.clear();
      setState(() {
        _isSearching = false;
      });
    }
    // Show Pomodoro tutorial step if Pomodoro tab selected and tutorial not shown
    if (index == 2) {
      _tutorialManager.checkAndShowPomodoroTutorial(context, addTaskKey: _addTaskKey, pomodoroKey: _pomodoroKey, categoryFilterKey: _categoryFilterKey, moodTrackingKey: _moodTrackingKey, taskDetailsKey: _taskDetailsKey);
    }
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.filter_list_rounded, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.filterTasksTitle),
          ],
        ),
        content: StatefulBuilder(
          builder: (context, setState) {
            return SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Priority Filter
                  Text(AppLocalizations.of(context)!.priorityLabel(''), style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: Text(AppLocalizations.of(context)!.allLabel),
                        selected: true,
                        onSelected: (selected) {
                          setState(() {
                            // Reset all filters
                          });
                        },
                      ),
                      FilterChip(
                        label: Text(AppLocalizations.of(context)!.highPriorityLabel),
                        avatar: Icon(Icons.priority_high, size: 16),
                        onSelected: (selected) {
                          setState(() {
                            // Apply high priority filter
                          });
                        },
                      ),
                      FilterChip(
                        label: Text(AppLocalizations.of(context)!.mediumPriorityLabel),
                        avatar: Icon(Icons.remove, size: 16),
                        onSelected: (selected) {
                          setState(() {
                            // Apply medium priority filter
                          });
                        },
                      ),
                      FilterChip(
                        label: Text(AppLocalizations.of(context)!.lowPriorityLabel),
                        avatar: Icon(Icons.keyboard_arrow_down, size: 16),
                        onSelected: (selected) {
                          setState(() {
                            // Apply low priority filter
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Status Filter
                  Text(AppLocalizations.of(context)!.statusLabel, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: Text(AppLocalizations.of(context)!.allLabel),
                        selected: true,
                        onSelected: (selected) {
                          setState(() {
                            // Reset status filter
                          });
                        },
                      ),
                      FilterChip(
                        label: Text(AppLocalizations.of(context)!.incompleteLabel),
                        avatar: Icon(Icons.radio_button_unchecked, size: 16),
                        onSelected: (selected) {
                          setState(() {
                            // Apply active filter
                          });
                        },
                      ),
                      FilterChip(
                        label: Text(AppLocalizations.of(context)!.completedLabel),
                        avatar: Icon(Icons.check_circle, size: 16),
                        onSelected: (selected) {
                          setState(() {
                            // Apply completed filter
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Date Range Filter
                  Text(AppLocalizations.of(context)!.dueDateTitle, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilterChip(
                        label: Text(AppLocalizations.of(context)!.allLabel),
                        selected: true,
                        onSelected: (selected) {
                          setState(() {
                            // Reset date filter
                          });
                        },
                      ),
                      FilterChip(
                        label: Text(AppLocalizations.of(context)!.today),
                        avatar: Icon(Icons.today, size: 16),
                        onSelected: (selected) {
                          setState(() {
                            // Apply today filter
                          });
                        },
                      ),
                      FilterChip(
                        label: Text(AppLocalizations.of(context)!.overdue),
                        avatar: Icon(Icons.warning, size: 16),
                        onSelected: (selected) {
                          setState(() {
                            // Apply overdue filter
                          });
                        },
                      ),
                      FilterChip(
                        label: Text(AppLocalizations.of(context)!.noDueDate),
                        avatar: Icon(Icons.event_busy, size: 16),
                        onSelected: (selected) {
                          setState(() {
                            // Apply no due date filter
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancelButton)),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Apply filters to the current tab
              _applyGlobalFilters();
            },
            child: Text(AppLocalizations.of(context)!.applyButton),
          ),
        ],
      ),
    );
  }

  void _applyGlobalFilters() {
    // This method would apply the selected filters to the current tab
    // Implementation would depend on the current selected index
    HapticFeedback.lightImpact();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.filtersAppliedSuccessfully), duration: const Duration(seconds: 2), behavior: SnackBarBehavior.floating));
  }

  void _showAddTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => AddTaskDialog(
        onTaskAdded: (task) {
          context.read<TaskListBloc>().add(AddTask(task));
          _showSuccessSnackBar(AppLocalizations.of(context)!.addTaskTitle);
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
    return WillPopScope(
      onWillPop: () async {
        // If we're on HomeScreen and selection mode is active, exit selection mode
        if (_selectedIndex == 0 && _isSelectionModeActive) {
          // Find the HomeScreen widget and call its controller's exitSelectionMode method
          final homeScreen = _screens[0] as HomeScreen;
          // Access the controller through the widget's state
          final homeScreenState = homeScreen.createState() as dynamic;
          if (homeScreenState._controller != null) {
            homeScreenState._controller.exitSelectionMode();
          }
          return false; // Don't allow back navigation
        }

        // Show exit confirmation dialog
        final shouldExit = await _showExitConfirmationDialog();
        return shouldExit ?? false;
      },
      child: BlocListener<AuthBloc, AuthState>(
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
              key: _scaffoldGlobleKey,
              appBar: _selectedIndex != 0 ? _buildAppBar() : null,
              drawer: _buildDrawer(),
              backgroundColor: Theme.of(context).colorScheme.background,
              body: FocusModeOverlay(child: _buildBody()),
              bottomNavigationBar: /*  !_hasShownTutorial ? */ _buildBottomNavigationBar() /* : _buildBottomNavigationBarTutorial() */,
              // FAB removed - HomeScreen has its own FAB
              floatingActionButton: /*  _selectedIndex == 0 ? null : */ _buildFloatingActionButton(),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    AppLogging.logInfo(_getAppBarTitle());
    final theme = Theme.of(context);

    return AppBar(
      foregroundColor: theme.colorScheme.onPrimary,
      title: _selectedIndex == 3
          ? AnimatedBuilder(
              animation: _categorySearchFadeAnimation,
              builder: (context, child) {
                return FadeTransition(
                  opacity: _isSearching ? Tween<double>(begin: 1.0, end: 0.0).animate(CurvedAnimation(parent: _categorySearchAnimationController, curve: Curves.easeInOut)) : const AlwaysStoppedAnimation(1.0),
                  child: Text(
                    _isSearching ? AppLocalizations.of(context)!.searchCategories : _getAppBarTitle(),
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimary),
                  ),
                );
              },
              child: Text(
                _getAppBarTitle(),
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimary),
              ),
            )
          : Text(
              _getAppBarTitle(),
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimary),
            ),
      actions: _buildAppBarActions(),
      bottom: _buildAppBarBottom(),
      elevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
      ),
    );
  }

  PreferredSizeWidget? _buildAppBarBottom() {
    final theme = Theme.of(context);

    if (_selectedIndex == 4) {
      return _buildTabBar();
    } else if (_selectedIndex == 0 && (_isSearching || _searchController.text.isNotEmpty)) {
      return _buildSearchBar();
    } else if (_selectedIndex == 3 && _isSearching) {
      // Category search bar
      return PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (value) {
              // Search functionality handled by SearchManager
            },
            // autofocus: true, // Removed to prevent keyboard auto-opening
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.searchCategories,
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              filled: true,
              fillColor: theme.colorScheme.surface.withValues(alpha: 0.9),
            ),
          ),
        ),
      );
    }
    return null;
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
    final theme = Theme.of(context);
    final iconColor = theme.colorScheme.onPrimary;

    if (_selectedIndex == 0) {
      return [
        const SyncStatusIndicator(),
        FocusModeIndicator(),
        IconButton(
          icon: Icon(Icons.sort, color: iconColor),
          onPressed: () {
            _checkAndShowTutorial();
            HapticFeedback.lightImpact();
            // Sort functionality handled by HomeScreen
          },
          onLongPress: _showFilterDialog,
          tooltip: AppLocalizations.of(context)?.priority ?? 'الأولوية',
        ),
        IconButton(
          icon: Icon(_isSearching || _searchController.text.isNotEmpty ? Icons.close : Icons.search, color: iconColor),
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
          tooltip: _isSearching ? AppLocalizations.of(context)!.closeSearch : (AppLocalizations.of(context)?.searchHint ?? 'بحث'),
        ),
      ];
    } else if (_selectedIndex == 2) {
      return [
        IconButton(
          icon: Icon(Icons.settings, color: iconColor),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen()));
          },
          tooltip: AppLocalizations.of(context)?.settingsScreenTitle ?? 'الإعدادات',
        ),
      ];
    } else if (_selectedIndex == 3) {
      // Category page with search functionality
      return [
        AnimatedBuilder(
          animation: _categorySearchFadeAnimation,
          builder: (context, child) {
            return FadeTransition(opacity: _categorySearchFadeAnimation, child: child);
          },
          child: IconButton(
            onPressed: _toggleCategorySearch,
            icon: Icon(_isSearching ? Icons.close : Icons.search, color: iconColor),
            tooltip: _isSearching ? AppLocalizations.of(context)!.closeSearch : AppLocalizations.of(context)!.searchCategories,
          ),
        ),
      ];
    } else if (_selectedIndex == 4) {
      return [
        IconButton(
          icon: Icon(Icons.settings, color: iconColor),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const MoodSettingsScreen()));
          },
          tooltip: AppLocalizations.of(context)?.settingsScreenTitle ?? 'إعدادات المزاج',
        ),
      ];
    }
    return [];
  }

  void _toggleCategorySearch() {
    setState(() {
      if (_isSearching) {
        _isSearching = false;
        _categorySearchAnimationController.reverse();
        _categoryFabAnimationController.reverse();
      } else {
        _isSearching = true;
        _categorySearchAnimationController.forward();
        _categoryFabAnimationController.forward();
      }
    });
  }

  PreferredSizeWidget _buildTabBar() {
    final theme = Theme.of(context);
    final tabColor = theme.colorScheme.onPrimary;

    return TabBar(
      indicatorColor: tabColor,
      labelColor: tabColor,
      unselectedLabelColor: tabColor.withValues(alpha: 0.7),
      controller: moodTabController,
      tabs: [
        Tab(
          text: AppLocalizations.of(context)?.today ?? 'اليوم',
          icon: Icon(Icons.today, color: tabColor),
        ),
        Tab(
          text: AppLocalizations.of(context)?.history ?? 'التاريخ',
          icon: Icon(Icons.history, color: tabColor),
        ),
        Tab(
          text: AppLocalizations.of(context)?.insights ?? 'الإحصائيات',
          icon: Icon(Icons.insights, color: tabColor),
        ),
      ],
    );
  }

  PreferredSizeWidget _buildSearchBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(70),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
          borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: CustomSearchBar(
          controller: _searchController,
          onChanged: _onSearchChanged,
          hintText: AppLocalizations.of(context)!.searchHint,
          autofocus: false, // Prevent keyboard auto-opening on app launch
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
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.surface.withValues(alpha: 0.95)]),
        ),
        child: Column(
          children: [
            _buildDrawerHeader(),
            const SizedBox(height: 16),
            BlocBuilder<UserBloc, UserState>(
              builder: (context, userState) {
                if (userState is UserLoaded && userState.user.isAdmin!) {
                  return ListTile(
                    leading: const Icon(Icons.admin_panel_settings),
                    title: Text(AppLocalizations.of(context)!.adminPanel),
                    onTap: () {
                      // Track admin panel access
                      final analytics = context.read<AnalyticsService>();
                      analytics.logCustomEvent(name: 'admin_panel_opened', parameters: {'user_id': userState.user.id});

                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPanelScreen()));
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 16),

            Expanded(child: _buildDrawerItems()),

            // Drawer Footer Items
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2), width: 1)),
              ),
              child: Column(
                children: [
                  // Sign Out
                  ListTile(
                    leading: Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
                    title: Text(
                      AppLocalizations.of(context)!.signOut,
                      style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      _showLogoutConfirmationDialog();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.primary.withValues(alpha: 0.8)]),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          String userName = AppLocalizations.of(context)!.appTitle;
          String? userEmail;
          String? userImage;

          if (state is UserLoaded) {
            userName = state.user.name.isNotEmpty ? state.user.name : AppLocalizations.of(context)!.appTitle;
            userEmail = state.user.email;
            userImage = state.user.profileImageUrl;
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              // Profile Avatar
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 3),
                ),
                child: userImage != null && userImage.isNotEmpty
                    ? ClipOval(
                        child: CachedNetworkImage(imageUrl: userImage, width: 40, height: 40, fit: BoxFit.cover),
                      )
                    : Icon(Icons.person, size: 40, color: Colors.white),
              ),
              const SizedBox(height: 16),

              // User Name
              Text(
                userName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 4),

              // User Email
              if (userEmail != null && userEmail.isNotEmpty)
                Text(
                  userEmail,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

              const SizedBox(height: 8),

              // Status Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                child: Text(
                  AppLocalizations.of(context)!.premium,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDrawerItems() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),

        // Main Navigation Section
        _buildDrawerSectionHeader(AppLocalizations.of(context)!.mainNavigation),
        _buildModernDrawerItem(icon: Icons.home_rounded, title: AppLocalizations.of(context)!.homeScreenTitle, subtitle: AppLocalizations.of(context)!.dashboardOverview, isSelected: _selectedIndex == 0, onTap: () => _onItemTapped(0), badge: _getSmartSortBadge()),
        const SizedBox(height: 4),
        _buildModernDrawerItem(icon: Icons.bar_chart_rounded, title: AppLocalizations.of(context)!.progressSaved, subtitle: AppLocalizations.of(context)!.statisticsAnalytics, isSelected: _selectedIndex == 1, onTap: () => _onItemTapped(1)),
        const SizedBox(height: 4),
        _buildModernDrawerItem(icon: Icons.timer_rounded, title: AppLocalizations.of(context)!.pomodoroSection, subtitle: AppLocalizations.of(context)!.focusTimeManagement, isSelected: _selectedIndex == 2, onTap: () => _onItemTapped(2), badge: _getPomodoroBadge()),
        const SizedBox(height: 4),
        _buildModernDrawerItem(icon: Icons.folder_rounded, title: AppLocalizations.of(context)!.allCategories, subtitle: AppLocalizations.of(context)!.organizeManage, isSelected: _selectedIndex == 3, onTap: () => _onItemTapped(3)),
        const SizedBox(height: 4),
        _buildModernDrawerItem(icon: Icons.mood_rounded, title: AppLocalizations.of(context)!.moodTracking, subtitle: AppLocalizations.of(context)!.wellnessEmotions, isSelected: _selectedIndex == 4, onTap: () => _onItemTapped(4)),
        const SizedBox(height: 16),

        // Smart Features Section
        _buildDrawerSectionHeader(AppLocalizations.of(context)!.smartFeatures),
        _buildModernDrawerItem(
          icon: Icons.psychology_rounded,
          title: AppLocalizations.of(context)!.pomodoroAnalytics,
          subtitle: AppLocalizations.of(context)!.aiPoweredInsights,
          isSelected: false,
          onTap: () {
            Navigator.pop(context);
            final taskRepository = context.read<TaskListBloc>().taskRepository;
            Navigator.push(context, MaterialPageRoute(builder: (context) => PomodoroAnalyticsScreen(taskRepository: taskRepository)));
          },
          badge: _getAnalyticsBadge(),
        ),
        const SizedBox(height: 4),
        _buildModernDrawerItem(
          icon: Icons.replay_rounded,
          title: AppLocalizations.of(context)!.recurringTasksManager,
          subtitle: AppLocalizations.of(context)!.automatedTaskScheduling,
          isSelected: false,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const RecurringTasksScreen()));
          },
        ),
        const SizedBox(height: 4),
        _buildModernDrawerItem(
          icon: Icons.wb_sunny_outlined,
          title: AppLocalizations.of(context)!.ambientMode,
          subtitle: 'Environment & mood settings',
          isSelected: false,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const AmbientScreen()));
          },
        ),
        const SizedBox(height: 4),
        _buildModernDrawerItem(
          icon: Icons.emergency_rounded,
          title: AppLocalizations.of(context)!.emergency,
          subtitle: AppLocalizations.of(context)!.quickEmergencyAccess,
          isSelected: false,
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EmergencyScreen()));
          },
        ),
        const SizedBox(height: 16),

        // Tools & Settings Section
        _buildDrawerSectionHeader(AppLocalizations.of(context)!.toolsAndSettings),
        _buildModernDrawerItem(
          icon: Icons.settings_rounded,
          title: AppLocalizations.of(context)!.settingsScreenTitle,
          subtitle: AppLocalizations.of(context)!.preferencesConfiguration,
          isSelected: false,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsScreen())),
        ),
        const SizedBox(height: 4),
        _buildModernDrawerItem(
          icon: Icons.info_rounded,
          title: AppLocalizations.of(context)!.about,
          subtitle: AppLocalizations.of(context)!.appInformationHelp,
          isSelected: false,
          onTap: () {
            Navigator.pop(context);
            _showAboutDialog(context);
          },
        ),
        const SizedBox(height: 16),

        // Admin Section (only for admin users)
        BlocBuilder<UserBloc, UserState>(
          builder: (context, userState) {
            if (userState is UserLoaded && userState.user.isAdmin!) {
              return Column(
                children: [
                  _buildDrawerSectionHeader(AppLocalizations.of(context)!.adminTools),
                  _buildModernDrawerItem(
                    icon: Icons.admin_panel_settings_rounded,
                    title: AppLocalizations.of(context)!.adminPanel,
                    subtitle: AppLocalizations.of(context)!.systemAdministration,
                    isSelected: false,
                    onTap: () {
                      // Track admin panel access
                      final analytics = context.read<AnalyticsService>();
                      analytics.logCustomEvent(name: 'admin_panel_opened', parameters: {'user_id': userState.user.id});

                      Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const AdminPanelScreen()));
                    },
                    badge: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  Widget _buildModernDrawerItem({required IconData icon, required String title, required String subtitle, required bool isSelected, required VoidCallback onTap, Widget? badge}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.1) : Colors.transparent,
        border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)) : null,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Stack(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: isSelected ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.primary, size: 24),
            ),
            if (badge != null) Positioned(top: 0, right: 0, child: badge),
          ],
        ),
        title: Text(title, style: _getTextStyle(isSelected)),
        subtitle: Text(subtitle, style: _getSubtitleStyle(isSelected)),
        trailing: isSelected
            ? Container(
                width: 4,
                height: 24,
                decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, borderRadius: BorderRadius.circular(2)),
              )
            : null,
        onTap: onTap,
      ),
    );
  }

  TextStyle? _getTextStyle(bool isSelected) {
    return Theme.of(context).textTheme.titleMedium?.copyWith(color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500);
  }

  TextStyle? _getSubtitleStyle(bool isSelected) {
    return Theme.of(context).textTheme.bodySmall?.copyWith(color: isSelected ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.8) : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6));
  }

  Widget _buildDrawerSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600, letterSpacing: 0.5),
      ),
    );
  }

  Widget? _getSmartSortBadge() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Icon(Icons.psychology, size: 10, color: Colors.white),
    );
  }

  Widget? _getPomodoroBadge() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: Colors.orange,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: const Icon(Icons.timer, size: 10, color: Colors.white),
    );
  }

  Widget? _getAnalyticsBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(10)),
      child: Text(
        AppLocalizations.of(context)!.newFeature,
        style: const TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold),
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.aboutTazbeet),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version: 2.0.0'),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.appDescription),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.features),
            const SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.smartTaskSortingWithAiRecommendations),
            Text(AppLocalizations.of(context)!.pomodoroTimerWithAdaptiveTiming),
            Text(AppLocalizations.of(context)!.analyticsAndProductivityInsights),
            Text(AppLocalizations.of(context)!.moodTrackingAndAmbientSettings),
            Text(AppLocalizations.of(context)!.recurringTaskAutomation),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.close))],
      ),
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.logout, color: Theme.of(context).colorScheme.error),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.signOut),
          ],
        ),
        content: Text(AppLocalizations.of(context)!.areYouSureYouWantToSignOut),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancelButton)),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              context.read<AuthBloc>().add(AuthSignOutRequested());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const SplashScreen()), (route) => false);
            },
            child: Text(AppLocalizations.of(context)!.signOut, style: TextStyle(color: Theme.of(context).colorScheme.error)),
          ),
        ],
      ),
    );
  }

  Future<bool?> _showExitConfirmationDialog() async {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must actively choose
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.exit_to_app, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(AppLocalizations.of(context)!.close),
          ],
        ),
        content: Text(AppLocalizations.of(context)!.areYouSureYouWantToExit),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // Don't exit
            child: Text(AppLocalizations.of(context)!.cancelButton),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Exit
            child: Text(AppLocalizations.of(context)!.close, style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerFooter() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2), width: 1)),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.replay),
            title: Text(AppLocalizations.of(context)!.recurringTasksManager),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RecurringTasksScreen()));
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
      ),
    );
  }

  Widget _buildBody() {
    // Use IndexedStack to preserve state of all tabs
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: _isRefreshing && !_isConnected ? _buildOfflineView() : IndexedStack(index: _selectedIndex, children: _screens),
    );
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
              Text(AppLocalizations.of(context)!.noInternetConnection, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context)!.pullToRefresh,
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
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      selectedItemColor: theme.colorScheme.primary,
      unselectedItemColor: theme.colorScheme.onSurfaceVariant,
      backgroundColor: theme.colorScheme.surface,
      type: BottomNavigationBarType.shifting,
      elevation: 8,
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home_outlined), activeIcon: const Icon(Icons.home), label: AppLocalizations.of(context)?.homeScreenTitle ?? 'الرئيسية'),
        BottomNavigationBarItem(icon: const Icon(Icons.bar_chart_outlined), activeIcon: const Icon(Icons.bar_chart), label: AppLocalizations.of(context)?.progressSaved ?? 'التقدم'),
        BottomNavigationBarItem(icon: const Icon(Icons.timer_outlined), activeIcon: const Icon(Icons.timer), label: AppLocalizations.of(context)?.pomodoroSection ?? 'بومودورو'),
        BottomNavigationBarItem(icon: const Icon(Icons.folder_outlined), activeIcon: const Icon(Icons.folder), label: AppLocalizations.of(context)?.allCategories ?? 'الفئات'),
        BottomNavigationBarItem(icon: const Icon(Icons.mood_outlined), activeIcon: const Icon(Icons.mood), label: AppLocalizations.of(context)?.moodTracking ?? 'المزاج'),
      ],
    );
  }

  Widget _buildBottomNavigationBarTutorial() {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, Icons.home, AppLocalizations.of(context)?.homeScreenTitle ?? 'الرئيسية'),
            _buildNavItem(1, Icons.bar_chart, AppLocalizations.of(context)?.progressSaved ?? 'التقدم'),
            _buildNavItem(2, Icons.timer, AppLocalizations.of(context)?.pomodoroSection ?? 'بومودورو', key: _pomodoroKey),
            _buildNavItem(3, Icons.folder, AppLocalizations.of(context)?.allCategories ?? 'الفئات'),
            _buildNavItem(4, Icons.mood, AppLocalizations.of(context)?.moodTracking ?? 'المزاج', key: _moodTrackingKey),
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
    final l10n = AppLocalizations.of(context)!;
    switch (_selectedIndex) {
      case 0:
        // Home Screen manages its own selection-aware FAB
        return const SizedBox.shrink();
      case 1:
        // Progress Screen - Stats/Export FAB
        return FloatingActionButton.extended(onPressed: _showProgressOptions, backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white, icon: const Icon(Icons.analytics), label: Text(l10n.statistics));
      case 2:
        // Pomodoro Screen - Has its own timer controls, no additional FAB needed
        return const SizedBox.shrink();
      case 3:
        // Category Screen - Add Category FAB
        return FloatingActionButton.extended(onPressed: _showAddCategoryDialog, backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white, icon: const Icon(Icons.add), label: Text(l10n.addCategory));
      /*  case 4:
        // Mood Screen - Quick Mood Entry FAB
        return FloatingActionButton.extended(
          onPressed: _showQuickMoodDialog,
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.mood),
          label: Text(l10n.mood),
        );
     */
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildMultiActionFAB() {
    return QuickActionsFAB(
      actions: AppQuickActions.forHomeScreen(context, onLogMood: _logQuickMood, onQuickAddTask: _showQuickAddTaskDialog, onAddDetailedTask: _showAddTaskDialog, onAddCategory: _showAddCategoryDialog),
      primaryColor: Theme.of(context).colorScheme.primary,
    );
  }

  // Missing methods for FAB actions
  void _logQuickMood() {
    // Navigate to mood tab
    setState(() {
      _selectedIndex = 4; // Mood tab index
    });
  }

  void _showProgressOptions() {
    // Show progress/stats options dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Progress Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('View Statistics'),
              onTap: () {
                Navigator.pop(context);
                // Navigate to detailed stats view
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export Data'),
              onTap: () {
                Navigator.pop(context);
                // Export functionality
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share Progress'),
              onTap: () {
                Navigator.pop(context);
                // Share functionality
              },
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
      ),
    );
  }

  void _showQuickMoodDialog() {
    // Show quick mood entry dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How are you feeling?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildMoodButton('😊', 'Happy'), _buildMoodButton('😐', 'Neutral'), _buildMoodButton('😔', 'Sad')]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [_buildMoodButton('😤', 'Frustrated'), _buildMoodButton('😰', 'Anxious'), _buildMoodButton('😴', 'Tired')]),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))],
      ),
    );
  }

  Widget _buildMoodButton(String emoji, String mood) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        // Save mood and navigate to mood tab for details
        setState(() {
          _selectedIndex = 4; // Mood tab index
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(mood, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  void _showQuickAddTaskDialog() {
    // Show quick add task dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.addTaskTitle),
        content: TextField(
          decoration: InputDecoration(hintText: AppLocalizations.of(context)!.addTaskTitle),
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              // Create quick task
              final task = Task(id: DateTime.now().millisecondsSinceEpoch.toString(), title: value, createdAt: DateTime.now(), updatedAt: DateTime.now(), priority: TaskPriority.medium);
              context.read<TaskListBloc>().add(AddTask(task));
              Navigator.pop(context);
            }
          },
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancelButton))],
      ),
    );
  }

  void _showAddCategoryDialog() {
    // Navigate to category tab
    setState(() {
      _selectedIndex = 3; // Category tab index
    });
  }
}

final GlobalKey<ScaffoldState> _scaffoldGlobleKey = GlobalKey();

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

  const TaskListSection({super.key, required this.tasks, this.selectedCategoryId, this.sortByPriority = false, this.searchQuery = '', this.filterPriority, this.filterCompleted, required this.onTaskToggle, required this.onTaskEdit, required this.onTaskDelete});

  @override
  Widget build(BuildContext context) {
    // Memoize filtered and grouped tasks to avoid recomputation on rebuilds
    final groups = _applyFilters(tasks);

    if (groups.isEmpty || groups.values.every((list) => list.isEmpty)) {
      return const EmptyState();
    }

    final l10n = AppLocalizations.of(context)!;
    final groupOrder = ['Overdue', 'Today', 'Tomorrow', 'This Week', 'Later', 'No Date', 'Completed'];
    final groupTitles = {'Overdue': l10n.overdueTasks, 'Today': l10n.todayTasks, 'Tomorrow': l10n.tomorrowTasks, 'This Week': l10n.thisWeekTasks, 'Later': l10n.laterTasks, 'No Date': l10n.noDateTasks, 'Completed': l10n.completedTasks};

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
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
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
                Text(AppLocalizations.of(context)!.priority, style: Theme.of(context).textTheme.titleMedium),
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
///Volumes/work/tazbeet/lib/ui/screens/data_management_screen.dart