import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/category/category_bloc.dart';
import 'package:tazbeet/blocs/category/category_state.dart';
import 'package:tazbeet/ui/controllers/home_screen_controller.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

class HomeCategoryFilter extends StatelessWidget {
  final HomeScreenController controller;
  final Key? listKey;
  const HomeCategoryFilter({super.key, required this.controller, this.listKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoaded && state.categories.isNotEmpty) {
          final selectedCategoryId = controller.selectedCategoryId.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder<bool>(
                valueListenable: controller.showCalendar,
                builder: (context, showCalendar, _) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.filter_list, size: 20, color: Theme.of(context).colorScheme.primary),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.categoryLabel, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        
                        IconButton(
                          icon: Icon(showCalendar ? Icons.calendar_today : Icons.calendar_today_outlined, size: 20),
                          onPressed: controller.toggleCalendar,
                          tooltip: AppLocalizations.of(context)!.calendar,
                          style: IconButton.styleFrom(backgroundColor: showCalendar ? Theme.of(context).colorScheme.primaryContainer : null),
                        ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(
                height: 60,
                child: ListView(
                  key: listKey,
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  children: [
                    _chip(
                      context,
                      id: null,
                      label: AppLocalizations.of(context)!.allCategories,
                      icon: Icons.align_horizontal_left_rounded,
                      color: Theme.of(context).colorScheme.primary,
                      selected: selectedCategoryId == null,
                      onTap: () => controller.setCategory(null),
                    ),
                    ...state.categories.map((c) => _chip(context, id: c.id, label: c.name, icon: Icons.folder, color: c.color, selected: selectedCategoryId == c.id, onTap: () => controller.setCategory(c.id))),
                  ],
                ),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _chip(BuildContext context, {required String? id, required String label, required IconData icon, required Color color, required bool selected, required VoidCallback onTap}) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 4),
            Text(label, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: selected ? Theme.of(context).colorScheme.onPrimaryContainer : Theme.of(context).colorScheme.onSurface)),
          ],
        ),
        selected: selected,
        onSelected: (_) => onTap(),
        backgroundColor: !selected ? color.withValues(alpha: 0.4) : Theme.of(context).colorScheme.surface,
        selectedColor: Theme.of(context).colorScheme.primaryContainer,
        checkmarkColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
    );
  }
}
