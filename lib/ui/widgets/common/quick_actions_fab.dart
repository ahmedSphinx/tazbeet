import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';

/// Quick Action Configuration
class QuickAction {
  final String label;
  final IconData icon;
  final Color color;
  final void Function(BuildContext) onTap;

  const QuickAction({required this.label, required this.icon, required this.color, required this.onTap});
}

/// Quick Actions Floating Action Button with Speed Dial
/// Provides quick access to common actions from any screen
class QuickActionsFAB extends StatefulWidget {
  /// Context-aware actions based on current screen
  final List<QuickAction> actions;

  /// Primary action color
  final Color? primaryColor;

  const QuickActionsFAB({super.key, required this.actions, this.primaryColor});

  @override
  State<QuickActionsFAB> createState() => _QuickActionsFABState();
}

class _QuickActionsFABState extends State<QuickActionsFAB> {
  void _showQuickActionsBottomSheet() {
    HapticFeedback.lightImpact();

    showModalBottomSheet(context: context, backgroundColor: Colors.transparent, isScrollControlled: true, builder: (context) => _buildQuickActionsBottomSheet());
  }

  Widget _buildQuickActionsBottomSheet() {
    final primaryColor = widget.primaryColor ?? Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(Icons.flash_on_rounded, color: primaryColor, size: 24),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context)?.quickActions ?? 'Quick Actions',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Actions list
          ...widget.actions.map((action) => _buildActionTile(action, primaryColor)),

          // Bottom padding for safe area
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildActionTile(QuickAction action, Color primaryColor) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        action.onTap(context);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: action.color.withValues(alpha: 0.1)),
        child: Row(
          children: [
            // Icon container
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: action.color, borderRadius: BorderRadius.circular(10)),
              child: Icon(action.icon, color: Colors.white, size: 20),
            ),

            const SizedBox(width: 16),

            // Action text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    action.label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  const SizedBox(height: 2),
                  Text(_getActionDescription(action), style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
                ],
              ),
            ),

            // Arrow icon
            Icon(Icons.arrow_forward_ios, size: 16, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.4)),
          ],
        ),
      ),
    );
  }

  String _getActionDescription(QuickAction action) {
    // Provide descriptions based on the action icon or label
    if (action.icon == Icons.mood) {
      return 'Track your current mood';
    } else if (action.icon == Icons.task_alt) {
      return 'Add a task quickly';
    } else if (action.icon == Icons.note_add) {
      return 'Create a detailed task';
    } else if (action.icon == Icons.folder) {
      return 'Organize with categories';
    } else if (action.icon == Icons.mic) {
      return 'Create tasks with your voice';
    } else {
      return 'Quick action';
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? Theme.of(context).colorScheme.primary;

    return FloatingActionButton(
      heroTag: 'quick_actions_fab',
      onPressed: _showQuickActionsBottomSheet,
      backgroundColor: primaryColor,
      child: Icon(Icons.add_rounded, color: Theme.of(context).colorScheme.onPrimary, size: 28),
    );
  }
}

/// Predefined Quick Actions for the app
class AppQuickActions {
  /// Log Mood Action
  static QuickAction logMood(BuildContext context, {required VoidCallback onLogMood}) => QuickAction(label: AppLocalizations.of(context)!.logMood, icon: Icons.mood, color: Colors.purple, onTap: (ctx) => onLogMood());

  /// Voice Task Action
  static QuickAction voiceTask(BuildContext context, {required VoidCallback onVoiceTask}) => QuickAction(label: 'Create Task with Voice', icon: Icons.mic, color: Colors.red, onTap: (ctx) => onVoiceTask());

  /// Quick Add Task Action
  static QuickAction quickAddTask(BuildContext context, {required VoidCallback onQuickAddTask}) => QuickAction(label: 'Quick Add Task', icon: Icons.task_alt, color: Colors.blue, onTap: (ctx) => onQuickAddTask());

  /// Add Detailed Task Action
  static QuickAction addDetailedTask(BuildContext context, {required VoidCallback onAddDetailedTask}) =>
      QuickAction(label: AppLocalizations.of(context)!.addTaskTitle, icon: Icons.note_add, color: Colors.green, onTap: (ctx) => onAddDetailedTask());

  /// Add Category Action
  static QuickAction addCategory(BuildContext context, {required VoidCallback onAddCategory}) =>
      QuickAction(label: AppLocalizations.of(context)!.addCategory, icon: Icons.category, color: Colors.orange, onTap: (ctx) => onAddCategory());

  /// Default actions for Home Screen
  static List<QuickAction> forHomeScreen(
    BuildContext context, {
    required VoidCallback onLogMood,
    required VoidCallback onQuickAddTask,
    required VoidCallback onAddDetailedTask,
    required VoidCallback onAddCategory,
    VoidCallback? onVoiceTask,
  }) {
    final actions = [
      logMood(context, onLogMood: onLogMood),
      // quickAddTask(context, onQuickAddTask: onQuickAddTask),
      addDetailedTask(context, onAddDetailedTask: onAddDetailedTask),
      addCategory(context, onAddCategory: onAddCategory),
    ];

    // Voice task temporarily disabled
    // if (onVoiceTask != null) {
    //   actions.insert(1, voiceTask(context, onVoiceTask: onVoiceTask));
    // }

    return actions;
  }
}
