# 📋 PART 2: DETAILED UPGRADE PLAN

## 🎯 UPGRADE OBJECTIVES

### Primary Goals
1. **Integrate all unused code** - Use refactored widgets, eliminate dead code
2. **Add missing features** - Delete, details, search, sort
3. **Fix architecture** - Consistent patterns, proper navigation
4. **Improve UX** - Better interactions, animations, feedback
5. **Clean codebase** - Remove duplication, add documentation

### Success Criteria
- ✅ Zero orphaned files
- ✅ All DSTaskCard parameters used
- ✅ Search and sort fully functional
- ✅ Task details accessible from home
- ✅ Delete with confirmation
- ✅ Consistent architecture patterns
- ✅ All strings localized
- ✅ Zero analysis warnings

---

## 📐 PROPOSED ARCHITECTURE

### New Folder Structure
```
lib/ui/
├── design_system/
│   ├── tokens/
│   │   ├── ds_spacing.dart
│   │   ├── ds_typography.dart
│   │   ├── ds_colors.dart
│   │   ├── ds_elevation.dart
│   │   └── ds_border_radius.dart
│   └── components/
│       ├── ds_stat_card.dart          # Extract from ds_components.dart
│       ├── ds_task_card.dart          # Extract & enhance
│       ├── ds_category_chip.dart      # Extract
│       ├── ds_priority_indicator.dart # Extract
│       ├── ds_enhanced_fab.dart       # Extract
│       ├── ds_section_header.dart     # Extract
│       └── ds_empty_state.dart        # Extract
│
├── screens/
│   ├── home/
│   │   ├── home_screen.dart           # Renamed from home_screen_redesigned
│   │   ├── widgets/
│   │   │   ├── home_header.dart       # Use existing refactored version
│   │   │   ├── home_stats_section.dart # Use existing home_quick_stats
│   │   │   ├── home_category_filter.dart # Use existing
│   │   │   ├── home_task_list.dart    # New - extracted from inline
│   │   │   ├── home_search_bar.dart   # New - implement search
│   │   │   └── home_sort_menu.dart    # New - implement sort
│   │   └── home_controller.dart       # Enhanced version
│   │
│   ├── task_details/
│   │   └── task_details_screen.dart   # Existing - integrate with home
│   │
│   └── [other screens...]
│
└── widgets/
    ├── shared/                         # Rename from root widgets/
    │   ├── task_item.dart             # Keep for other screens
    │   ├── empty_state.dart
    │   ├── error_display.dart
    │   └── [other shared widgets...]
    │
    └── dialogs/
        ├── add_task_dialog.dart
        ├── edit_task_dialog.dart
        ├── delete_confirmation_dialog.dart  # New
        └── task_quick_actions_dialog.dart   # New
```

---

## 🔧 STEP-BY-STEP IMPLEMENTATION PLAN

### PHASE 1: Foundation & Cleanup (2-3 hours)

#### Step 1.1: Reorganize Design System
**Goal:** Split monolithic `ds_components.dart` into individual files

**Actions:**
1. Create `lib/ui/design_system/components/` folder
2. Extract each component to separate file:
   - `DSStatCard` → `ds_stat_card.dart`
   - `DSTaskCard` → `ds_task_card.dart`
   - `DSCategoryChip` → `ds_category_chip.dart`
   - `DSPriorityIndicator` → `ds_priority_indicator.dart`
   - `DSEnhancedFAB` → `ds_enhanced_fab.dart`
   - `DSSectionHeader` → `ds_section_header.dart`
   - `DSEmptyState` → `ds_empty_state.dart`
3. Create barrel file `components.dart` for easy imports
4. Update all imports across the project

**Files Changed:**
- `lib/ui/design_system/ds_components.dart` → DELETE
- `lib/ui/design_system/components/` → CREATE (7 new files)
- `lib/ui/design_system/components.dart` → CREATE (barrel file)
- `lib/ui/screens/home_screen_redesigned.dart` → UPDATE imports

---

#### Step 1.2: Delete Dead Code
**Goal:** Remove orphaned files that will never be used

**Files to Delete:**
```bash
rm lib/ui/widgets/home/home_active_filters_bar.dart
rm lib/ui/widgets/home/home_calendar_panel.dart
rm lib/ui/widgets/home/home_task_list_container.dart
rm lib/ui/widgets/home/home_undated_section.dart
```

