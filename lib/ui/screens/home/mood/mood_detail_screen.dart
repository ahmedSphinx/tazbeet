import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../blocs/mood/mood_bloc.dart';
import '../../../../blocs/mood/mood_event.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/mood.dart';

/// Simple mood detail screen for adding/editing moods
class MoodDetailScreen extends StatefulWidget {
  final Mood? mood; // null for new mood

  const MoodDetailScreen({super.key, this.mood});

  @override
  State<MoodDetailScreen> createState() => _MoodDetailScreenState();
}

class _MoodDetailScreenState extends State<MoodDetailScreen> {
  MoodLevel _selectedMood = MoodLevel.neutral;
  final TextEditingController _noteController = TextEditingController();
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.mood != null) {
      _selectedMood = widget.mood!.level;
      _noteController.text = widget.mood!.note ?? '';
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.mood == null ? l10n.howAreYouFeeling : l10n.yourMoodInsights,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question
                  Text(
                    l10n.howAreYouFeeling,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.tapToLogMood, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                  const SizedBox(height: 32),

                  // Mood options
                  _buildMoodOptions(),

                  const SizedBox(height: 32),

                  // Note section
                  Text(
                    l10n.moodNoteOptional,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _noteController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: l10n.moodNoteHint,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.blue.shade400),
                      ),
                      fillColor: Colors.grey.shade50,
                      filled: true,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Save button
          Container(
            padding: const EdgeInsets.all(20),
            child: SafeArea(
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _saveMood,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: _isSaving ? const CircularProgressIndicator(color: Colors.white) : Text(l10n.save, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoodOptions() {
    final l10n = AppLocalizations.of(context)!;
    final options = [
      {'emoji': '😢', 'text': l10n.veryBad, 'level': MoodLevel.very_bad},
      {'emoji': '😔', 'text': l10n.bad, 'level': MoodLevel.bad},
      {'emoji': '😐', 'text': l10n.neutral, 'level': MoodLevel.neutral},
      {'emoji': '🙂', 'text': l10n.good, 'level': MoodLevel.good},
      {'emoji': '😊', 'text': l10n.veryGood, 'level': MoodLevel.very_good},
    ];

    return Column(
      children: options.map((option) {
        final level = option['level'] as MoodLevel;
        final isSelected = _selectedMood == level;

        return GestureDetector(
          onTap: () {
            HapticFeedback.lightImpact();
            setState(() => _selectedMood = level);
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade50 : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isSelected ? Colors.blue.shade400 : Colors.grey.shade200, width: isSelected ? 2 : 1),
            ),
            child: Row(
              children: [
                Text(option['emoji'] as String, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Text(
                  option['text'] as String,
                  style: TextStyle(fontSize: 16, fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500, color: isSelected ? Colors.blue.shade700 : Colors.black87),
                ),
                const Spacer(),
                if (isSelected) Icon(Icons.check_circle, color: Colors.blue.shade400, size: 24),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _saveMood() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isSaving = true);

    HapticFeedback.mediumImpact();

    try {
      final now = DateTime.now();
      final mood = Mood(
        id: widget.mood?.id ?? '${now.millisecondsSinceEpoch}',
        level: _selectedMood,
        note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
        date: widget.mood?.date ?? now,
        createdAt: widget.mood?.createdAt ?? now,
        updatedAt: now,
        energyLevel: 5, // Default values
        focusLevel: 5,
        stressLevel: 5,
      );

      if (widget.mood == null) {
        context.read<MoodBloc>().add(AddMood(mood));
      } else {
        context.read<MoodBloc>().add(UpdateMood(mood));
      }

      if (mounted) {
        Navigator.of(context).pop();

        // Show simple feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.mood == null ? l10n.moodSaved : 'Mood updated'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Something went wrong'), backgroundColor: Colors.red.shade400));
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
