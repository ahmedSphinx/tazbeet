import 'package:hive_flutter/hive_flutter.dart';
import '../models/mood.dart';

class MoodRepository {
  static const String _boxName = 'moods';
  late Box<Mood> _box;

  Future<void> init() async {
    // Adapter registration removed to avoid duplicate registration error.
    _box = await Hive.openBox<Mood>(_boxName);
  }

  Future<List<Mood>> getAllMoods() async {
    final moods = _box.values.toList();

    moods.sort((a, b) => b.date.compareTo(a.date));
    return moods;
  }

  Future<List<Mood>> getMoodsForDateRange(DateTime start, DateTime end) async {
    final allMoods = await getAllMoods();
    return allMoods.where((mood) {
      return mood.date.isAfter(start.subtract(const Duration(days: 1))) && mood.date.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  Future<Mood?> getMoodById(String id) async {
    return _box.get(id);
  }

  Future<void> addMood(Mood mood) async {
    await _box.put(mood.id, mood);
  }

  Future<void> updateMood(Mood mood) async {
    await _box.put(mood.id, mood);
  }

  Future<void> deleteMood(String id) async {
    await _box.delete(id);
  }

  Future<void> deleteAllMoods() async {
    await _box.clear();
  }

  Future<Map<String, dynamic>> getMoodStatistics() async {
    final moods = await getAllMoods();
    if (moods.isEmpty) {
      return {'totalEntries': 0, 'averageMood': 2.0, 'mostCommonMood': MoodLevel.neutral, 'streakDays': 0, 'averageEnergy': 5.0, 'averageFocus': 5.0, 'averageStress': 5.0};
    }

    final moodValues = moods.map((m) => m.level.index).toList();
    final averageMood = moodValues.reduce((a, b) => a + b) / moodValues.length;

    final moodCounts = <MoodLevel, int>{};
    for (final mood in moods) {
      moodCounts[mood.level] = (moodCounts[mood.level] ?? 0) + 1;
    }
    final mostCommonMood = moodCounts.entries.reduce((a, b) => a.value > b.value ? a : b).key;

    // Calculate current streak (consecutive days with mood entries)
    int streakDays = 0;
    final today = DateTime.now();
    for (int i = 0; i < 30; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final hasEntry = moods.any((mood) => mood.date.year == checkDate.year && mood.date.month == checkDate.month && mood.date.day == checkDate.day);
      if (hasEntry) {
        streakDays++;
      } else {
        break;
      }
    }

    final averageEnergy = moods.map((m) => m.energyLevel).reduce((a, b) => a + b) / moods.length;
    final averageFocus = moods.map((m) => m.focusLevel).reduce((a, b) => a + b) / moods.length;
    final averageStress = moods.map((m) => m.stressLevel).reduce((a, b) => a + b) / moods.length;

    return {
      'totalEntries': moods.length,
      'averageMood': averageMood,
      'mostCommonMood': mostCommonMood,
      'streakDays': streakDays,
      'averageEnergy': averageEnergy,
      'averageFocus': averageFocus,
      'averageStress': averageStress,
    };
  }

  Future<List<Map<String, dynamic>>> getMoodTrends(int days) async {
    final endDate = DateTime.now();
    final startDate = endDate.subtract(Duration(days: days));
    final moods = await getMoodsForDateRange(startDate, endDate);

    final trends = <Map<String, dynamic>>[];
    for (int i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final dayMoods = moods.where((mood) => mood.date.year == date.year && mood.date.month == date.month && mood.date.day == date.day).toList();

      if (dayMoods.isNotEmpty) {
        final avgMood = dayMoods.map((m) => m.level.index).reduce((a, b) => a + b) / dayMoods.length;
        final avgEnergy = dayMoods.map((m) => m.energyLevel).reduce((a, b) => a + b) / dayMoods.length;
        final avgFocus = dayMoods.map((m) => m.focusLevel).reduce((a, b) => a + b) / dayMoods.length;
        final avgStress = dayMoods.map((m) => m.stressLevel).reduce((a, b) => a + b) / dayMoods.length;

        trends.add({'date': date, 'moodLevel': avgMood, 'energyLevel': avgEnergy, 'focusLevel': avgFocus, 'stressLevel': avgStress, 'entries': dayMoods.length});
      } else {
        trends.add({'date': date, 'moodLevel': null, 'energyLevel': null, 'focusLevel': null, 'stressLevel': null, 'entries': 0});
      }
    }

    return trends;
  }

  Future<List<String>> getSuggestedCheckInTimes({int topCount = 3}) async {
    final allMoods = await getAllMoods();
    if (allMoods.isEmpty) return [];

    // Group moods by hour of day
    final hourCounts = <int, int>{};
    for (final mood in allMoods) {
      final hour = mood.date.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }

    // Sort hours by frequency
    final sortedHours = hourCounts.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    // Take top hours and format as HH:MM (assuming minute 0)
    final suggestedTimes = sortedHours.take(topCount).map((entry) {
      final hour = entry.key;
      return '${hour.toString().padLeft(2, '0')}:00';
    }).toList();

    return suggestedTimes;
  }
}
