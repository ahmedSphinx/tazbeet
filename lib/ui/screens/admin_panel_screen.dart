import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../blocs/user/user_bloc.dart';
import '../../blocs/user/user_state.dart';
import '../../models/user.dart';
import '../../models/task.dart';
import '../../models/category.dart';
import '../../models/app_settings.dart';
import '../../services/admin_service.dart';
import '../../services/analytics_service.dart';
import '../../services/maintenance_service.dart';
import '../../l10n/app_localizations.dart';

class AdminPanelScreen extends StatefulWidget {
  const AdminPanelScreen({super.key});

  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final AdminService _adminService = AdminService();

  // Dashboard metrics
  int _totalUsers = 0;
  int _totalTasks = 0;
  int _completedTasks = 0;
  int _activeUsers = 0;
  int _totalCategories = 0;
  String _appVersion = 'Loading...';
  bool _isDashboardLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _loadDashboardMetrics();
    _loadAppVersion();
  }

  Future<void> _loadAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        setState(() {
          _appVersion = packageInfo.version;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _appVersion = '1.0.0'; // Fallback
        });
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadDashboardMetrics() async {
    if (!mounted) return;
    setState(() => _isDashboardLoading = true);

    try {
      // Load all data in parallel for better performance
      final results = await Future.wait([_adminService.getAllUsers(), _adminService.getAllTasks(), _adminService.getAllCategories()]);

      if (!mounted) return;

      final users = results[0] as List<User>;
      final tasks = results[1] as List<Task>;
      final categories = results[2] as List<Category>;

      if (mounted) {
        setState(() {
          _totalUsers = users.length;
          _totalTasks = tasks.length;
          _completedTasks = tasks.where((task) => task.isCompleted).length;
          _activeUsers = users.length; // For now, consider all users as active
          _totalCategories = categories.length;
          _isDashboardLoading = false;
        });
      }
    } catch (e) {
      // AppLogging.logError('Error loading dashboard metrics: $e');
      if (mounted) {
        setState(() => _isDashboardLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, userState) {
        if (userState is! UserLoaded || !userState.user.isAdmin!) {
          return Scaffold(
            appBar: AppBar(title: Text(AppLocalizations.of(context)!.accessDenied)),
            body: Center(child: Text(AppLocalizations.of(context)!.youDoNotHaveAdminPrivileges)),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(AppLocalizations.of(context)!.adminPanel),
            bottom: TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Dashboard', icon: Icon(Icons.dashboard)),
                Tab(text: 'Users', icon: Icon(Icons.people)),
                Tab(text: 'Tasks', icon: Icon(Icons.task)),
                Tab(text: 'Categories', icon: Icon(Icons.folder)),
                Tab(text: 'Settings', icon: Icon(Icons.settings)),
              ],
            ),
          ),
          body: TabBarView(controller: _tabController, children: [_buildDashboard(), _buildUsersTab(), _buildTasksTab(), _buildCategoriesTab(), _buildSettingsTab()]),
        );
      },
    );
  }

  Widget _buildDashboard() {
    if (_isDashboardLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardMetrics,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.dashboard, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(icon: const Icon(Icons.refresh), onPressed: _loadDashboardMetrics, tooltip: AppLocalizations.of(context)!.refreshData),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMetricCard('Total Users', _totalUsers.toString(), Icons.people, Colors.blue),
                _buildMetricCard('Total Tasks', _totalTasks.toString(), Icons.task, Colors.green),
                _buildMetricCard('Completed Tasks', _completedTasks.toString(), Icons.check_circle, Colors.orange),
                _buildMetricCard('Active Users', _activeUsers.toString(), Icons.person, Colors.purple),
                _buildMetricCard('Categories', _totalCategories.toString(), Icons.folder, Colors.red),
                _buildMetricCard('App Version', _appVersion, Icons.info, Colors.teal),
              ],
            ),
            const SizedBox(height: 24),
            Text(AppLocalizations.of(context)!.recentActivity, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildActivityList(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const Icon(Icons.history),
          title: Text('${AppLocalizations.of(context)!.activity} ${index + 1}'),
          subtitle: Text(AppLocalizations.of(context)!.descriptionOfActivity),
          trailing: Text('${DateTime.now().subtract(Duration(hours: index)).hour}:00'),
        );
      },
    );
  }

  Widget _buildUsersTab() {
    return const UsersManagementWidget();
  }

  Widget _buildTasksTab() {
    return const TasksManagementWidget();
  }

  Widget _buildCategoriesTab() {
    return const CategoriesManagementWidget();
  }

  Widget _buildSettingsTab() {
    return const SettingsManagementWidget();
  }
}