**Verification:**
```bash
flutter analyze  # Should pass
grep -r "HomeActiveFiltersBar\|HomeCalendarPanel\|HomeTaskListContainer\|HomeUndatedSection" lib/
# Should return no results
```

---

#### Step 1.3: Rename & Reorganize Home Screen
**Goal:** Create proper home screen module structure

**Actions:**
1. Create `lib/ui/screens/home/` folder
2. Move `home_screen_redesigned.dart` → `home/home_screen.dart`
3. Move `home_screen_controller.dart` → `home/home_controller.dart`
4. Create `home/widgets/` subfolder
5. Move refactored widgets:
   - `lib/ui/widgets/home/home_header.dart` → `home/widgets/`
   - `lib/ui/widgets/home/home_quick_stats.dart` → `home/widgets/home_stats_section.dart`
   - `lib/ui/widgets/home/home_category_filter.dart` → `home/widgets/`
6. Delete empty `lib/ui/widgets/home/` folder
7. Update all imports in `main_screen.dart`

**Files Changed:**
- `lib/ui/screens/home_screen_redesigned.dart` → MOVE to `lib/ui/screens/home/home_screen.dart`
- `lib/ui/controllers/home_screen_controller.dart` → MOVE to `lib/ui/screens/home/home_controller.dart`
- `lib/ui/widgets/home/` → MOVE to `lib/ui/screens/home/widgets/`
- `lib/ui/screens/main_screen.dart` → UPDATE import

---

### PHASE 2: Enhance DSTaskCard (1 hour)

#### Step 2.1: Add Missing Functionality to DSTaskCard
**Goal:** Make DSTaskCard support all interactions

**Current DSTaskCard:**
```dart
class DSTaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;      // ❌ Defined but not used
  final bool isSelected;              // ❌ Defined but not used
}
```

**Enhanced DSTaskCard:**
```dart
class DSTaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;          // Navigate to details
  final VoidCallback? onToggle;       // Toggle completion
  final VoidCallback? onDelete;       // Delete task
  final VoidCallback? onEdit;         // NEW: Quick edit
  final VoidCallback? onLongPress;    // NEW: Show quick actions
  final bool isSelected;              // For batch selection
  final bool showActions;             // NEW: Show action buttons
  final bool enableSwipe;             // NEW: Enable swipe actions
}
```

**New Features:**
1. **Swipe Actions** - Swipe left to delete, right to complete
2. **Long Press Menu** - Quick actions (edit, delete, details, duplicate)
3. **Action Buttons** - Optional visible delete/edit buttons
4. **Selection Mode** - Visual feedback when selected
5. **Subtask Indicator** - Show if task has subtasks

**Implementation:**
```dart
// Wrap in Slidable for swipe actions
Slidable(
  key: ValueKey(task.id),
  startActionPane: ActionPane(
    motion: const StretchMotion(),
    children: [
      SlidableAction(
        onPressed: (_) => onToggle?.call(),
        backgroundColor: Colors.green,
        icon: Icons.check,
        label: 'Complete',
      ),
    ],
  ),
  endActionPane: ActionPane(
    motion: const StretchMotion(),
    children: [
      SlidableAction(
        onPressed: (_) => onDelete?.call(),
        backgroundColor: Colors.red,
        icon: Icons.delete,
        label: 'Delete',
      ),
    ],
  ),
  child: Card(...),
)
```

**Files Changed:**
- `lib/ui/design_system/components/ds_task_card.dart` → ENHANCE
- Add dependency: `flutter_slidable: ^3.0.0` in `pubspec.yaml`

---

### PHASE 3: Implement Search (2 hours)

#### Step 3.1: Create Search Widget
**Goal:** Add search bar to home screen

**New File:** `lib/ui/screens/home/widgets/home_search_bar.dart`
```dart
class HomeSearchBar extends StatelessWidget {
  final HomeController controller;
  final bool isVisible;
  
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: isVisible ? 60 : 0,
      child: TextField(
        onChanged: (query) => controller.setSearchQuery(query),
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.searchHint,
          prefixIcon: Icon(Icons.search),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => controller.clearSearch(),
          ),
        ),
      ),
    );
  }
}
```

#### Step 3.2: Enhance HomeController
**Goal:** Add search functionality

