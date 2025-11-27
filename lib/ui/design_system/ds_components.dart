import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tazbeet/models/task.dart';
import 'ds_spacing.dart';
import 'ds_typography.dart';
import 'ds_colors.dart';
import 'ds_border_radius.dart';
import 'ds_elevation.dart';

/// Design System: Reusable Component Library
/// All components follow WCAG AA standards and design tokens

// ============================================================================
// STAT CARD COMPONENT
// ============================================================================

class DSStatCard extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final String? semanticLabel;

  const DSStatCard({super.key, required this.icon, required this.value, required this.label, required this.color, this.onTap, this.semanticLabel});

  @override
  State<DSStatCard> createState() => _DSStatCardState();
}

class _DSStatCardState extends State<DSStatCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    HapticFeedback.lightImpact();
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) => _controller.reverse();
  void _handleTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: widget.semanticLabel ?? '${widget.label}: ${widget.value}',
      hint: 'Tap to filter',
      button: true,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) => Transform.scale(scale: _scaleAnimation.value, child: child),
          child: Container(
            padding: const EdgeInsets.all(DSSpacing.md),
            constraints: const BoxConstraints(minHeight: 120),
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.08),
              borderRadius: DSBorderRadius.lgRadius,
              border: Border.all(color: widget.color.withValues(alpha: 0.25), width: 1.5),
              boxShadow: DSElevation.getBoxShadow(context, DSElevation.level2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(widget.icon, color: widget.color, size: 32),
                const SizedBox(height: DSSpacing.sm),
                Text(widget.value, style: DSTypography.headline(context).copyWith(color: widget.color)),
                const SizedBox(height: DSSpacing.xs),
                Text(
                  widget.label,
                  style: DSTypography.label(context).copyWith(color: DSColors.getOnSurfaceColor(context)),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// TASK CARD COMPONENT
// ============================================================================

class DSTaskCard extends StatelessWidget {
  final Task task;
  final VoidCallback? onTap;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onLongPress;
  final bool isSelected;
  final bool showDeleteButton;

  const DSTaskCard({super.key, required this.task, this.onTap, this.onToggle, this.onDelete, this.onLongPress, this.isSelected = false, this.showDeleteButton = false});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final priorityColor = DSColors.getPriorityColor(task.priority, isDark);

    return Card(
      elevation: isSelected ? 4 : 1,
      margin: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.xs),
      shape: RoundedRectangleBorder(
        borderRadius: DSBorderRadius.mdRadius,
        side: isSelected ? BorderSide(color: Theme.of(context).colorScheme.primary, width: 2) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: DSBorderRadius.mdRadius,
        child: Padding(
          padding: const EdgeInsets.all(DSSpacing.md),
          child: Row(
            children: [
              // Priority Indicator
              DSPriorityIndicator(priority: task.priority, height: 48),
              const SizedBox(width: DSSpacing.md),

              // Checkbox
              Checkbox(value: task.isCompleted, onChanged: (_) => onToggle?.call(), shape: const CircleBorder()),
              const SizedBox(width: DSSpacing.sm),

              // Task Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: DSTypography.body(
                        context,
                      ).copyWith(decoration: task.isCompleted ? TextDecoration.lineThrough : null, color: task.isCompleted ? DSColors.getOnSurfaceColor(context, opacity: 0.6) : DSColors.getOnSurfaceColor(context)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (task.dueDate != null) ...[
                      const SizedBox(height: DSSpacing.xs),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: 14, color: priorityColor),
                          const SizedBox(width: DSSpacing.xs),
                          Text(_formatDate(task.dueDate!), style: DSTypography.caption(context).copyWith(color: priorityColor)),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              // Priority Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: DSSpacing.sm, vertical: DSSpacing.xs),
                decoration: BoxDecoration(color: priorityColor.withValues(alpha: 0.15), borderRadius: DSBorderRadius.smRadius),
                child: Text(
                  task.priority.name.toUpperCase(),
                  style: DSTypography.caption(context).copyWith(color: priorityColor, fontWeight: FontWeight.w600),
                ),
              ),

              // Delete Button (optional)
              if (showDeleteButton && onDelete != null) ...[
                const SizedBox(width: DSSpacing.sm),
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 20),
                  onPressed: onDelete,
                  color: Colors.red,
                  tooltip: 'Delete task',
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  padding: const EdgeInsets.all(DSSpacing.xs),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) return 'Today';
    if (taskDate == today.add(const Duration(days: 1))) return 'Tomorrow';
    if (taskDate.isBefore(today)) return 'Overdue';

    return '${date.month}/${date.day}';
  }
}

// ============================================================================
// PRIORITY INDICATOR COMPONENT
// ============================================================================

class DSPriorityIndicator extends StatelessWidget {
  final TaskPriority priority;
  final double width;
  final double height;

  const DSPriorityIndicator({super.key, required this.priority, this.width = 4, this.height = 40});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = DSColors.getPriorityColor(priority, isDark);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(width / 2)),
    );
  }
}