class UsersManagementWidget extends StatefulWidget {
  const UsersManagementWidget({super.key});

  @override
  State<UsersManagementWidget> createState() => _UsersManagementWidgetState();
}

class _UsersManagementWidgetState extends State<UsersManagementWidget> {
  final AdminService _adminService = AdminService();
  late AnalyticsService _analyticsService;
  User? _currentAdmin;
  List<User> _users = [];
  List<User> _filteredUsers = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _analyticsService = context.read<AnalyticsService>();
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      _currentAdmin = userState.user;
    }
  }

  Future<void> _loadUsers() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      _users = await _adminService.getAllUsers();
      if (mounted) {
        _filterUsers();
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterUsers() {
    if (_searchQuery.isEmpty) {
      _filteredUsers = _users;
    } else {
      _filteredUsers = _users.where((user) => user.name.toLowerCase().contains(_searchQuery.toLowerCase()) || user.email?.toLowerCase().contains(_searchQuery.toLowerCase()) == true).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(labelText: 'Search Users', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _filterUsers();
              });
            },
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredUsers.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.noUsersFound))
              : ListView.builder(
                  itemCount: _filteredUsers.length,
                  itemBuilder: (context, index) {
                    final user = _filteredUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        child: user.profileImageUrl == null
                            ? Text(user.name[0].toUpperCase())
                            : Image.network(user.profileImageUrl!, errorBuilder: (context, error, stackTrace) => CircleAvatar(child: Icon(Icons.person))),
                      ),
                      title: Text(user.name),
                      subtitle: Text(user.email ?? 'No email'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: Icon(user.isAdmin! ? Icons.admin_panel_settings : Icons.person), onPressed: () => _toggleAdmin(user)),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(user),
                          ),
                        ],
                      ),
                      onTap: () => _showUserDetails(user),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _toggleAdmin(User user) async {
    // Confirm action (security critical)
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.toggleAdminStatus),
        content: Text('Are you sure you want to ${user.isAdmin! ? 'remove admin rights from' : 'grant admin rights to'} ${user.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(onPressed: () => Navigator.pop(context, true), child: Text(AppLocalizations.of(context)!.confirm)),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final updatedUser = user.copyWith(isAdmin: !user.isAdmin!);
      await _adminService.updateUser(updatedUser);

      // Track analytics
      if (_currentAdmin != null) {
        await _analyticsService.logAdminUserPromoted(userId: user.id, adminId: _currentAdmin!.id, promoted: updatedUser.isAdmin!);
      }

      await _loadUsers(); // Refresh list

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user.name} is now ${updatedUser.isAdmin! ? 'an admin' : 'not an admin'}')));
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating user: $e'),
            backgroundColor: Colors.red,
            action: SnackBarAction(label: AppLocalizations.of(context)!.retry, onPressed: () => _toggleAdmin(user)),
          ),
        );
      }
    }
  }

  void _deleteUser(User user) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteUser),
        content: Text('Are you sure you want to delete ${user.name}?\n\nThis will permanently delete:\n• User account\n• All tasks\n• All categories\n• All moods\n\nThis action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await _adminService.deleteUser(user.id);

      // Track analytics
      if (_currentAdmin != null) {
        await _analyticsService.logAdminUserDeleted(deletedUserId: user.id, adminId: _currentAdmin!.id);
      }

      await _loadUsers(); // Refresh list

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${user.name} and all associated data deleted successfully')));
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting user: $e'),
            backgroundColor: Colors.red,
            action: SnackBarAction(label: AppLocalizations.of(context)!.retry, onPressed: () => _deleteUser(user)),
          ),
        );
      }
    }
  }

  void _showUserDetails(User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(user.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Email: ${user.email ?? 'N/A'}'),
            Text('Admin: ${user.isAdmin! ? 'Yes' : 'No'}'),
            Text('Created: ${user.createdAt}'),
            Text('Updated: ${user.updatedAt}'),
            if (user.birthday != null) Text('Birthday: ${user.birthday}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.close))],
      ),
    );
  }
}

class TasksManagementWidget extends StatefulWidget {
  const TasksManagementWidget({super.key});

  @override
  State<TasksManagementWidget> createState() => _TasksManagementWidgetState();
}