**Current:**
```dart
class HomeScreenController {
  final ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  // ❌ Never used!
}
```

**Enhanced:**
```dart
class HomeController {
  final ValueNotifier<String> searchQuery = ValueNotifier<String>('');
  
  void setSearchQuery(String query) {
    searchQuery.value = query.trim();
  }
  
  void clearSearch() {
    searchQuery.value = '';
  }
  
  bool get isSearching => searchQuery.value.isNotEmpty;
}
```

#### Step 3.3: Implement Search Filtering
**Goal:** Filter tasks by search query

**Location:** `lib/ui/screens/home/widgets/home_task_list.dart`
```dart
Widget _buildTaskList(BuildContext context) {
  return ValueListenableBuilder<String>(
    valueListenable: _controller.searchQuery,
    builder: (context, query, _) {
      return BlocBuilder<TaskListBloc, TaskListState>(
        builder: (context, state) {
          if (state is! TaskListLoaded) return LoadingWidget();
          
          var tasks = state.tasks;
          
          // Apply search filter
          if (query.isNotEmpty) {
            final lowerQuery = query.toLowerCase();
            tasks = tasks.where((task) {
              return task.title.toLowerCase().contains(lowerQuery) ||
                     (task.description?.toLowerCase().contains(lowerQuery) ?? false);
            }).toList();
          }
          
          // Apply other filters...
          return TaskListView(tasks: tasks);
        },
      );
    },
  );
}
```

#### Step 3.4: Add Search Toggle to AppBar
**Goal:** Show/hide search bar

**Location:** `lib/ui/screens/main_screen.dart`
```dart
// Update existing search icon button
IconButton(
  icon: Icon(_isSearching ? Icons.close : Icons.search),
  onPressed: () {
    setState(() => _isSearching = !_isSearching);
    if (!_isSearching) {
      _searchController.clear();
      // Notify home screen to clear search
    }
  },
)
```

**Files Changed:**
- `lib/ui/screens/home/widgets/home_search_bar.dart` → CREATE
- `lib/ui/screens/home/home_controller.dart` → ENHANCE
- `lib/ui/screens/home/widgets/home_task_list.dart` → CREATE & implement filtering
- `lib/ui/screens/main_screen.dart` → UPDATE search button

---

### PHASE 4: Implement Sort (1.5 hours)

#### Step 4.1: Define Sort Options
**Goal:** Create sort enum and options

**New File:** `lib/models/task_sort_option.dart`
```dart
enum TaskSortOption {
  dueDate,
  priority,
  title,
  createdDate,
  completionStatus,
}

extension TaskSortOptionExt on TaskSortOption {
  String getLabel(AppLocalizations l10n) {
    switch (this) {
      case TaskSortOption.dueDate:
        return l10n.sortByDueDate;
      case TaskSortOption.priority:
        return l10n.sortByPriority;
      case TaskSortOption.title:
        return l10n.sortByTitle;
      case TaskSortOption.createdDate:
        return l10n.sortByCreatedDate;
      case TaskSortOption.completionStatus:
        return l10n.sortByStatus;
    }
  }
  
  IconData get icon {
    switch (this) {
      case TaskSortOption.dueDate:
        return Icons.calendar_today;
      case TaskSortOption.priority:
        return Icons.priority_high;
      case TaskSortOption.title:
        return Icons.sort_by_alpha;
      case TaskSortOption.createdDate:
        return Icons.access_time;
      case TaskSortOption.completionStatus:
        return Icons.check_circle;
    }
  }
}
```

#### Step 4.2: Create Sort Menu Widget
**Goal:** Bottom sheet with sort options

**New File:** `lib/ui/screens/home/widgets/home_sort_menu.dart`
```dart
class HomeSortMenu extends StatelessWidget {
  final HomeController controller;
  
  void _showSortMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            title: Text('Sort By'),
            trailing: IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Divider(),
          ...TaskSortOption.values.map((option) => ListTile(
            leading: Icon(option.icon),
            title: Text(option.getLabel(AppLocalizations.of(context)!)),
            trailing: controller.sortOption.value == option
                ? Icon(Icons.check, color: Theme.of(context).colorScheme.primary)
                : null,
            onTap: () {
              controller.setSortOption(option);
              Navigator.pop(context);
            },
          )),
        ],
      ),
    );
  }
}
```

