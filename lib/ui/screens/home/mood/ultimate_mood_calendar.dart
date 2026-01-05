import 'package:flutter/material.dart';
import '../../../../models/mood.dart';
import '../../../../l10n/app_localizations.dart';

/// Ultimate mood calendar with enhanced heatmap and interactions
class UltimateMoodCalendar extends StatefulWidget {
  final List<Mood> moods;
  final Function(DateTime)? onDateSelected;
  final Function(DateTime)? onMonthChanged;

  const UltimateMoodCalendar({super.key, required this.moods, this.onDateSelected, this.onMonthChanged});

  @override
  State<UltimateMoodCalendar> createState() => _UltimateMoodCalendarState();
}

class _UltimateMoodCalendarState extends State<UltimateMoodCalendar> with TickerProviderStateMixin {
  late AnimationController _heatmapController;
  late AnimationController _monthController;
  late Animation<double> _heatmapAnimation;
  late Animation<double> _monthAnimation;

  DateTime _selectedMonth = DateTime.now();
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  @override
  void dispose() {
    _disposeAnimations();
    super.dispose();
  }

  void _initializeAnimations() {
    _heatmapController = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _heatmapAnimation = CurvedAnimation(parent: _heatmapController, curve: Curves.easeOutCubic);

    _monthController = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);
    _monthAnimation = CurvedAnimation(parent: _monthController, curve: Curves.easeInOut);

    _heatmapController.forward();
  }

  void _disposeAnimations() {
    _heatmapController.dispose();
    _monthController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primaryContainer.withOpacity(0.2), theme.colorScheme.secondaryContainer.withOpacity(0.1), theme.colorScheme.surface],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
        boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withOpacity(0.1), blurRadius: 30, offset: const Offset(0, 15))],
      ),
      child: SingleChildScrollView(
        child: Column(
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

            const SizedBox(height: 20),

            // Legend
            _buildLegend(theme),

            const SizedBox(height: 16),

            // Selected date details
            if (_selectedDate != null) _buildSelectedDateDetails(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Previous month
          GestureDetector(
            onTap: _previousMonth,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.chevron_left, color: theme.colorScheme.primary),
            ),
          ),

          // Current month
          AnimatedBuilder(
            animation: _monthAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _monthAnimation.value,
                child: Column(
                  children: [
                    Text(
                      _formatMonth(_selectedMonth),
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    ),
                    Text(_formatYear(_selectedMonth), style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
                  ],
                ),
              );
            },
          ),

          // Next month
          GestureDetector(
            onTap: _nextMonth,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(Icons.chevron_right, color: theme.colorScheme.primary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid(ThemeData theme) {
    final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
    final firstDayOfWeek = DateTime(_selectedMonth.year, _selectedMonth.month, 1).weekday;

    return Column(
      children: [
        // Day headers
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'].map((day) {
            return Container(
              width: 40,
              height: 30,
              alignment: Alignment.center,
              child: Text(
                day,
                style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface.withOpacity(0.6)),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 8),

        // Calendar days
        Column(
          children: List.generate(6, (weekIndex) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (dayIndex) {
                final dayNumber = weekIndex * 7 + dayIndex - firstDayOfWeek + 1;

                if (dayNumber < 1 || dayNumber > daysInMonth) {
                  return const SizedBox(width: 40, height: 40);
                }

                final date = DateTime(_selectedMonth.year, _selectedMonth.month, dayNumber);
                final mood = _getMoodForDate(date);
                final isSelected = _selectedDate != null && _isSameDay(date, _selectedDate!);

                return _buildDayCell(date, mood, isSelected, theme);
              }),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildDayCell(DateTime date, Mood? mood, bool isSelected, ThemeData theme) {
    return GestureDetector(
      onTap: () => _selectDate(date),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: mood != null ? _getMoodColor(mood.level) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: theme.colorScheme.primary, width: 2) : null,
          boxShadow: mood != null ? [BoxShadow(color: _getMoodColor(mood.level).withOpacity(0.3), blurRadius: 4, offset: const Offset(0, 2))] : null,
        ),
        child: Stack(
          children: [
            // Day number
            Center(
              child: Text(
                '${date.day}',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: mood != null ? Colors.white : theme.colorScheme.onSurface),
              ),
            ),

            // Mood emoji
            if (mood != null) Positioned(bottom: 2, right: 2, child: Text(_getMoodEmoji(mood.level), style: const TextStyle(fontSize: 8))),

            // Selection indicator
            if (isSelected)
              Positioned(
                top: 2,
                right: 2,
                child: Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(ThemeData theme) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.moodIntensity,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildLegendItem(l10n.veryBadIntensity, const Color(0xFFFF5252)),
              _buildLegendItem(l10n.badIntensity, const Color(0xFFFF9800)),
              _buildLegendItem(l10n.neutralIntensity, const Color(0xFF9E9E9E)),
              _buildLegendItem(l10n.goodIntensity, const Color(0xFF8BC34A)),
              _buildLegendItem(l10n.veryGoodIntensity, const Color(0xFF4CAF50)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
        ),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildSelectedDateDetails() {
    final l10n = AppLocalizations.of(context)!;
    final mood = _getMoodForDate(_selectedDate!);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatFullDate(_selectedDate!),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
          ),

          if (mood != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Text(_getMoodEmoji(mood.level), style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getMoodText(mood.level),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      if (mood.note != null && mood.note!.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          mood.note!,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ],

          if (mood == null) ...[const SizedBox(height: 12), Text(l10n.noMoodRecorded, style: TextStyle(fontSize: 14, color: Colors.grey.shade600))],
        ],
      ),
    );
  }

  void _previousMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
      _monthController.reset();
      _monthController.forward();
    });
    widget.onMonthChanged?.call(_selectedMonth);
  }

  void _nextMonth() {
    setState(() {
      _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
      _monthController.reset();
      _monthController.forward();
    });
    widget.onMonthChanged?.call(_selectedMonth);
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected?.call(date);
  }

  Mood? _getMoodForDate(DateTime date) {
    try {
      return widget.moods.firstWhere((mood) => _isSameDay(mood.date, date));
    } catch (e) {
      return null;
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  String _formatMonth(DateTime date) {
    const months = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    return months[date.month - 1];
  }

  String _formatYear(DateTime date) {
    return date.year.toString();
  }

  String _formatFullDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  Color _getMoodColor(MoodLevel level) {
    switch (level) {
      case MoodLevel.very_bad:
        return const Color(0xFFFF5252);
      case MoodLevel.bad:
        return const Color(0xFFFF9800);
      case MoodLevel.neutral:
        return const Color(0xFF9E9E9E);
      case MoodLevel.good:
        return const Color(0xFF8BC34A);
      case MoodLevel.very_good:
        return const Color(0xFF4CAF50);
    }
  }

  String _getMoodEmoji(MoodLevel level) {
    switch (level) {
      case MoodLevel.very_bad:
        return '😢';
      case MoodLevel.bad:
        return '😔';
      case MoodLevel.neutral:
        return '😐';
      case MoodLevel.good:
        return '🙂';
      case MoodLevel.very_good:
        return '😊';
    }
  }

  String _getMoodText(MoodLevel level) {
    switch (level) {
      case MoodLevel.very_bad:
        return 'Really struggling';
      case MoodLevel.bad:
        return 'Not great';
      case MoodLevel.neutral:
        return 'Okay';
      case MoodLevel.good:
        return 'Pretty good';
      case MoodLevel.very_good:
        return 'Great';
    }
  }
}
