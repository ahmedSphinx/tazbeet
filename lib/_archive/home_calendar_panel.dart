import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_state.dart';
import 'package:tazbeet/blocs/category/category_bloc.dart';
import 'package:tazbeet/blocs/category/category_state.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/ui/controllers/home_screen_controller.dart';
import 'package:tazbeet/ui/widgets/calendar_section.dart';

class HomeCalendarPanel extends StatefulWidget {
  final HomeScreenController controller;
  final void Function(DateTime date, List<Task> dayTasks)? onDayLongPress;
  final void Function(Task task, DateTime newDate)? onTaskReschedule;
  const HomeCalendarPanel({super.key, required this.controller, this.onDayLongPress, this.onTaskReschedule});

  @override
  State<HomeCalendarPanel> createState() => _HomeCalendarPanelState();
}

class _HomeCalendarPanelState extends State<HomeCalendarPanel> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<TaskListBloc, TaskListState>(
      builder: (context, state) {
        if (state is! TaskListLoaded) return const SizedBox.shrink();
        return BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, categoryState) {
            final categoryColors = <String, Color>{};
            if (categoryState is CategoryLoaded) {
              for (var category in categoryState.categories) {
                categoryColors[category.id] = category.color;
              }
            }

            // Filter by selected category
            final selectedCategoryId = widget.controller.selectedCategoryId.value;
            List<Task> calendarTasks = state.tasks;
            if (selectedCategoryId != null) {
              calendarTasks = state.tasks.where((t) => t.categoryId == selectedCategoryId).toList();
            }

            return CalendarSection(
              tasks: calendarTasks,
              categoryIdToColor: categoryColors,
              onDateSelected: (date) => widget.controller.setDate(date),
              onDayLongPress: widget.onDayLongPress,
              onTaskReschedule: widget.onTaskReschedule,
            );
          },
        );
      },
    );
  }
}