#### Step 4.3: Add Sort to HomeController
**Goal:** Manage sort state

**Enhanced HomeController:**
```dart
class HomeController {
  final ValueNotifier<TaskSortOption> sortOption = 
      ValueNotifier<TaskSortOption>(TaskSortOption.dueDate);
  final ValueNotifier<bool> sortAscending = ValueNotifier<bool>(true);
  
  void setSortOption(TaskSortOption option) {
    sortOption.value = option;
  }
  
  void toggleSortDirection() {
    sortAscending.value = !sortAscending.value;
  }
  
  List<Task> sortTasks(List<Task> tasks) {
    final sorted = List<Task>.from(tasks);
    
    switch (sortOption.value) {
      case TaskSortOption.dueDate:
        sorted.sort((a, b) {
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
        break;
      case TaskSortOption.priority:
        sorted.sort((a, b) => b.priority.index.compareTo(a.priority.index));
        break;
      case TaskSortOption.title:
        sorted.sort((a, b) => a.title.compareTo(b.title));
        break;
      case TaskSortOption.createdDate:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case TaskSortOption.completionStatus:
        sorted.sort((a, b) => a.isCompleted == b.isCompleted ? 0 : (a.isCompleted ? 1 : -1));
        break;
    }
    
    return sortAscending.value ? sorted : sorted.reversed.toList();
  }
}
```

#### Step 4.4: Wire Sort Button
**Goal:** Connect sort button to menu

**Location:** `lib/ui/screens/main_screen.dart`
```dart
// Update existing sort button (line 289-295)
IconButton(
  icon: const Icon(Icons.sort, color: Colors.white),
  onPressed: () {
    HapticFeedback.lightImpact();
    // Show sort menu
    final homeController = /* get controller from home screen */;
    HomeSortMenu(controller: homeController).show(context);
  },
  tooltip: AppLocalizations.of(context)?.sortTasks ?? 'Sort',
)
```

**Files Changed:**
- `lib/models/task_sort_option.dart` → CREATE
- `lib/ui/screens/home/widgets/home_sort_menu.dart` → CREATE
- `lib/ui/screens/home/home_controller.dart` → ENHANCE
- `lib/ui/screens/main_screen.dart` → UPDATE sort button
- `lib/l10n/app_en.arb` → ADD sort strings

---

### PHASE 5: Implement Task Details Navigation (1 hour)

#### Step 5.1: Update DSTaskCard Tap Behavior
**Goal:** Navigate to details screen on tap

**Current:**
```dart
DSTaskCard(
  task: task,
  onTap: () => _showEditTaskDialog(context, task),  // ❌ Wrong
)
```

**Updated:**
```dart
DSTaskCard(
  task: task,
  onTap: () => _navigateToTaskDetails(context, task),  // ✅ Correct
  onLongPress: () => _showQuickActions(context, task),  // ✅ New
)
```

#### Step 5.2: Implement Navigation Method
**Goal:** Navigate to TaskDetailsScreen

**Location:** `lib/ui/screens/home/home_screen.dart`
```dart
void _navigateToTaskDetails(BuildContext context, Task task) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TaskDetailsScreen(taskId: task.id),
    ),
  );
  
  // Refresh if task was modified
  if (result == true) {
    context.read<TaskListBloc>().add(LoadTasks());
  }
}
```

#### Step 5.3: Create Quick Actions Dialog
**Goal:** Show quick actions on long press

**New File:** `lib/ui/widgets/dialogs/task_quick_actions_dialog.dart`
```dart
class TaskQuickActionsDialog extends StatelessWidget {
  final Task task;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onDuplicate;
  final VoidCallback onViewDetails;
  
  static Future<void> show(BuildContext context, Task task, {
    required VoidCallback onEdit,
    required VoidCallback onDelete,
    required VoidCallback onDuplicate,
    required VoidCallback onViewDetails,
  }) {
    return showModalBottomSheet(
      context: context,
      builder: (context) => TaskQuickActionsDialog(
        task: task,
        onEdit: onEdit,
        onDelete: onDelete,
        onDuplicate: onDuplicate,
        onViewDetails: onViewDetails,
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('View Details'),
            onTap: () {
              Navigator.pop(context);
              onViewDetails();
            },
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Quick Edit'),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            leading: Icon(Icons.copy),
            title: Text('Duplicate'),
            onTap: () {
              Navigator.pop(context);
              onDuplicate();
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.delete, color: Colors.red),
            title: Text('Delete', style: TextStyle(color: Colors.red)),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}
```

