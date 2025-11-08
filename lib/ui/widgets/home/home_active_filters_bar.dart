import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/category/category_bloc.dart';
import 'package:tazbeet/blocs/category/category_state.dart';
import 'package:tazbeet/ui/controllers/home_screen_controller.dart';

class HomeActiveFiltersBar extends StatelessWidget {
  final HomeScreenController controller;
  const HomeActiveFiltersBar({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<DateTime?>(
      valueListenable: controller.selectedDate,
      builder: (context, date, _) {
        return ValueListenableBuilder<String?>(
          valueListenable: controller.selectedCategoryId,
          builder: (context, categoryId, __) {
            if (date == null && categoryId == null) return const SizedBox.shrink();
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (date != null)
                    Chip(
                      avatar: const Icon(Icons.calendar_today, size: 16),
                      label: Text(intl.DateFormat.yMMMd(Localizations.localeOf(context).toString()).format(date)),
                      onDeleted: controller.clearDate,
                      deleteIcon: const Icon(Icons.close, size: 18),
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      side: BorderSide.none,
                    ),
                  if (categoryId != null)
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state is! CategoryLoaded) return const SizedBox.shrink();
                        final category = state.categories.firstWhere((c) => c.id == categoryId, orElse: () => state.categories.first);
                        return Chip(
                          avatar: CircleAvatar(backgroundColor: category.color, radius: 8),
                          label: Text(category.name),
                          onDeleted: () => controller.setCategory(null),
                          deleteIcon: const Icon(Icons.close, size: 18),
                          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                          side: BorderSide.none,
                        );
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
