import 'package:flutter/material.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import '../../models/repeat_rule.dart';

class RepeatConfigWidget extends StatefulWidget {
  final RepeatRule? initialRepeatRule;
  final Function(RepeatRule?) onRepeatRuleChanged;

  const RepeatConfigWidget({Key? key, this.initialRepeatRule, required this.onRepeatRuleChanged}) : super(key: key);

  @override
  State<RepeatConfigWidget> createState() => _RepeatConfigWidgetState();
}

class _RepeatConfigWidgetState extends State<RepeatConfigWidget> {
  late RepeatFrequency _frequency;
  late RepeatType _repeatType;
  late List<int> _daysOfWeek;
  DateTime? _endDate;
  int? _repeatCount;
  bool _includeTime = false;

  @override
  void initState() {
    super.initState();
    _frequency = widget.initialRepeatRule?.frequency ?? RepeatFrequency.weekly;
    _repeatType = widget.initialRepeatRule?.repeatType ?? RepeatType.forever;
    _daysOfWeek = widget.initialRepeatRule?.daysOfWeek ?? [];
    _endDate = widget.initialRepeatRule?.endDate;
    _repeatCount = widget.initialRepeatRule?.repeatCount;
    _includeTime = widget.initialRepeatRule?.includeTime ?? false;
  }

  void _updateRepeatRule() {
    if (_frequency == RepeatFrequency.weekly && _daysOfWeek.isEmpty) {
      // Default to current day if no days selected
      _daysOfWeek = [DateTime.now().weekday % 7];
    }

    final repeatRule = RepeatRule(frequency: _frequency, repeatType: _repeatType, daysOfWeek: _daysOfWeek, endDate: _endDate, repeatCount: _repeatCount, startDate: DateTime.now(), includeTime: _includeTime);

    widget.onRepeatRuleChanged(repeatRule);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Repeat Settings', style: theme.textTheme.titleMedium),
        const SizedBox(height: 16),

        // Frequency Selection
        DropdownButtonFormField<RepeatFrequency>(
          value: _frequency,
          decoration: const InputDecoration(labelText: 'Frequency', border: OutlineInputBorder()),
          items: RepeatFrequency.values.map((frequency) {
            String label;
            switch (frequency) {
              case RepeatFrequency.weekly:
                label = 'Weekly';
                break;
              case RepeatFrequency.biweekly:
                label = 'Bi-weekly';
                break;
              case RepeatFrequency.monthly:
                label = 'Monthly';
                break;
            }
            return DropdownMenuItem(value: frequency, child: Text(label));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _frequency = value!;
              _updateRepeatRule();
            });
          },
        ),

        const SizedBox(height: 16),

        // Days of Week Selection (for weekly frequency)
        if (_frequency == RepeatFrequency.weekly) ...[
          Text('Repeat on:', style: theme.textTheme.bodyMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: List.generate(7, (index) {
              final dayNames = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
              final isSelected = _daysOfWeek.contains(index);

              return FilterChip(
                label: Text(dayNames[index]),
                selected: isSelected,
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _daysOfWeek.add(index);
                    } else {
                      _daysOfWeek.remove(index);
                    }
                    _updateRepeatRule();
                  });
                },
              );
            }),
          ),
          const SizedBox(height: 16),
        ],

        // Repeat Type Selection
        DropdownButtonFormField<RepeatType>(
          value: _repeatType,
          decoration: const InputDecoration(labelText: 'Repeat Type', border: OutlineInputBorder()),
          items: RepeatType.values.map((repeatType) {
            String label;
            switch (repeatType) {
              case RepeatType.forever:
                label = 'Forever';
                break;
              case RepeatType.untilDate:
                label = 'Until Date';
                break;
              case RepeatType.count:
                label = 'Number of Times';
                break;
            }
            return DropdownMenuItem(value: repeatType, child: Text(label));
          }).toList(),
          onChanged: (value) {
            setState(() {
              _repeatType = value!;
              _updateRepeatRule();
            });
          },
        ),

        const SizedBox(height: 16),

        // End Date Selection (for untilDate type)
        if (_repeatType == RepeatType.untilDate) ...[
          Row(
            children: [
              Expanded(child: Text(_endDate == null ? 'No end date selected' : 'Ends on: ${_endDate!.toString().split(' ')[0]}')),
              TextButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _endDate ?? DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                  );
                  if (picked != null) {
                    setState(() {
                      _endDate = picked;
                      _updateRepeatRule();
                    });
                  }
                },
                child: Text(_endDate == null ? 'Select Date' : 'Change'),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],

        // Repeat Count Selection (for count type)
        if (_repeatType == RepeatType.count) ...[
          TextFormField(
            initialValue: _repeatCount?.toString() ?? '',
            decoration: const InputDecoration(labelText: 'Number of times', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                _repeatCount = int.tryParse(value);
                _updateRepeatRule();
              });
            },
          ),
          const SizedBox(height: 16),
        ],

        // Include Time Option
        SwitchListTile(
          title: const Text('Include specific time'),
          subtitle: const Text('Repeat at the same time each day'),
          value: _includeTime,
          onChanged: (value) {
            setState(() {
              _includeTime = value;
              _updateRepeatRule();
            });
          },
        ),

        const SizedBox(height: 16),

        // Preview
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Preview:', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(_getRepeatRuleDescription(), style: theme.textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  String _getRepeatRuleDescription() {
    final repeatRule = RepeatRule(frequency: _frequency, repeatType: _repeatType, daysOfWeek: _daysOfWeek, endDate: _endDate, repeatCount: _repeatCount, startDate: DateTime.now(), includeTime: _includeTime);

    return repeatRule.getDisplayText();
  }
}