class _TasksManagementWidgetState extends State<TasksManagementWidget> {
  final AdminService _adminService = AdminService();
  late AnalyticsService _analyticsService;
  User? _currentAdmin;
  List<Task> _tasks = [];
  Map<String, String> _userNames = {};
  Map<String, List<Task>> _tasksByUser = {};
  Map<String, List<Task>> _filteredTasksByUser = {};
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _analyticsService = context.read<AnalyticsService>();
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      _currentAdmin = userState.user;
    }
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Load tasks and users in parallel
      final results = await Future.wait([_adminService.getAllTasks(), _adminService.getAllUsers()]);

      if (!mounted) return;

      _tasks = results[0] as List<Task>;
      final users = results[1] as List<User>;

      // Create user name map
      _userNames = {for (var user in users) user.id: user.name};

      // Group tasks by user
      _tasksByUser = {};
      for (var task in _tasks) {
        final userId = task.userId ?? 'unknown';
        if (!_tasksByUser.containsKey(userId)) {
          _tasksByUser[userId] = [];
        }
        _tasksByUser[userId]!.add(task);
      }

      _filterTasks();
      if (mounted) {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterTasks() {
    if (_searchQuery.isEmpty) {
      _filteredTasksByUser = Map.from(_tasksByUser);
    } else {
      _filteredTasksByUser = {};
      for (var entry in _tasksByUser.entries) {
        final userTasks = entry.value.where((task) => task.title.toLowerCase().contains(_searchQuery.toLowerCase()) || task.description?.toLowerCase().contains(_searchQuery.toLowerCase()) == true).toList();
        if (userTasks.isNotEmpty) {
          _filteredTasksByUser[entry.key] = userTasks;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(labelText: 'Search Tasks', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
                _filterTasks();
              });
            },
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredTasksByUser.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.noTasksFound))
              : ListView.builder(
                  itemCount: _filteredTasksByUser.length,
                  itemBuilder: (context, index) {
                    final userId = _filteredTasksByUser.keys.elementAt(index);
                    final userTasks = _filteredTasksByUser[userId]!;
                    final userName = _userNames[userId] ?? 'Unknown User';

                    return ExpansionTile(
                      title: Text(userName),
                      subtitle: Text('${userTasks.length} task${userTasks.length == 1 ? '' : 's'}'),
                      leading: CircleAvatar(child: Text(userTasks.length.toString())),
                      children: userTasks.map((task) {
                        return ListTile(
                          leading: Icon(task.isCompleted ? Icons.check_circle : Icons.radio_button_unchecked, color: task.isCompleted ? Colors.green : Colors.grey),
                          title: Text(task.title),
                          subtitle: Text(task.description ?? 'No description'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: Icon(task.isCompleted ? Icons.undo : Icons.check), onPressed: () => _toggleCompletion(task)),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteTask(task),
                              ),
                            ],
                          ),
                          onTap: () => _showTaskDetails(task),
                        );
                      }).toList(),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _toggleCompletion(Task task) async {
    try {
      final updatedTask = task.copyWith(isCompleted: !task.isCompleted);
      await _adminService.updateTask(updatedTask);

      // Track analytics
      if (_currentAdmin != null) {
        await _analyticsService.logAdminTaskUpdated(taskId: task.id, adminId: _currentAdmin!.id);
      }

      await _loadData(); // Refresh list
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${task.title} ${updatedTask.isCompleted ? 'completed' : 'marked incomplete'}')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error updating task: $e'), backgroundColor: Colors.red));
      }
    }
  }

  void _deleteTask(Task task) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteTask),
        content: Text('Are you sure you want to delete "${task.title}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppLocalizations.of(context)!.cancel)),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.delete),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await _adminService.deleteTask(task);

      // Track analytics
      if (_currentAdmin != null) {
        await _analyticsService.logAdminTaskDeleted(taskId: task.id, adminId: _currentAdmin!.id);
      }

      await _loadData(); // Refresh list

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${task.title} deleted successfully')));
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting task: $e'),
            backgroundColor: Colors.red,
            action: SnackBarAction(label: AppLocalizations.of(context)!.retry, onPressed: () => _deleteTask(task)),
          ),
        );
      }
    }
  }

  void _showTaskDetails(Task task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(task.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Description: ${task.description ?? 'N/A'}'),
            Text('Priority: ${task.priority.name}'),
            Text('Completed: ${task.isCompleted ? 'Yes' : 'No'}'),
            Text('Due Date: ${task.dueDate ?? 'N/A'}'),
            Text('User ID: ${task.userId ?? 'N/A'}'),
            Text('Created: ${task.createdAt}'),
            Text('Updated: ${task.updatedAt}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.close))],
      ),
    );
  }
}

