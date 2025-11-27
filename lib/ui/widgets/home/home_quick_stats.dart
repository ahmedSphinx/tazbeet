import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/ui/design_system/ds_spacing.dart';
import 'package:tazbeet/ui/design_system/ds_typography.dart';
import 'package:tazbeet/ui/design_system/ds_colors.dart';
import 'package:tazbeet/ui/design_system/ds_border_radius.dart';
import 'package:tazbeet/ui/design_system/ds_elevation.dart';

/// Quick stats cards showing overdue, high priority, and undated task counts
class HomeQuickStats extends StatelessWidget {
  final VoidCallback? onOverdueTap;
  final VoidCallback? onHighPriorityTap;
  final VoidCallback? onUndatedTap;

  const HomeQuickStats({super.key, this.onOverdueTap, this.onHighPriorityTap, this.onUndatedTap});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use vertical layout on very narrow screens
        final isNarrow = constraints.maxWidth < 300;
        final spacing = isNarrow ? 8.0 : 12.0;

        final cards = [_OverdueCard(onTap: onOverdueTap), _HighPriorityCard(onTap: onHighPriorityTap), _UndatedCard(onTap: onUndatedTap)];

        if (isNarrow) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: cards
                .map(
                  (card) => Padding(
                    padding: EdgeInsets.only(bottom: spacing),
                    child: SizedBox(height: 80, child: card),
                  ),
                )
                .toList(),
          );
        }

        return Row(
          children: [
            for (int i = 0; i < cards.length; i++) ...[Expanded(child: cards[i]), if (i < cards.length - 1) SizedBox(width: spacing)],
          ],
        );
      },
    );
  }
}

/// Reusable stat card with tap animation
class _StatCard extends StatefulWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final String semanticLabel;
  final VoidCallback? onTap;

  const _StatCard({required this.icon, required this.value, required this.label, required this.color, required this.semanticLabel, this.onTap});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> with SingleTickerProviderStateMixin {
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
      label: widget.semanticLabel,
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

class _OverdueCard extends StatelessWidget {
  final VoidCallback? onTap;
  const _OverdueCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocSelector<TaskListBloc, TaskListState, int>(
      selector: (state) {
        if (state is! TaskListLoaded) return 0;
        final now = DateTime.now();
        return state.tasks.where((t) => !t.isCompleted && t.dueDate != null && t.dueDate!.isBefore(now)).length;
      },
      builder: (context, count) => _StatCard(icon: Icons.warning_amber_rounded, value: '$count', label: l10n.overdue, color: DSColors.getOverdueColor(context), semanticLabel: 'Overdue tasks: $count', onTap: onTap),
    );
  }
}

class _HighPriorityCard extends StatelessWidget {
  final VoidCallback? onTap;
  const _HighPriorityCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocSelector<TaskListBloc, TaskListState, int>(
      selector: (state) {
        if (state is! TaskListLoaded) return 0;
        return state.tasks.where((t) => !t.isCompleted && t.priority == TaskPriority.high).length;
      },
      builder: (context, count) =>
          _StatCard(icon: Icons.priority_high, value: '$count', label: l10n.highPriorityLabel, color: DSColors.getHighPriorityColor(context), semanticLabel: 'High priority tasks: $count', onTap: onTap),
    );
  }
}

class _UndatedCard extends StatelessWidget {
  final VoidCallback? onTap;
  const _UndatedCard({this.onTap});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocSelector<TaskListBloc, TaskListState, int>(
      selector: (state) {
        if (state is! TaskListLoaded) return 0;
        return state.tasks.where((t) => t.dueDate == null).length;
      },
      builder: (context, count) => _StatCard(icon: Icons.event_busy, value: '$count', label: l10n.noDueDate, color: DSColors.getUndatedColor(context), semanticLabel: 'Undated tasks: $count', onTap: onTap),
    );
  }
}
