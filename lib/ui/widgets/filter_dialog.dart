import 'package:flutter/material.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';

class FilterDialog extends StatefulWidget {
  final TaskPriority? initialPriority;
  final bool? initialCompleted;
  final Function(TaskPriority?) onPriorityChanged;
  final Function(bool?) onCompletedChanged;
  final VoidCallback onClear;

  const FilterDialog({
    super.key,
    this.initialPriority,
    this.initialCompleted,
    required this.onPriorityChanged,
    required this.onCompletedChanged,
    required this.onClear,
  });

  @override
  State<FilterDialog> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  TaskPriority? _selectedPriority;
  bool? _selectedCompleted;

  @override
  void initState() {
    super.initState();
    _selectedPriority = widget.initialPriority;
    _selectedCompleted = widget.initialCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Wrap(
        children: [
          ListTile(
            title: Text(
              AppLocalizations.of(context)!.filterTasksTitle,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.priorityLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.allLabel),
                      selected: _selectedPriority == null,
                      onSelected: (selected) {
                        setState(() => _selectedPriority = null);
                        widget.onPriorityChanged(null);
                      },
                    ),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.highPriorityLabel),
                      selected: _selectedPriority == TaskPriority.high,
                      onSelected: (selected) {
                        setState(() => _selectedPriority = TaskPriority.high);
                        widget.onPriorityChanged(TaskPriority.high);
                      },
                    ),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.mediumPriorityLabel),
                      selected: _selectedPriority == TaskPriority.medium,
                      onSelected: (selected) {
                        setState(() => _selectedPriority = TaskPriority.medium);
                        widget.onPriorityChanged(TaskPriority.medium);
                      },
                    ),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.lowPriorityLabel),
                      selected: _selectedPriority == TaskPriority.low,
                      onSelected: (selected) {
                        setState(() => _selectedPriority = TaskPriority.low);
                        widget.onPriorityChanged(TaskPriority.low);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.statusLabel,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.allLabel),
                      selected: _selectedCompleted == null,
                      onSelected: (selected) {
                        setState(() => _selectedCompleted = null);
                        widget.onCompletedChanged(null);
                      },
                    ),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.incompleteLabel),
                      selected: _selectedCompleted == false,
                      onSelected: (selected) {
                        setState(() => _selectedCompleted = false);
                        widget.onCompletedChanged(false);
                      },
                    ),
                    ChoiceChip(
                      label: Text(AppLocalizations.of(context)!.completedLabel),
                      selected: _selectedCompleted == true,
                      onSelected: (selected) {
                        setState(() => _selectedCompleted = true);
                        widget.onCompletedChanged(true);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          OverflowBar(
            alignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.cancelButton),
              ),
              TextButton(
                onPressed: () {
                  widget.onClear();
                  setState(() {
                    _selectedPriority = null;
                    _selectedCompleted = null;
                  });
                },
                child: Text(AppLocalizations.of(context)!.clearAllButton),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.applyButton),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
