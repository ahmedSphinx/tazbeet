import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/ui/controllers/home_screen_controller.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/ui/design_system/ds_spacing.dart';
import 'package:tazbeet/blocs/category/category_bloc.dart';
import 'package:tazbeet/blocs/category/category_state.dart';

/// Optimized filter chips widget that reduces rebuilds
class OptimizedFilterChips extends StatelessWidget {
  final HomeScreenController controller;
  final VoidCallback? onShowCalendar;

  const OptimizedFilterChips({super.key, required this.controller, this.onShowCalendar});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([controller.selectedDate, controller.selectedCategoryId, controller.showOverdueOnly, controller.showUndatedOnly, controller.showCalendar]),
      builder: (context, _) {
        final selectedDate = controller.selectedDate.value;
        final selectedCategoryId = controller.selectedCategoryId.value;
        final showOverdueOnly = controller.showOverdueOnly.value;
        final showUndatedOnly = controller.showUndatedOnly.value;
        final showCalendar = controller.showCalendar.value;

        final hasFilters = selectedDate != null || selectedCategoryId != null || showOverdueOnly || showUndatedOnly;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Calendar toggle button
              if (!showCalendar && onShowCalendar != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onShowCalendar,
                    icon: const Icon(Icons.calendar_month_rounded, size: 20),
                    label: Text(AppLocalizations.of(context)!.showCalendar, style: const TextStyle(fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.sm),
                      elevation: 2,
                    ),
                  ),
                ),

              if (!showCalendar && hasFilters) const SizedBox(height: DSSpacing.sm),

              // Active filter chips
              if (hasFilters) ...[
                Wrap(
                  spacing: DSSpacing.sm,
                  children: [
                    if (showOverdueOnly)
                      Chip(
                        avatar: const Icon(Icons.warning_amber_rounded, size: 16),
                        label: Text(AppLocalizations.of(context)!.overdue),
                        onDeleted: () {
                          controller.clearSpecialFilters();
                        },
                        deleteIcon: const Icon(Icons.close, size: 18),
                      ),
                    if (showUndatedOnly)
                      Chip(
                        avatar: const Icon(Icons.event_busy_rounded, size: 16),
                        label: Text(AppLocalizations.of(context)!.noDueDate),
                        onDeleted: () {
                          controller.clearSpecialFilters();
                        },
                        deleteIcon: const Icon(Icons.close, size: 18),
                      ),
                    if (selectedDate != null)
                      Chip(
                        avatar: const Icon(Icons.calendar_today, size: 16),
                        label: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                        onDeleted: () {
                          controller.clearDate();
                        },
                        deleteIcon: const Icon(Icons.close, size: 18),
                      ),
                    if (selectedCategoryId != null)
                      Builder(
                        builder: (context) {
                          return BlocBuilder<CategoryBloc, CategoryState>(
                            builder: (context, state) {
                              if (state is! CategoryLoaded || state.categories.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              final category = state.categories.firstWhere((c) => c.id == selectedCategoryId, orElse: () => state.categories.first);
                              return Chip(label: Text(category.name), avatar: const Icon(Icons.folder, size: 16), onDeleted: () => controller.setCategory(null), deleteIcon: const Icon(Icons.close, size: 18));
                            },
                          );
                        },
                      ),
                  ],
                ),
                const SizedBox(height: DSSpacing.sm),

                // Clear all filters button
                TextButton.icon(
                  onPressed: controller.clearAllFilters,
                  icon: const Icon(Icons.clear_all, size: 18),
                  label: Text(AppLocalizations.of(context)!.clearAllButton),
                  style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