**Files Changed:**
- `lib/ui/screens/home/home_screen.dart` → UPDATE tap handlers
- `lib/ui/widgets/dialogs/task_quick_actions_dialog.dart` → CREATE
- `lib/ui/design_system/components/ds_task_card.dart` → ADD onLongPress

---

### PHASE 6: Implement Task Delete (1 hour)

#### Step 6.1: Create Delete Confirmation Dialog
**Goal:** Confirm before deleting

**New File:** `lib/ui/widgets/dialogs/delete_confirmation_dialog.dart`
```dart
class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  
  static Future<bool?> show(BuildContext context, {
    required String title,
    required String message,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.orange),
            SizedBox(width: 12),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }
}
```

#### Step 6.2: Implement Delete with Undo
**Goal:** Delete task with undo option

**Location:** `lib/ui/screens/home/home_screen.dart`
```dart
void _deleteTask(BuildContext context, Task task) async {
  // Show confirmation
  final confirmed = await DeleteConfirmationDialog.show(
    context,
    title: 'Delete Task?',
    message: 'Are you sure you want to delete "${task.title}"? This action cannot be undone.',
  );
  
  if (confirmed != true) return;
  
  // Delete task
  context.read<TaskListBloc>().add(DeleteTask(task.id));
  
  // Show undo snackbar
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Task deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Re-add task
          context.read<TaskListBloc>().add(AddTask(task));
        },
      ),
      duration: Duration(seconds: 5),
    ),
  );
}
```

#### Step 6.3: Wire Delete to DSTaskCard
**Goal:** Connect delete action

**Location:** `lib/ui/screens/home/home_screen.dart`
```dart
DSTaskCard(
  task: task,
  onTap: () => _navigateToTaskDetails(context, task),
  onToggle: () => context.read<TaskListBloc>().add(ToggleTaskCompletion(task.id)),
  onDelete: () => _deleteTask(context, task),  // ✅ Now wired
  onLongPress: () => _showQuickActions(context, task),
)
```

**Files Changed:**
- `lib/ui/widgets/dialogs/delete_confirmation_dialog.dart` → CREATE
- `lib/ui/screens/home/home_screen.dart` → ADD delete methods
- `lib/ui/design_system/components/ds_task_card.dart` → WIRE onDelete

---

### PHASE 7: Extract Inline Widgets (2 hours)

#### Step 7.1: Extract Task List Widget
**Goal:** Move inline _buildTaskList to separate widget

**New File:** `lib/ui/screens/home/widgets/home_task_list.dart`
```dart
class HomeTaskList extends StatelessWidget {
  final HomeController controller;
  
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<String?>(
      valueListenable: controller.selectedCategoryId,
      builder: (context, selectedCategoryId, _) {
        return ValueListenableBuilder<DateTime?>(
          valueListenable: controller.selectedDate,
          builder: (context, selectedDate, _) {
            return ValueListenableBuilder<String>(
              valueListenable: controller.searchQuery,
              builder: (context, searchQuery, _) {
                return ValueListenableBuilder<TaskSortOption>(
                  valueListenable: controller.sortOption,
                  builder: (context, sortOption, _) {
                    return BlocBuilder<TaskListBloc, TaskListState>(
                      builder: (context, state) {
                        if (state is TaskListLoading) {
                          return SliverFillRemaining(
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        
                        if (state is TaskListLoaded) {
                          var tasks = _filterAndSortTasks(
                            state.tasks,
                            selectedCategoryId,
                            selectedDate,
                            searchQuery,
                            sortOption,
                          );
                          
                          if (tasks.isEmpty) {
                            return SliverFillRemaining(
                              child: DSEmptyState(
                                icon: Icons.task_alt_rounded,
                                title: 'No tasks',
                                message: 'Add a task to get started',
                                actionLabel: 'Add Task',
                                onAction: () => _showAddTaskDialog(context),
                              ),
                            );
                          }
                          
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final task = tasks[index];
                                return RepaintBoundary(
                                  child: DSTaskCard(
                                    task: task,
                                    onTap: () => _navigateToTaskDetails(context, task),
                                    onToggle: () => _toggleTask(context, task.id),
                                    onDelete: () => _deleteTask(context, task),
                                    onLongPress: () => _showQuickActions(context, task),
                                  ),
                                );
                              },
                              childCount: tasks.length,
                            ),
                          );
                        }
                        
                        return SliverFillRemaining(
                          child: Center(child: Text('Error loading tasks')),
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
  
  List<Task> _filterAndSortTasks(
    List<Task> tasks,
    String? categoryId,
    DateTime? date,
    String searchQuery,
    TaskSortOption sortOption,
  ) {
    var filtered = tasks.where((t) => t.dueDate != null && !t.isCompleted).toList();
    
    // Apply category filter
    if (categoryId != null) {
      filtered = filtered.where((t) => t.categoryId == categoryId).toList();
    }
    
    // Apply date filter
    if (date != null) {
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(Duration(days: 1));
      filtered = filtered.where((t) {
        final d = t.dueDate!;
        return !d.isBefore(start) && d.isBefore(end);
      }).toList();
    }
    
    // Apply search filter
    if (searchQuery.isNotEmpty) {
      final query = searchQuery.toLowerCase();
      filtered = filtered.where((t) {
        return t.title.toLowerCase().contains(query) ||
               (t.description?.toLowerCase().contains(query) ?? false);
      }).toList();
    }
    
    // Apply sort
    return controller.sortTasks(filtered);
  }
}
```

