import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';
import 'package:intl/intl.dart' as intl;

/// A calendar widget that displays tasks with category colors,
/// supports Arabic/RTL, and provides rich interaction options.
class CalendarSection extends StatefulWidget {
  final List<Task> tasks;
  final Map<String, Color> categoryIdToColor;
  final Function(DateTime date) onDateSelected;
  final Function(DateTime date, List<Task> dayTasks)? onDayLongPress;
  final Function(Task task, DateTime newDate)? onTaskReschedule;
  final CalendarView initialView;

  const CalendarSection({super.key, required this.tasks, required this.categoryIdToColor, required this.onDateSelected, this.onDayLongPress, this.onTaskReschedule, this.initialView = CalendarView.month});

  @override
  State<CalendarSection> createState() => _CalendarSectionState();
}

class _CalendarSectionState extends State<CalendarSection> {
  late CalendarView _calendarView;
  final CalendarController _calendarController = CalendarController();

  @override
  void initState() {
    super.initState();
    _calendarView = widget.initialView;
  }

  @override
  void dispose() {
    _calendarController.dispose();
    super.dispose();
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red.shade400;
      case TaskPriority.medium:
        return Colors.orange.shade300;
      case TaskPriority.low:
        return Colors.blue.shade300;
    }
  }

  List<Task> _getTasksForDate(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    final end = start.add(const Duration(days: 1));
    return widget.tasks.where((task) {
      if (task.dueDate == null) return false;
      return !task.dueDate!.isBefore(start) && task.dueDate!.isBefore(end);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final locale = Localizations.localeOf(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Header with title and view toggle
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Icon(Icons.calendar_month, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(l10n.calendar, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                SegmentedButton<CalendarView>(
                  segments: [
                    ButtonSegment(value: CalendarView.month, label: Text(l10n.monthView), icon: const Icon(Icons.calendar_view_month, size: 16)),
                    ButtonSegment(value: CalendarView.week, label: Text(l10n.weekView), icon: const Icon(Icons.calendar_view_week, size: 16)),
                  ],
                  selected: {_calendarView},
                  onSelectionChanged: (Set<CalendarView> selection) {
                    setState(() {
                      _calendarView = selection.first;
                    });
                  },
                  style: ButtonStyle(visualDensity: VisualDensity.compact),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Calendar
          SizedBox(
            height: _calendarView == CalendarView.month ? 350 : 250,
            child: SfCalendar(
              view: _calendarView,
              controller: _calendarController,
              firstDayOfWeek: isRTL ? 6 : 7, // Saturday for RTL (Arabic), Sunday for LTR
              dataSource: TaskCalendarDataSource(widget.tasks, widget.categoryIdToColor, _getPriorityColor),
              monthViewSettings: MonthViewSettings(
                appointmentDisplayMode: MonthAppointmentDisplayMode.indicator,
                showAgenda: false,
                monthCellStyle: MonthCellStyle(
                  textStyle: Theme.of(context).textTheme.bodySmall,
                  trailingDatesTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade400),
                  leadingDatesTextStyle: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade400),
                ),
                agendaStyle: AgendaStyle(appointmentTextStyle: Theme.of(context).textTheme.bodyMedium, dateTextStyle: Theme.of(context).textTheme.titleSmall),
              ),
              timeSlotViewSettings: TimeSlotViewSettings(dateFormat: isRTL ? 'd' : 'd', dayFormat: isRTL ? 'EEE' : 'EEE'),
              headerStyle: CalendarHeaderStyle(textStyle: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              todayHighlightColor: Theme.of(context).colorScheme.primary,
              selectionDecoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.amberAccent, width: 2),
                borderRadius: BorderRadius.circular(8),
                //   shape: BoxShape.circle,
              ),
              // Tap to select date
              onTap: (CalendarTapDetails details) {
                if (details.targetElement == CalendarElement.calendarCell) {
                  if (details.date != null) {
                    widget.onDateSelected(details.date!);
                  }
                }
              },
              // Long press to show day bottom sheet
              onLongPress: (CalendarLongPressDetails details) {
                if (details.targetElement == CalendarElement.calendarCell) {
                  if (details.date != null && widget.onDayLongPress != null) {
                    final dayTasks = _getTasksForDate(details.date!);
                    widget.onDayLongPress!(details.date!, dayTasks);
                  }
                }
              },

              // Drag-and-drop reschedule
              allowDragAndDrop: widget.onTaskReschedule != null,
              onDragEnd: (AppointmentDragEndDetails details) {
                if (widget.onTaskReschedule != null && details.appointment != null) {
                  final appointment = details.appointment as Appointment;
                  final taskId = appointment.id as String;
                  final task = widget.tasks.firstWhere((t) => t.id == taskId);
                  final newDate = details.droppingTime!;
                  widget.onTaskReschedule!(task, newDate);
                }
              },
              // Month cell builder for badges
              monthCellBuilder: (BuildContext context, MonthCellDetails details) {
                final dayTasks = _getTasksForDate(details.date);
                final isToday = _isToday(details.date);
                final isOverdue = _hasOverdueTasks(dayTasks);

                return Container(
                  decoration: BoxDecoration(
                    color: details.date.month != details.visibleDates[details.visibleDates.length ~/ 2].month ? Colors.grey.shade100.withValues(alpha: 0.3) : null,
                    border: isOverdue ? Border.all(color: Colors.red.shade300, width: 1.5) : (isToday ? Border.all(color: Theme.of(context).colorScheme.primary, width: 1.5) : null),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      // Date number
                      Align(
                        alignment: isRTL ? Alignment.topLeft : Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            _formatDayNumber(details.date, locale),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: isToday ? FontWeight.bold : FontWeight.normal, color: isToday ? Theme.of(context).colorScheme.primary : null),
                          ),
                        ),
                      ),
                      // Badge for task count
                      if (dayTasks.isNotEmpty)
                        Align(
                          alignment: isRTL ? Alignment.bottomRight : Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(4),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: _getDominantColor(dayTasks), borderRadius: BorderRadius.circular(16)),
                              child: Text(
                                '${dayTasks.length}',
                                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                semanticsLabel: l10n.tasksDue(dayTasks.length),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  bool _hasOverdueTasks(List<Task> tasks) {
    final now = DateTime.now();
    return tasks.any((task) => !task.isCompleted && task.dueDate != null && task.dueDate!.isBefore(now));
  }

  Color _getDominantColor(List<Task> tasks) {
    if (tasks.isEmpty) return Colors.grey;
    // Use the color of the highest priority incomplete task
    final incompleteTasks = tasks.where((t) => !t.isCompleted).toList();
    if (incompleteTasks.isEmpty) return Colors.green.shade600;

    final highPriority = incompleteTasks.any((t) => t.priority == TaskPriority.high);
    if (highPriority) return Colors.red.shade700;

    final mediumPriority = incompleteTasks.any((t) => t.priority == TaskPriority.medium);
    if (mediumPriority) return Colors.orange.shade600;

    return Colors.blue.shade600;
  }

  String _formatDayNumber(DateTime date, Locale locale) {
    // Format day number respecting locale (Arabic numerals for ar)
    final formatter = intl.NumberFormat.decimalPattern(locale.toString());
    return formatter.format(date.day);
  }
}

/// Data source adapter for Syncfusion Calendar
class TaskCalendarDataSource extends CalendarDataSource {
  TaskCalendarDataSource(List<Task> tasks, Map<String, Color> categoryIdToColor, Color Function(TaskPriority) getPriorityColor) {
    appointments = tasks.where((task) => task.dueDate != null).map((task) {
      Color color;
      if (task.categoryId != null && categoryIdToColor.containsKey(task.categoryId)) {
        color = categoryIdToColor[task.categoryId]!;
      } else {
        color = getPriorityColor(task.priority);
      }

      return Appointment(
        startTime: task.dueDate!,
        endTime: task.dueDate!.add(const Duration(hours: 1)),
        subject: task.title,
        color: task.isCompleted ? Colors.green.shade600 : color,
        id: task.id,
        isAllDay: true,
        notes: task.description ?? '',
      );
    }).toList();
  }
}