class CategoriesManagementWidget extends StatefulWidget {
  const CategoriesManagementWidget({super.key});

  @override
  State<CategoriesManagementWidget> createState() => _CategoriesManagementWidgetState();
}

class _CategoriesManagementWidgetState extends State<CategoriesManagementWidget> {
  final AdminService _adminService = AdminService();
  late AnalyticsService _analyticsService;
  User? _currentAdmin;
  List<Category> _categories = [];
  List<Category> _filteredCategories = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _analyticsService = context.read<AnalyticsService>();
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      _currentAdmin = userState.user;
    }
  }

  Future<void> _loadCategories() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      _categories = await _adminService.getAllCategories();
      if (mounted) {
        _filterCategories();
        setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _filterCategories() {
    if (_searchQuery.isEmpty) {
      _filteredCategories = _categories;
    } else {
      _filteredCategories = _categories.where((category) => category.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(labelText: 'Search Categories', prefixIcon: Icon(Icons.search), border: OutlineInputBorder()),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _filterCategories();
                    });
                  },
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(onPressed: _showAddCategoryDialog, icon: const Icon(Icons.add), label: Text(AppLocalizations.of(context)!.addCategory)),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _filteredCategories.isEmpty
              ? Center(child: Text(AppLocalizations.of(context)!.noCategoriesFound))
              : ListView.builder(
                  itemCount: _filteredCategories.length,
                  itemBuilder: (context, index) {
                    final category = _filteredCategories[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: category.color,
                        child: Text(category.icon, style: const TextStyle(color: Colors.white)),
                      ),
                      title: Text(category.name),
                      subtitle: Text('${AppLocalizations.of(context)!.tasks}: ${category.tasksCount}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showEditCategoryDialog(category),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteCategory(category),
                          ),
                        ],
                      ),
                      onTap: () => _showCategoryDetails(category),
                    );
                  },
                ),
        ),
      ],
    );
  }

  void _showAddCategoryDialog() {
    _showCategoryDialog(null);
  }

  void _showEditCategoryDialog(Category category) {
    _showCategoryDialog(category);
  }

  void _showCategoryDialog(Category? category) {
    final isEditing = category != null;
    final nameController = TextEditingController(text: category?.name ?? '');
    final iconController = TextEditingController(text: category?.icon ?? 'folder');
    Color selectedColor = category?.color ?? Colors.blue;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(isEditing ? 'Edit Category' : 'Add Category'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Category Name'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: iconController,
                decoration: const InputDecoration(labelText: 'Icon (emoji or text)'),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text('${AppLocalizations.of(context)!.color}: '),
                  const SizedBox(width: 16),
                  ...[Colors.red, Colors.blue, Colors.green, Colors.orange, Colors.purple].map(
                    (color) => GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: Container(
                        width: 30,
                        height: 30,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: selectedColor == color ? Border.all(color: Colors.black, width: 2) : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.cancelButton)),
            TextButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final icon = iconController.text.trim();
                if (name.isNotEmpty && icon.isNotEmpty) {
                  final newCategory = Category(
                    id: isEditing ? category.id : DateTime.now().toString(),
                    name: name,
                    color: selectedColor,
                    icon: icon,
                    createdAt: category?.createdAt ?? DateTime.now(),
                    isDefault: category?.isDefault ?? false,
                    tasksCount: category?.tasksCount ?? 0,
                  );

                  if (isEditing) {
                    await _adminService.updateCategory(newCategory);
                    // Track analytics for update
                    if (_currentAdmin != null) {
                      await _analyticsService.logAdminCategoryUpdated(categoryId: newCategory.id, adminId: _currentAdmin!.id);
                    }
                  } else {
                    await _adminService.createCategory(newCategory);
                    // Track analytics for creation
                    if (_currentAdmin != null) {
                      await _analyticsService.logAdminCategoryCreated(categoryId: newCategory.id, adminId: _currentAdmin!.id);
                    }
                  }

                  await _loadCategories();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${isEditing ? 'Updated' : 'Added'} category: $name')));
                }
              },
              child: Text(isEditing ? 'Update' : 'Add'),
            ),
          ],
        ),
      ),
    );
  }

  void _deleteCategory(Category category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.deleteCategory),
        content: Text(AppLocalizations.of(context)!.areYouSureYouWantToDeleteCategory(category.name)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.deleteButton),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await _adminService.deleteCategory(category.id);

      // Track analytics
      if (_currentAdmin != null) {
        await _analyticsService.logAdminCategoryDeleted(categoryId: category.id, adminId: _currentAdmin!.id);
      }

      await _loadCategories();

      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Category "${category.name}" deleted successfully')));
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting category: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(label: 'OK', onPressed: () {}),
          ),
        );
      }
    }
  }

  void _showCategoryDetails(Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(category.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${AppLocalizations.of(context)!.icon}: ${category.icon}'),
            Text('${AppLocalizations.of(context)!.tasksCount}: ${category.tasksCount}'),
            Text(AppLocalizations.of(context)!.defaultYes(category.isDefault ? 'Yes' : 'No')),
            Text('${AppLocalizations.of(context)!.created}: ${category.createdAt}'),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(AppLocalizations.of(context)!.close))],
      ),
    );
  }
}