// ============================================================================
// CATEGORY CHIP COMPONENT
// ============================================================================

class DSCategoryChip extends StatelessWidget {
  final String? id;
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const DSCategoryChip({super.key, required this.id, required this.label, required this.icon, required this.color, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(right: DSSpacing.sm),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: FilterChip(
          label: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: isSelected ? theme.colorScheme.onPrimaryContainer : color),
              const SizedBox(width: DSSpacing.sm),
              Text(
                label,
                style: DSTypography.body(context).copyWith(color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal),
              ),
            ],
          ),
          selected: isSelected,
          onSelected: (_) => onTap(),
          showCheckmark: false,
          backgroundColor: color.withValues(alpha: 0.12),
          selectedColor: theme.colorScheme.primaryContainer,
          side: BorderSide(color: isSelected ? theme.colorScheme.primary : color.withValues(alpha: 0.25), width: isSelected ? 2 : 1),
          padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.sm),
        ),
      ),
    );
  }
}

// ============================================================================
// ENHANCED FAB COMPONENT
// ============================================================================

class DSEnhancedFAB extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? label;
  final String tooltip;

  const DSEnhancedFAB({super.key, required this.onPressed, this.icon = Icons.add, this.label, this.tooltip = 'Add'});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Semantics(
      label: tooltip,
      button: true,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: DSBorderRadius.lgRadius,
          boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 8))],
        ),
        child: label != null
            ? FloatingActionButton.extended(
                onPressed: onPressed,
                icon: Icon(icon, size: 24),
                label: Text(
                  label!,
                  style: DSTypography.body(context).copyWith(color: theme.colorScheme.onPrimary, fontWeight: FontWeight.w600),
                ),
                elevation: DSElevation.level4,
                tooltip: tooltip,
              )
            : FloatingActionButton(onPressed: onPressed, elevation: DSElevation.level4, tooltip: tooltip, child: Icon(icon, size: 28)),
      ),
    );
  }
}

// ============================================================================
// SECTION HEADER COMPONENT
// ============================================================================

class DSSectionHeader extends StatelessWidget {
  final String title;
  final IconData? icon;
  final String? badge;
  final VoidCallback? onActionTap;
  final IconData? actionIcon;

  const DSSectionHeader({super.key, required this.title, this.icon, this.badge, this.onActionTap, this.actionIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.sm),
      child: Row(
        children: [
          if (icon != null) ...[Icon(icon, size: 20, color: Theme.of(context).colorScheme.primary), const SizedBox(width: DSSpacing.sm)],
          Text(title, style: DSTypography.subtitle(context)),
          if (badge != null) ...[
            const SizedBox(width: DSSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: DSSpacing.sm, vertical: DSSpacing.xs),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: DSBorderRadius.fullRadius),
              child: Text(
                badge!,
                style: DSTypography.caption(context).copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer, fontWeight: FontWeight.w600),
              ),
            ),
          ],
          const Spacer(),
          if (onActionTap != null && actionIcon != null) IconButton(icon: Icon(actionIcon, size: 20), onPressed: onActionTap, tooltip: 'Action'),
        ],
      ),
    );
  }
}

// ============================================================================
// EMPTY STATE COMPONENT
// ============================================================================

class DSEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const DSEmptyState({super.key, required this.icon, required this.title, required this.message, this.actionLabel, this.onAction});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final content = Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: Theme.of(context).colorScheme.outline),
            const SizedBox(height: DSSpacing.md),
            Text(title, style: DSTypography.subtitle(context), textAlign: TextAlign.center),
            const SizedBox(height: DSSpacing.sm),
            Text(
              message,
              style: DSTypography.body(context).copyWith(color: DSColors.getOnSurfaceColor(context, opacity: 0.7)),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[const SizedBox(height: DSSpacing.lg), ElevatedButton.icon(onPressed: onAction, icon: const Icon(Icons.add), label: Text(actionLabel!))],
          ],
        );

        // Allow scrolling when vertical space is tight to avoid overflow
        return SingleChildScrollView(
          padding: const EdgeInsets.all(DSSpacing.xl),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Center(child: content),
          ),
        );
      },
    );
  }
}
