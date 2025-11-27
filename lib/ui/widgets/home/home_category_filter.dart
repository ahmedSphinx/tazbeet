import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/category/category_bloc.dart';
import 'package:tazbeet/blocs/category/category_state.dart';
import 'package:tazbeet/ui/controllers/home_screen_controller.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/ui/design_system/ds_spacing.dart';
import 'package:tazbeet/ui/design_system/ds_typography.dart';

/// Horizontal scrollable category filter with calendar toggle
class HomeCategoryFilter extends StatelessWidget {
  final HomeScreenController controller;
  final Key? listKey;

  const HomeCategoryFilter({super.key, required this.controller, this.listKey});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        // Loading state
        if (state is CategoryLoading) {
          return _buildLoadingState(context);
        }

        // Loaded state with categories
        if (state is CategoryLoaded && state.categories.isNotEmpty) {
          return ValueListenableBuilder<String?>(
            valueListenable: controller.selectedCategoryId,
            builder: (context, selectedCategoryId, _) {
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [_buildHeader(context), _buildCategoryChips(context, state, selectedCategoryId)]);
            },
          );
        }

        // Empty state - just show header with calendar toggle
        return _buildHeader(context);
      },
    );
  }

  /// Loading shimmer placeholder
  Widget _buildLoadingState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: List.generate(
          3,
          (index) => Expanded(
            child: Container(
              height: 36,
              margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(18)),
            ),
          ),
        ),
      ),
    );
  }

  /// Header with filter label and calendar toggle
  Widget _buildHeader(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ValueListenableBuilder<bool>(
      valueListenable: controller.showCalendar,
      builder: (context, showCalendar, _) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(DSSpacing.md, DSSpacing.md, DSSpacing.sm, DSSpacing.sm),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.filter_list, size: 18, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: DSSpacing.sm),
                  Text(
                    l10n.categoryLabel,
                    style: DSTypography.label(context).copyWith(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.onSurface),
                  ),
                ],
              ),
              IconButton(
                icon: Icon(showCalendar ? Icons.calendar_month : Icons.calendar_today_outlined, size: 20),
                onPressed: controller.toggleCalendar,
                tooltip: l10n.calendar,
                style: IconButton.styleFrom(backgroundColor: showCalendar ? Theme.of(context).colorScheme.primaryContainer : null, padding: const EdgeInsets.all(DSSpacing.sm)),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Horizontal scrollable category chips
  Widget _buildCategoryChips(BuildContext context, CategoryLoaded state, String? selectedCategoryId) {
    final l10n = AppLocalizations.of(context)!;
    return SizedBox(
      height: 56,
      child: ListView(
        key: listKey,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.sm),
        children: [
          // "All" chip
          _CategoryChip(id: null, label: l10n.allCategories, icon: Icons.apps_rounded, color: Theme.of(context).colorScheme.primary, isSelected: selectedCategoryId == null, onTap: () => controller.setCategory(null)),
          // Category chips
          ...state.categories.map((c) => _CategoryChip(id: c.id, label: c.name, icon: Icons.folder_rounded, color: c.color, isSelected: selectedCategoryId == c.id, onTap: () => controller.setCategory(c.id))),
        ],
      ),
    );
  }
}

/// Individual category chip with animation
class _CategoryChip extends StatelessWidget {
  final String? id;
  final String label;
  final IconData icon;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({required this.id, required this.label, required this.icon, required this.color, required this.isSelected, required this.onTap});

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
