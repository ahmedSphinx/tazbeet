import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tazbeet/blocs/mood/mood_bloc.dart';
import 'package:tazbeet/blocs/mood/mood_event.dart';
import 'package:tazbeet/models/mood.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

class MoodInputScreen extends StatefulWidget {
  const MoodInputScreen({Key? key}) : super(key: key);

  @override
  State<MoodInputScreen> createState() => _MoodInputScreenState();
}

class _MoodInputScreenState extends State<MoodInputScreen> {
  MoodLevel _selectedMood = MoodLevel.neutral;
  int _energyLevel = 5;
  int _focusLevel = 5;
  int _stressLevel = 5;
  final TextEditingController _noteController = TextEditingController();
  bool _isSaving = false;

  final Map<MoodLevel, String> _moodEmojis = {MoodLevel.very_bad: '😢', MoodLevel.bad: '😕', MoodLevel.neutral: '😐', MoodLevel.good: '🙂', MoodLevel.very_good: '😊'};

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _saveMood() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final mood = Mood(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        level: _selectedMood,
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        date: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        energyLevel: _energyLevel,
        focusLevel: _focusLevel,
        stressLevel: _stressLevel,
      );

      context.read<MoodBloc>().add(AddMood(mood));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.moodSavedSuccess)));
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${AppLocalizations.of(context)!.moodSaveFailed}: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final Map<MoodLevel, String> moodLabels = {
      MoodLevel.very_bad: l10n.moodVeryBad,
      MoodLevel.bad: l10n.moodBad,
      MoodLevel.neutral: l10n.moodNeutral,
      MoodLevel.good: l10n.moodGood,
      MoodLevel.very_good: l10n.moodVeryGood,
    };

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.moodCheckInTitle),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveMood,
            child: _isSaving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.save),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.moodHowAreYouFeeling, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 24),

            // Mood Level Selection
            Text(l10n.moodSelectLevel, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: MoodLevel.values.map((mood) => _buildMoodButton(mood, moodLabels[mood]!)).toList()),
            const SizedBox(height: 32),

            // Energy Level
            _buildSliderSection(title: l10n.moodEnergyLevel, value: _energyLevel.toDouble(), onChanged: (value) => setState(() => _energyLevel = value.round()), minLabel: l10n.low, maxLabel: l10n.high),

            // Focus Level
            _buildSliderSection(title: l10n.moodFocusLevel, value: _focusLevel.toDouble(), onChanged: (value) => setState(() => _focusLevel = value.round()), minLabel: l10n.low, maxLabel: l10n.high),

            // Stress Level
            _buildSliderSection(title: l10n.moodStressLevel, value: _stressLevel.toDouble(), onChanged: (value) => setState(() => _stressLevel = value.round()), minLabel: l10n.low, maxLabel: l10n.high),

            const SizedBox(height: 24),

            // Note Field
            TextField(
              controller: _noteController,
              decoration: InputDecoration(labelText: l10n.moodNoteOptional, hintText: l10n.moodNoteHint, border: const OutlineInputBorder()),
              maxLines: 3,
              maxLength: 200,
            ),

            const SizedBox(height: 24),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _isSaving ? null : _saveMood, child: _isSaving ? const CircularProgressIndicator() : Text(l10n.moodSaveButton)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodButton(MoodLevel mood, String label) {
    final isSelected = _selectedMood == mood;

    return GestureDetector(
      onTap: () => setState(() => _selectedMood = mood),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.transparent,
          border: Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300, width: isSelected ? 2 : 1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(_moodEmojis[mood]!, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade600, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliderSection({required String title, required double value, required ValueChanged<double> onChanged, required String minLabel, required String maxLabel}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            Text('${value.round()}', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        Slider(value: value, min: 1, max: 10, divisions: 9, onChanged: onChanged),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(minLabel, style: Theme.of(context).textTheme.bodySmall),
            Text(maxLabel, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
