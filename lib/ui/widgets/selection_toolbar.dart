import 'package:flutter/material.dart';
import 'package:tazbeet/ui/design_system/ds_spacing.dart';
import '../design_system/ds_elevation.dart';
import '../../l10n/app_localizations.dart';
import '../design_system/ds_typography.dart';
import '../design_system/ds_border_radius.dart';

class SelectionToolbar extends StatelessWidget {
  final int selectedCount;
  final VoidCallback onClearSelection;
  final VoidCallback onCompleteSelected;
  final VoidCallback onRescheduleSelected;
  final VoidCallback onSetCategorySelected;
  final VoidCallback onSetPrioritySelected;
  final VoidCallback onDeleteSelected;

  const SelectionToolbar({super.key, required this.selectedCount, required this.onClearSelection, required this.onCompleteSelected, required this.onRescheduleSelected, required this.onSetCategorySelected, required this.onSetPrioritySelected, required this.onDeleteSelected});

  @override
  Widget build(BuildContext context) {
    if (selectedCount == 0) return const SizedBox.shrink();

    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.sm),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: DSElevation.getBoxShadow(context, DSElevation.level3),
          border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1))),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppLocalizations.of(context)!.itemsSelected(selectedCount), style: DSTypography.body(context).copyWith(fontWeight: FontWeight.bold)),
                TextButton(onPressed: onClearSelection, child: Text(AppLocalizations.of(context)!.clear)),
              ],
            ),
            const SizedBox(height: DSSpacing.sm),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _ToolbarAction(icon: Icons.check_circle_outline, label: AppLocalizations.of(context)!.complete, onTap: onCompleteSelected),
                  const SizedBox(width: DSSpacing.md),
                  _ToolbarAction(icon: Icons.calendar_today_outlined, label: AppLocalizations.of(context)!.reschedule, onTap: onRescheduleSelected),
                  const SizedBox(width: DSSpacing.md),
                  _ToolbarAction(icon: Icons.category_outlined, label: AppLocalizations.of(context)!.category, onTap: onSetCategorySelected),
                  const SizedBox(width: DSSpacing.md),
                  _ToolbarAction(icon: Icons.priority_high_outlined, label: AppLocalizations.of(context)!.priority, onTap: onSetPrioritySelected),
                  const SizedBox(width: DSSpacing.md),
                  _ToolbarAction(icon: Icons.delete_outline, label: AppLocalizations.of(context)!.delete, onTap: onDeleteSelected, color: Theme.of(context).colorScheme.error),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ToolbarAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ToolbarAction({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(DSBorderRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: DSSpacing.md, vertical: DSSpacing.sm),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color ?? Theme.of(context).colorScheme.primary),
            const SizedBox(height: 4),
            Text(label, style: DSTypography.caption(context).copyWith(color: color ?? Theme.of(context).colorScheme.onSurface)),
          ],
        ),
      ),
    );
  }
}