#### Step 7.2: Use Existing Refactored Widgets
**Goal:** Replace inline builders with existing widgets

**In `lib/ui/screens/home/home_screen.dart`:**
```dart
// BEFORE: Inline _buildTodayHeader (55 lines)
Widget _buildTodayHeader(BuildContext context) { ... }

// AFTER: Use existing HomeHeader widget
import 'widgets/home_header.dart';

SliverToBoxAdapter(child: HomeHeader(controller: _controller))
```

```dart
// BEFORE: Inline _buildQuickStats (87 lines)
Widget _buildQuickStats(BuildContext context) { ... }

// AFTER: Use existing HomeQuickStats (renamed to HomeStatsSection)
import 'widgets/home_stats_section.dart';

SliverToBoxAdapter(
  child: HomeStatsSection(
    onOverdueTap: () => _controller.setOverdueFilter(),
    onHighPriorityTap: () => _controller.setPriorityFilter(TaskPriority.high),
    onUndatedTap: () => _controller.setUndatedFilter(),
  ),
)
```

```dart
// BEFORE: Inline _buildCategoryFilter (59 lines)
Widget _buildCategoryFilter(BuildContext context) { ... }

// AFTER: Use existing HomeCategoryFilter
import 'widgets/home_category_filter.dart';

SliverToBoxAdapter(
  child: HomeCategoryFilter(controller: _controller),
)
```

**Result:** Reduce `home_screen.dart` from 575 lines to ~250 lines

**Files Changed:**
- `lib/ui/screens/home/widgets/home_task_list.dart` → CREATE
- `lib/ui/screens/home/home_screen.dart` → REFACTOR (remove inline builders)
- `lib/ui/widgets/home/home_quick_stats.dart` → MOVE to `lib/ui/screens/home/widgets/home_stats_section.dart`

---

### PHASE 8: Code Quality Improvements (1.5 hours)

#### Step 8.1: Localize All Strings
**Goal:** Replace hardcoded strings with l10n

**Files to Update:**
- `lib/ui/screens/home/home_screen.dart`
- `lib/ui/design_system/components/ds_task_card.dart`
- All new widgets created

**Strings to Add to `lib/l10n/app_en.arb`:**
```json
{
  "today": "Today",
  "tomorrow": "Tomorrow",
  "overdue": "Overdue",
  "category": "Category",
  "allCategories": "All Categories",
  "addTask": "Add Task",
  "noTasks": "No tasks",
  "addTaskToGetStarted": "Add a task to get started",
  "sortByDueDate": "Sort by Due Date",
  "sortByPriority": "Sort by Priority",
  "sortByTitle": "Sort by Title",
  "sortByCreatedDate": "Sort by Created Date",
  "sortByStatus": "Sort by Status",
  "sortTasks": "Sort Tasks",
  "searchTasks": "Search Tasks",
  "deleteTask": "Delete Task",
  "deleteTaskConfirmation": "Are you sure you want to delete this task?",
  "taskDeleted": "Task deleted",
  "undo": "Undo",
  "viewDetails": "View Details",
  "quickEdit": "Quick Edit",
  "duplicate": "Duplicate",
  "tasksWithoutDates": "Tasks without dates"
}
```

