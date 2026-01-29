import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../l10n/app_localizations.dart';

/// Action suggestion for empty states
class EmptyStateAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isPrimary;

  const EmptyStateAction({required this.label, required this.icon, required this.onTap, this.isPrimary = false});
}

/// Smart empty state widget with contextual suggestions
class SmartEmptyState extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final List<EmptyStateAction> actions;
  final Color? color;
  final Widget? illustration;
  final bool showAnimation;

  const SmartEmptyState({super.key, required this.title, required this.description, required this.icon, this.actions = const [], this.color, this.illustration, this.showAnimation = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.colorScheme.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration or Icon
            if (illustration != null) illustration! else _buildAnimatedIcon(effectiveColor),

            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: effectiveColor),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 12),

            // Description
            Text(
              description,
              style: theme.textTheme.bodyLarge?.copyWith(color: Colors.grey[600], height: 1.5),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            // Actions
            if (actions.isNotEmpty) _buildActions(context, effectiveColor),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedIcon(Color color) {
    if (!showAnimation) {
      return Icon(icon, size: 80, color: color.withValues(alpha: 0.7));
    }

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.elasticOut,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Icon(icon, size: 80, color: color.withValues(alpha: 0.7)),
        );
      },
    );
  }

  Widget _buildActions(BuildContext context, Color color) {
    return Column(
      children: [
        // Primary actions (full width buttons)
        ...actions
            .where((action) => action.isPrimary)
            .map(
              (action) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton.icon(
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    action.onTap();
                  },
                  icon: Icon(action.icon),
                  label: Text(action.label),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),

        // Secondary actions (text buttons in a row)
        if (actions.where((action) => !action.isPrimary).isNotEmpty) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: actions
                .where((action) => !action.isPrimary)
                .map(
                  (action) => TextButton.icon(
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      action.onTap();
                    },
                    icon: Icon(action.icon, size: 18),
                    label: Text(action.label),
                    style: TextButton.styleFrom(foregroundColor: color),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}

/// Predefined empty states for common scenarios
class TaskEmptyStates {
  /// Empty subtasks state
  static SmartEmptyState noSubtasks({required VoidCallback onAddSubtask, AppLocalizations? l10n}) {
    return SmartEmptyState(
      title: l10n!.noSubtasksYet,
      description: l10n!.subtasks,
      icon: Icons.checklist,
      color: Colors.blue,
      actions: [
        EmptyStateAction(label: l10n.addSubtask, icon: Icons.add, onTap: onAddSubtask, isPrimary: true),
        //  if (onAddFromTemplate != null) EmptyStateAction(label: "Use Template", icon: Icons.copy, onTap: onAddFromTemplate),
      ],
    );
  }

  /// Empty attachments state
  static SmartEmptyState noAttachments({required VoidCallback onAddPhoto, required VoidCallback onAddFile, VoidCallback? onAddVoiceNote}) {
    return SmartEmptyState(
      title: "No Attachments",
      description: "Add photos, files, or voice notes to provide more context for this task.",
      icon: Icons.attach_file,
      color: Colors.green,
      actions: [
        EmptyStateAction(label: "Add Photo", icon: Icons.camera_alt, onTap: onAddPhoto, isPrimary: true),
        EmptyStateAction(label: "Add File", icon: Icons.file_upload, onTap: onAddFile),
        if (onAddVoiceNote != null) EmptyStateAction(label: "Voice Note", icon: Icons.mic, onTap: onAddVoiceNote),
      ],
    );
  }

  /// Empty pomodoro sessions state
  static SmartEmptyState noPomodoroSessions({required VoidCallback onStartFirstSession, VoidCallback? onLearnMore}) {
    return SmartEmptyState(
      title: "Ready to Focus?",
      description: "Start your first Pomodoro session to boost productivity and track your focused work time.",
      icon: Icons.timer,
      color: Colors.orange,
      actions: [
        EmptyStateAction(label: "Start 25-Min Session", icon: Icons.play_arrow, onTap: onStartFirstSession, isPrimary: true),
        if (onLearnMore != null) EmptyStateAction(label: "Learn About Pomodoro", icon: Icons.help_outline, onTap: onLearnMore),
      ],
    );
  }

  /// Empty comments state
  static SmartEmptyState noComments({required VoidCallback onAddComment, VoidCallback? onInviteCollaborator}) {
    return SmartEmptyState(
      title: "No Comments",
      description: "Add notes, updates, or collaborate with others by leaving comments on this task.",
      icon: Icons.comment,
      color: Colors.purple,
      actions: [
        EmptyStateAction(label: "Add Comment", icon: Icons.add_comment, onTap: onAddComment, isPrimary: true),
        if (onInviteCollaborator != null) EmptyStateAction(label: "Invite Others", icon: Icons.person_add, onTap: onInviteCollaborator),
      ],
    );
  }

  /// Empty reminders state
  static SmartEmptyState noReminders({required VoidCallback onSetReminder, VoidCallback? onUseSuggestion}) {
    return SmartEmptyState(
      title: "Stay on Track",
      description: "Set up reminders to ensure you never miss important deadlines or forget about this task.",
      icon: Icons.notifications_none,
      color: Colors.amber,
      actions: [
        EmptyStateAction(label: "Set Reminder", icon: Icons.alarm_add, onTap: onSetReminder, isPrimary: true),
        if (onUseSuggestion != null) EmptyStateAction(label: "Smart Suggestion", icon: Icons.lightbulb_outline, onTap: onUseSuggestion),
      ],
    );
  }

  /// Task completion celebration
  static SmartEmptyState taskCompleted({required VoidCallback onViewNext, VoidCallback? onShare, VoidCallback? onDuplicate}) {
    return SmartEmptyState(
      title: "Task Completed! 🎉",
      description: "Great job! You've successfully completed this task. What would you like to do next?",
      icon: Icons.celebration,
      color: Colors.green,
      actions: [
        EmptyStateAction(label: "View Next Task", icon: Icons.arrow_forward, onTap: onViewNext, isPrimary: true),
        if (onShare != null) EmptyStateAction(label: "Share Success", icon: Icons.share, onTap: onShare),
        if (onDuplicate != null) EmptyStateAction(label: "Create Similar", icon: Icons.copy, onTap: onDuplicate),
      ],
    );
  }

  /// Loading error state
  static SmartEmptyState loadingError({required VoidCallback onRetry, VoidCallback? onGoBack, String? errorMessage}) {
    return SmartEmptyState(
      title: "Something Went Wrong",
      description: errorMessage ?? "We couldn't load this task. Please check your connection and try again.",
      icon: Icons.error_outline,
      color: Colors.red,
      actions: [
        EmptyStateAction(label: "Try Again", icon: Icons.refresh, onTap: onRetry, isPrimary: true),
        if (onGoBack != null) EmptyStateAction(label: "Go Back", icon: Icons.arrow_back, onTap: onGoBack),
      ],
    );
  }

  /// Network offline state
  static SmartEmptyState offline({required VoidCallback onRetry, VoidCallback? onWorkOffline}) {
    return SmartEmptyState(
      title: "You're Offline",
      description: "Check your internet connection to sync your latest changes and access all features.",
      icon: Icons.cloud_off,
      color: Colors.grey,
      actions: [
        EmptyStateAction(label: "Retry Connection", icon: Icons.refresh, onTap: onRetry, isPrimary: true),
        if (onWorkOffline != null) EmptyStateAction(label: "Continue Offline", icon: Icons.offline_bolt, onTap: onWorkOffline),
      ],
    );
  }
}