class SettingsManagementWidget extends StatefulWidget {
  const SettingsManagementWidget({super.key});

  @override
  State<SettingsManagementWidget> createState() => _SettingsManagementWidgetState();
}

class _SettingsManagementWidgetState extends State<SettingsManagementWidget> {
  final MaintenanceService _maintenanceService = MaintenanceService();
  late AnalyticsService _analyticsService;
  User? _currentAdmin;

  AppSettings? _settings;
  String _appVersion = 'Loading...';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _analyticsService = context.read<AnalyticsService>();
    final userState = context.read<UserBloc>().state;
    if (userState is UserLoaded) {
      _currentAdmin = userState.user;
    }
  }

  Future<void> _loadSettings() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      // Load real app version
      final packageInfo = await PackageInfo.fromPlatform();
      if (mounted) {
        _appVersion = packageInfo.version;
      }

      // Load settings from Firestore
      final settings = await _maintenanceService.getSettings();
      if (mounted) {
        setState(() {
          _settings = settings;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _appVersion = '1.0.0';
          _settings = AppSettings.defaults();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _settings == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final theme = Theme.of(context);
    final maintenanceMode = _settings!.maintenanceMode;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.settings, size: 32, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(AppLocalizations.of(context)!.appSettings, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 24),

          // Maintenance Mode - بطاقة بارزة وجميلة
          _buildMaintenanceCard(theme, maintenanceMode),

          const SizedBox(height: 24),

          // General Settings
          Text(AppLocalizations.of(context)!.generalSettings, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(AppLocalizations.of(context)!.userRegistration, style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(_settings!.registrationEnabled ? AppLocalizations.of(context)!.newUsersCanRegister : AppLocalizations.of(context)!.registrationIsDisabled),
                    value: _settings!.registrationEnabled,
                    secondary: Icon(_settings!.registrationEnabled ? Icons.person_add : Icons.person_off, color: _settings!.registrationEnabled ? Colors.green : Colors.grey),
                    onChanged: (value) => _toggleRegistration(value),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // App Information
          Text(AppLocalizations.of(context)!.appInformation, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info, color: Colors.blue),
                    title: Text(AppLocalizations.of(context)!.appVersion, style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(_appVersion),
                    trailing: const Icon(Icons.check_circle, color: Colors.green),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.email, color: Colors.orange),
                    title: Text(AppLocalizations.of(context)!.supportEmail, style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(_settings!.supportEmail),
                    trailing: IconButton(icon: const Icon(Icons.edit), onPressed: () => _editSupportEmail()),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.access_time, color: Colors.purple),
                    title: Text(AppLocalizations.of(context)!.lastUpdated, style: const TextStyle(fontWeight: FontWeight.w500)),
                    subtitle: Text(_formatDateTime(_settings!.lastUpdated)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenanceCard(ThemeData theme, bool isActive) {
    return Card(
      elevation: 4,
      color: isActive ? Colors.red.shade50 : Colors.green.shade50,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: isActive ? Colors.red.shade100 : Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
                  child: Icon(isActive ? Icons.construction : Icons.check_circle, color: isActive ? Colors.red.shade700 : Colors.green.shade700, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Maintenance Mode',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isActive ? Colors.red.shade900 : Colors.green.shade900),
                      ),
                      const SizedBox(height: 4),
                      Text(isActive ? 'App is in maintenance mode' : 'App is running normally', style: TextStyle(color: isActive ? Colors.red.shade700 : Colors.green.shade700, fontSize: 13)),
                    ],
                  ),
                ),
                // زر تبديل كبير وواضح
                Transform.scale(
                  scale: 1.3,
                  child: Switch(value: isActive, onChanged: (value) => _toggleMaintenanceMode(value), activeColor: Colors.red.shade700, inactiveThumbColor: Colors.green.shade700),
                ),
              ],
            ),
            if (isActive) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '⚠️ Only admins can access the app',
                        style: TextStyle(color: Colors.red.shade900, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // زر تعديل رسالة الصيانة
              OutlinedButton.icon(
                onPressed: _editMaintenanceMessage,
                icon: const Icon(Icons.edit),
                label: Text(AppLocalizations.of(context)!.editMaintenanceMessage),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red.shade700,
                  side: BorderSide(color: Colors.red.shade300),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inDays > 0) {
      return '${diff.inDays} day${diff.inDays > 1 ? 's' : ''} ago';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} hour${diff.inHours > 1 ? 's' : ''} ago';
    } else if (diff.inMinutes > 0) {
      return '${diff.inMinutes} minute${diff.inMinutes > 1 ? 's' : ''} ago';
    } else {
      return 'Just now';
    }
  }

  // تبديل وضع الصيانة
  void _toggleMaintenanceMode(bool value) async {
    if (_currentAdmin == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(value ? Icons.construction : Icons.check_circle, color: value ? Colors.red : Colors.green),
            const SizedBox(width: 8),
            Expanded(child: Text(value ? AppLocalizations.of(context)!.enableMaintenanceMode : AppLocalizations.of(context)!.disableMaintenanceMode, overflow: TextOverflow.ellipsis, maxLines: 2)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value ? 'Are you sure you want to put the app in maintenance mode?\n\n⚠️ This will:' : 'Are you sure you want to disable maintenance mode?\n\nThis will:',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            if (value) ...[
              const Text('• Block all non-admin users'),
              const Text('• Show maintenance screen to users'),
              const Text('• Only admins can access the app'),
            ] else ...[
              const Text('• Allow all users to access the app'),
              const Text('• Return to normal operation'),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: value ? Colors.red : Colors.green),
            child: Text(value ? AppLocalizations.of(context)!.enable : AppLocalizations.of(context)!.disable),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      if (value) {
        await _maintenanceService.enableMaintenanceMode(adminId: _currentAdmin!.id);
      } else {
        await _maintenanceService.disableMaintenanceMode(adminId: _currentAdmin!.id);
      }

      // Track analytics
      await _analyticsService.logCustomEvent(
        name: 'admin_maintenance_mode_toggled',
        parameters: {
          'admin_id': _currentAdmin!.id,
          'enabled': value ? 'true' : 'false', // Convert boolean to string
        },
      );

      await _loadSettings(); // Reload settings

      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value ? '✅ Maintenance mode enabled' : '✅ Maintenance mode disabled'), backgroundColor: value ? Colors.orange : Colors.green));
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }

  // تعديل رسالة الصيانة
  void _editMaintenanceMessage() async {
    if (_currentAdmin == null || _settings == null) return;

    final controller = TextEditingController(text: _settings!.maintenanceMessage);

    final newMessage = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Maintenance Message'),
        content: TextField(
          controller: controller,
          maxLines: 3,
          decoration: const InputDecoration(labelText: 'Message', hintText: 'Enter the message users will see...', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.pop(context, text);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newMessage == null || newMessage == _settings!.maintenanceMessage) return;

    try {
      await _maintenanceService.updateMaintenanceMessage(adminId: _currentAdmin!.id, message: newMessage);

      await _loadSettings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Maintenance message updated')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }

  // تبديل التسجيل
  void _toggleRegistration(bool value) async {
    if (_currentAdmin == null) return;

    try {
      await _maintenanceService.updateSetting(adminId: _currentAdmin!.id, registrationEnabled: value);

      await _loadSettings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value ? '✅ Registration enabled' : '⚠️ Registration disabled')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }

  // تعديل بريد الدعم
  void _editSupportEmail() async {
    if (_currentAdmin == null || _settings == null) return;

    final controller = TextEditingController(text: _settings!.supportEmail);

    final newEmail = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Support Email'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(labelText: 'Email', hintText: 'support@example.com', border: OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isNotEmpty) {
                Navigator.pop(context, text);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newEmail == null || newEmail == _settings!.supportEmail) return;

    try {
      await _maintenanceService.updateSetting(adminId: _currentAdmin!.id, supportEmail: newEmail);

      await _loadSettings();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Support email updated')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    }
  }
}
