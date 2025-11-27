import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:tazbeet/blocs/category/category_bloc.dart';
import 'package:tazbeet/blocs/category/category_state.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/ui/controllers/home_screen_controller.dart';

/// Displays active date and category filters as dismissible chips
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
            final hasFilters = date != null || categoryId != null;

            return AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, animation) => SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, -0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                )),
                child: FadeTransition(opacity: animation, child: child),
              ),
              child: hasFilters
                  ? _buildFiltersRow(context, date, categoryId)
                  : const SizedBox.shrink(key: ValueKey('empty')),
            );
          },
        );
      },
    );
  }

  Widget _buildFiltersRow(
    BuildContext context,
    DateTime? date,
    String? categoryId,
  ) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final hasMultipleFilters = date != null && categoryId != null;

    return Container(
      key: const ValueKey('filters'),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          // Filter icon
          Icon(
            Icons.filter_alt_outlined,
            size: 18,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(width: 8),

          // Filter chips
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (date != null) _DateFilterChip(date: date, onDelete: controller.clearDate),
                if (categoryId != null) _CategoryFilterChip(
                  categoryId: categoryId,
                  onDelete: () => controller.setCategory(null),
                ),
              ],
            ),
          ),

          // Clear all button (only show if multiple filters)
          if (hasMultipleFilters)
            TextButton.icon(
              onPressed: () {
                controller.clearDate();
                controller.setCategory(null);
              },
              icon: const Icon(Icons.clear_all, size: 18),
              label: Text(l10n.clearAllButton),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                visualDensity: VisualDensity.compact,
              ),
            ),
        ],
      ),
    );
  }
}

/// Chip displaying the selected date filter
class _DateFilterChip extends StatelessWidget {
  final DateTime date;
  final VoidCallback onDelete;

  const _DateFilterChip({required this.date, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).toString();

    return Chip(
      avatar: Icon(
        Icons.calendar_today,
        size: 16,
        color: theme.colorScheme.onPrimaryContainer,
      ),
      label: Text(
        intl.DateFormat.yMMMd(locale).format(date),
        style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
      ),
      onDeleted: onDelete,
      deleteIcon: Icon(
        Icons.close,
        size: 16,
        color: theme.colorScheme.onPrimaryContainer,
      ),
      backgroundColor: theme.colorScheme.primaryContainer,
      side: BorderSide.none,
      padding: const EdgeInsets.symmetric(horizontal: 4),
      visualDensity: VisualDensity.compact,
    );
  }
}

/// Chip displaying the selected category filter
class _CategoryFilterChip extends StatelessWidget {
  final String categoryId;
  final VoidCallback onDelete;

  const _CategoryFilterChip({required this.categoryId, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is! CategoryLoaded) return const SizedBox.shrink();

        final category = state.categories.firstWhere(
          (c) => c.id == categoryId,
          orElse: () => state.categories.first,
        );

        return Chip(
          avatar: CircleAvatar(
            backgroundColor: category.color,
            radius: 8,
          ),
          label: Text(
            category.name,
            style: TextStyle(color: theme.colorScheme.onSecondaryContainer),
          ),
          onDeleted: onDelete,
          deleteIcon: Icon(
            Icons.close,
            size: 16,
            color: theme.colorScheme.onSecondaryContainer,
          ),
          backgroundColor: theme.colorScheme.secondaryContainer,
          side: BorderSide.none,
          padding: const EdgeInsets.symmetric(horizontal: 4),
          visualDensity: VisualDensity.compact,
        );
      },
    );
  }
}