#### Step 8.2: Add Error Handling
**Goal:** Handle edge cases gracefully

**Example - Safe Category Lookup:**
```dart
// BEFORE (line 382 in home_screen_redesigned.dart)
final category = state.categories.firstWhere((c) => c.id == selectedCategoryId);
// ❌ Throws if not found

// AFTER
final category = state.categories.firstWhere(
  (c) => c.id == selectedCategoryId,
  orElse: () => Category(
    id: selectedCategoryId,
    name: 'Unknown',
    color: Colors.grey,
    userId: '',
    createdAt: DateTime.now(),
  ),
);
```

#### Step 8.3: Replace Magic Numbers with Tokens
**Goal:** Use design system constants

**Examples:**
```dart
// BEFORE
const SizedBox(height: 80)
height: 56

// AFTER
const SizedBox(height: DSSpacing.xxxl)
height: DSSpacing.chipHeight  // Add to ds_spacing.dart
```

#### Step 8.4: Add Documentation
**Goal:** Document all public APIs

**Example:**
```dart
/// Displays the home screen with task list, filters, and quick stats.
///
/// This screen is the main entry point for task management. It provides:
/// - Task list with filtering by category and date
/// - Quick stats for overdue, high priority, and undated tasks
/// - Search functionality
/// - Sort options
/// - Navigation to task details
///
/// The screen uses [HomeController] for UI state management and
/// [TaskListBloc] for business logic.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
```

**Files Changed:**
- All files in `lib/ui/screens/home/`
- All files in `lib/ui/design_system/components/`
- `lib/l10n/app_en.arb` → ADD strings
- `lib/l10n/app_ar.arb` → ADD translations
- `lib/l10n/app_es.arb` → ADD translations
- `lib/l10n/app_fr.arb` → ADD translations

---

### PHASE 9: Testing & Polish (1 hour)

#### Step 9.1: Manual Testing Checklist
- [ ] Search filters tasks correctly
- [ ] Sort changes task order
- [ ] Tap navigates to task details
- [ ] Long press shows quick actions
- [ ] Delete shows confirmation
- [ ] Delete with undo works
- [ ] Swipe actions work (if implemented)
- [ ] All filters work together
- [ ] Empty states show correctly
- [ ] Loading states show correctly
- [ ] Error states show correctly
- [ ] Animations are smooth
- [ ] No performance issues
- [ ] All strings localized
- [ ] Dark mode works
- [ ] RTL languages work (Arabic)

#### Step 9.2: Run Analysis
```bash
flutter analyze
flutter test
```

#### Step 9.3: Performance Check
```bash
flutter run --profile
# Check for:
# - Smooth 60fps scrolling
# - No jank on filter/sort
# - Fast search response
```

---

## 📊 IMPLEMENTATION SUMMARY

### Time Estimate
- **Phase 1:** Foundation & Cleanup - 2-3 hours
- **Phase 2:** Enhance DSTaskCard - 1 hour
- **Phase 3:** Implement Search - 2 hours
- **Phase 4:** Implement Sort - 1.5 hours
- **Phase 5:** Task Details Navigation - 1 hour
- **Phase 6:** Task Delete - 1 hour
- **Phase 7:** Extract Inline Widgets - 2 hours
- **Phase 8:** Code Quality - 1.5 hours
- **Phase 9:** Testing & Polish - 1 hour

**Total:** 12-13 hours

### Files Summary
- **Files to Create:** 12
- **Files to Delete:** 4
- **Files to Move:** 5
- **Files to Modify:** 15
- **Net Change:** +8 files

### Code Metrics
- **Lines Removed:** ~634 (dead code)
- **Lines Refactored:** ~575 (inline to components)
- **Lines Added:** ~800 (new features)
- **Net Change:** ~+166 lines
- **Code Reuse:** 451 lines of existing code integrated

---

**Next:** Part 3 - Implementation Code
