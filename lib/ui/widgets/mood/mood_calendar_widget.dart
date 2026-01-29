import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../models/mood.dart';
import 'dart:math' as math;

/// Interactive calendar widget showing mood data as a heatmap
class MoodCalendarWidget extends StatefulWidget {
  final List<Mood> moods;
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthChanged;
  final ValueChanged<DateTime> onDateSelected;

  const MoodCalendarWidget({super.key, required this.moods, required this.selectedMonth, required this.onMonthChanged, required this.onDateSelected});

  @override
  State<MoodCalendarWidget> createState() => _MoodCalendarWidgetState();
}

class _MoodCalendarWidgetState extends State<MoodCalendarWidget> with TickerProviderStateMixin {
  late AnimationController _heatmapController;
  late Animation<double> _heatmapAnimation;

  @override
  void initState() {
    super.initState();

    _heatmapController = AnimationController(duration: const Duration(milliseconds: 1200), vsync: this);

    _heatmapAnimation = CurvedAnimation(parent: _heatmapController, curve: Curves.easeOutCubic);

    _heatmapController.forward();
  }

  @override
  void dispose() {
    _heatmapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [theme.colorScheme.primaryContainer.withValues(alpha: 0.2), theme.colorScheme.secondaryContainer.withValues(alpha: 0.1), theme.colorScheme.surface], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 30, offset: const Offset(0, 15))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with month navigation
          _buildHeader(theme),

          const SizedBox(height: 20),

          // Calendar heatmap
          AnimatedBuilder(
            animation: _heatmapAnimation,
            builder: (context, child) {
              return Opacity(opacity: _heatmapAnimation.value, child: _buildCalendarGrid(theme));
            },
          ),

          const SizedBox(height: 16),

          // Legend
          _buildLegend(theme),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final monthNames = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];

    return Row(
      children: [
        // Calendar icon
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [theme.colorScheme.primary, theme.colorScheme.secondary]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: const Icon(Icons.calendar_month, color: Colors.white, size: 20),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📅 Mood Calendar',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 4),
              Text('Tap any day to see details', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            ],
          ),
        ),

        // Month navigation
        Row(
          children: [
            _buildNavButton(theme, Icons.chevron_left, () {
              final newMonth = DateTime(widget.selectedMonth.year, widget.selectedMonth.month - 1);
              widget.onMonthChanged(newMonth);
              _heatmapController.reset();
              _heatmapController.forward();
            }),

            const SizedBox(width: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
              ),
              child: Text(
                '${monthNames[widget.selectedMonth.month - 1]} ${widget.selectedMonth.year}',
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
              ),
            ),

            const SizedBox(width: 12),

            _buildNavButton(theme, Icons.chevron_right, () {
              final newMonth = DateTime(widget.selectedMonth.year, widget.selectedMonth.month + 1);
              widget.onMonthChanged(newMonth);
              _heatmapController.reset();
              _heatmapController.forward();
            }),
          ],
        ),
      ],
    );
  }

  Widget _buildNavButton(ThemeData theme, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withValues(alpha: 0.8),
          shape: BoxShape.circle,
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
          boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Icon(icon, size: 20, color: theme.colorScheme.onSurface),
      ),
    );
  }

  Widget _buildCalendarGrid(ThemeData theme) {
    final daysInMonth = DateTime(widget.selectedMonth.year, widget.selectedMonth.month + 1, 0).day;

    final firstDayOfMonth = DateTime(widget.selectedMonth.year, widget.selectedMonth.month, 1);

    final firstWeekday = firstDayOfMonth.weekday % 7; // Make Sunday = 0

    return Column(
      children: [
        // Weekday headers
        Row(
          children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 12),

        // Calendar grid
        ...List.generate(6, (weekIndex) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - firstWeekday + 1;

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const Expanded(child: SizedBox(height: 40));
                }

                final date = DateTime(widget.selectedMonth.year, widget.selectedMonth.month, dayNumber);

                return Expanded(child: _buildDayCell(theme, date, dayNumber, weekIndex * 7 + dayIndex));
              }),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDayCell(ThemeData theme, DateTime date, int dayNumber, int index) {
    final dayMoods = widget.moods.where((mood) => mood.date.year == date.year && mood.date.month == date.month && mood.date.day == date.day).toList();

    final averageMood = dayMoods.isEmpty ? null : dayMoods.map((m) => m.level.index).reduce((a, b) => a + b) / dayMoods.length;

    final isToday = DateTime.now().year == date.year && DateTime.now().month == date.month && DateTime.now().day == date.day;

    return AnimatedBuilder(
      animation: _heatmapAnimation,
      builder: (context, child) {
        final delay = index * 0.02;
        final animationValue = math.max(0.0, math.min(1.0, (_heatmapAnimation.value - delay) / (1.0 - delay)));

        return Transform.scale(
          scale: 0.7 + (animationValue * 0.3),
          child: Opacity(
            opacity: animationValue,
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                widget.onDateSelected(date);
              },
              child: Container(
                height: 40,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _getMoodColor(theme, averageMood),
                  borderRadius: BorderRadius.circular(8),
                  border: isToday ? Border.all(color: theme.colorScheme.primary, width: 2) : null,
                  boxShadow: dayMoods.isNotEmpty ? [BoxShadow(color: _getMoodColor(theme, averageMood).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 2))] : null,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        dayNumber.toString(),
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: dayMoods.isEmpty ? theme.colorScheme.onSurface.withValues(alpha: 0.6) : Colors.white),
                      ),
                      if (dayMoods.length > 1)
                        Container(
                          width: 4,
                          height: 4,
                          margin: const EdgeInsets.only(top: 2),
                          decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLegend(ThemeData theme) {
    return Row(
      children: [
        Text('Mood intensity: ', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),

        const SizedBox(width: 8),

        Row(
          children: [
            _buildLegendItem(theme, 'Low', Colors.red.withValues(alpha: 0.3)),
            const SizedBox(width: 4),
            _buildLegendItem(theme, '', Colors.orange.withValues(alpha: 0.5)),
            const SizedBox(width: 4),
            _buildLegendItem(theme, '', Colors.yellow.withValues(alpha: 0.7)),
            const SizedBox(width: 4),
            _buildLegendItem(theme, '', Colors.lightGreen.withValues(alpha: 0.8)),
            const SizedBox(width: 4),
            _buildLegendItem(theme, 'High', Colors.green),
          ],
        ),

        const Spacer(),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
          child: Text(
            '${widget.moods.length} entries',
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(ThemeData theme, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        if (label.isNotEmpty) ...[const SizedBox(height: 2), Text(label, style: theme.textTheme.bodySmall?.copyWith(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)))],
      ],
    );
  }

  Color _getMoodColor(ThemeData theme, double? averageMood) {
    if (averageMood == null) {
      return theme.colorScheme.outline.withValues(alpha: 0.1);
    }

    // Map mood levels (0-4) to colors
    final colors = [
      Colors.red.withValues(alpha: 0.7), // Very bad
      Colors.orange.withValues(alpha: 0.7), // Bad
      Colors.yellow.withValues(alpha: 0.7), // Neutral
      Colors.lightGreen.withValues(alpha: 0.8), // Good
      Colors.green, // Very good
    ];

    final index = averageMood.round().clamp(0, colors.length - 1);
    return colors[index];
  }
}
