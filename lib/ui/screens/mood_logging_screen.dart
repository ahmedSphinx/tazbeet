import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/l10n/generated/app_localizations.dart';
import 'package:uuid/uuid.dart';
import '../../blocs/mood/mood_bloc.dart';
import '../../blocs/mood/mood_event.dart';
import '../../models/mood.dart';

class MoodLoggingScreen extends StatefulWidget {
  const MoodLoggingScreen({super.key});

  @override
  State<MoodLoggingScreen> createState() => _MoodLoggingScreenState();
}

class _MoodLoggingScreenState extends State<MoodLoggingScreen> {
  MoodLevel? _selectedMoodLevel;
  final TextEditingController _noteController = TextEditingController();
  int _energyLevel = 5;
  int _focusLevel = 5;
  int _stressLevel = 5;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _submitMood() {
    if (_selectedMoodLevel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a mood level')),
      );
      return;
    }

    final mood = Mood(
      id: const Uuid().v4(),
      level: _selectedMoodLevel!,
      note: _noteController.text.trim(),
      date: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      energyLevel: _energyLevel,
      focusLevel: _focusLevel,
      stressLevel: _stressLevel,
    );

    context.read<MoodBloc>().add(AddMood(mood));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text(
              AppLocalizations.of(context).howAreYouFeeling,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: MoodLevel.values.map((level) {
                return ChoiceChip(
                  label: Text(_getMoodText(level)),
                  selected: _selectedMoodLevel == level,
                  onSelected: (selected) {
                    setState(() {
                      _selectedMoodLevel = selected ? level : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).notesOptional,

                /* 'Notes (optional)' */
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            _buildSlider(
              AppLocalizations.of(context).energyLevel,
              /* 'Energy Level', */ _energyLevel,
              (value) {
                setState(() {
                  _energyLevel = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),
            _buildSlider(
              AppLocalizations.of(context).focusLevel,
              /* 'Focus Level', */ _focusLevel,
              (value) {
                setState(() {
                  _focusLevel = value.toInt();
                });
              },
            ),
            const SizedBox(height: 16),
            _buildSlider(
              AppLocalizations.of(context).stressLevel,
              /* 'Stress Level', */ _stressLevel,
              (value) {
                setState(() {
                  _stressLevel = value.toInt();
                });
              },
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submitMood,
              child: Text(AppLocalizations.of(context).saveMood),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String label, int value, ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label: $value/10'),
        Slider(
          value: value.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          label: value.toString(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  String _getMoodText(MoodLevel level) {
    switch (level) {
      case MoodLevel.very_bad:
        return AppLocalizations.of(context).veryBad;
      case MoodLevel.bad:
        return AppLocalizations.of(context).bad;
      case MoodLevel.neutral:
        return AppLocalizations.of(context).neutral;
      case MoodLevel.good:
        return AppLocalizations.of(context).good;

      case MoodLevel.very_good:
        return AppLocalizations.of(context).veryGood;
    }
  }
}
