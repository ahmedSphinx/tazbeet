import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/mood.dart';
import '../../l10n/app_localizations.dart';
import 'app_logging_service.dart';

/// Service for exporting mood data to various formats
class MoodExportService {
  static const String _csvHeaders = 'Date,Mood Level,Energy,Focus,Stress,Note,Tags';

  /// Export mood data to CSV format
  static Future<String> exportToCSV(List<Mood> moods, AppLocalizations l10n) async {
    try {
      final csvData = StringBuffer();
      csvData.writeln(_csvHeaders);

      // Sort moods by date (newest first)
      final sortedMoods = List<Mood>.from(moods)..sort((a, b) => b.date.compareTo(a.date));

      for (final mood in sortedMoods) {
        final date = _formatDate(mood.date);
        final moodLevel = _getMoodLevelText(mood.level, l10n);
        final energy = mood.energyLevel.toString();
        final focus = mood.focusLevel.toString();
        final stress = mood.stressLevel.toString();
        final note = mood.note?.replaceAll(',', ';') ?? '';
        final tags = mood.tags.join(';');

        csvData.writeln('$date,$moodLevel,$energy,$focus,$stress,"$note","$tags"');
      }

      return csvData.toString();
    } catch (e) {
      AppLogging.logError('Error exporting to CSV: $e');
      rethrow;
    }
  }

  /// Export mood data to JSON format
  static Future<String> exportToJSON(List<Mood> moods) async {
    try {
      final exportData = {'export_date': DateTime.now().toIso8601String(), 'total_moods': moods.length, 'moods': moods.map((mood) => mood.toJson()).toList()};

      return const JsonEncoder.withIndent('  ').convert(exportData);
    } catch (e) {
      AppLogging.logError('Error exporting to JSON: $e');
      rethrow;
    }
  }

  /// Generate mood statistics summary
  static String generateStatisticsSummary(List<Mood> moods, AppLocalizations l10n) {
    if (moods.isEmpty) return 'No mood data available.';

    final sortedMoods = List<Mood>.from(moods)..sort((a, b) => a.date.compareTo(b.date));

    final firstEntry = sortedMoods.first;
    final lastEntry = sortedMoods.last;
    final totalDays = lastEntry.date.difference(firstEntry.date).inDays + 1;

    // Calculate averages
    final avgMood = moods.map((m) => m.level.index + 1).reduce((a, b) => a + b) / moods.length;
    final avgEnergy = moods.map((m) => m.energyLevel).reduce((a, b) => a + b) / moods.length;
    final avgFocus = moods.map((m) => m.focusLevel).reduce((a, b) => a + b) / moods.length;
    final avgStress = moods.map((m) => m.stressLevel).reduce((a, b) => a + b) / moods.length;

    // Mood distribution
    final moodCounts = <String, int>{};
    for (final mood in moods) {
      final moodText = _getMoodLevelText(mood.level, l10n);
      moodCounts[moodText] = (moodCounts[moodText] ?? 0) + 1;
    }

    final summary = StringBuffer();
    summary.writeln('=== MOOD TRACKING STATISTICS ===');
    summary.writeln('Generated: ${DateTime.now().toString().split('.')[0]}');
    summary.writeln('');
    summary.writeln('OVERVIEW:');
    summary.writeln('  Total Entries: ${moods.length}');
    summary.writeln('  Tracking Period: $totalDays days');
    summary.writeln('  First Entry: ${_formatDate(firstEntry.date)}');
    summary.writeln('  Last Entry: ${_formatDate(lastEntry.date)}');
    summary.writeln('');
    summary.writeln('AVERAGES:');
    summary.writeln('  Mood Level: ${avgMood.toStringAsFixed(1)}/5');
    summary.writeln('  Energy: ${avgEnergy.toStringAsFixed(1)}/10');
    summary.writeln('  Focus: ${avgFocus.toStringAsFixed(1)}/10');
    summary.writeln('  Stress: ${avgStress.toStringAsFixed(1)}/10');
    summary.writeln('');
    summary.writeln('MOOD DISTRIBUTION:');
    moodCounts.forEach((mood, count) {
      final percentage = (count / moods.length * 100).toStringAsFixed(1);
      summary.writeln('  $mood: $count ($percentage%)');
    });

    return summary.toString();
  }

  /// Save export to file and share
  static Future<void> shareExportFile(String content, String fileName, String fileType) async {
    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsString(content);

      final shareResult = await Share.shareXFiles([XFile(file.path, name: fileName, mimeType: 'text/$fileType')], subject: 'Mood Tracking Data Export');

      // Clean up temporary file
      if (shareResult.status == ShareResultStatus.success) {
        await file.delete();
      }
    } catch (e) {
      AppLogging.logError('Error sharing export file: $e');
      rethrow;
    }
  }

  /// Export mood data with multiple formats
  static Future<Map<String, String>> exportAllFormats(List<Mood> moods, AppLocalizations l10n) async {
    final results = <String, String>{};

    try {
      // CSV Export
      results['csv'] = await exportToCSV(moods, l10n);

      // JSON Export
      results['json'] = await exportToJSON(moods);

      // Statistics Summary
      results['summary'] = generateStatisticsSummary(moods, l10n);

      return results;
    } catch (e) {
      AppLogging.logError('Error exporting all formats: $e');
      rethrow;
    }
  }

  /// Helper method to format date consistently
  static String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Helper method to get mood level text
  static String _getMoodLevelText(MoodLevel level, AppLocalizations l10n) {
    switch (level) {
      case MoodLevel.very_bad:
        return 'Very Bad';
      case MoodLevel.bad:
        return 'Bad';
      case MoodLevel.neutral:
        return 'Neutral';
      case MoodLevel.good:
        return 'Good';
      case MoodLevel.very_good:
        return 'Very Good';
    }
  }

  /// Validate mood data before export
  static bool validateMoodData(List<Mood> moods) {
    if (moods.isEmpty) return false;

    for (final mood in moods) {
      // Check for required fields
      if (mood.id.isEmpty) return false;

      // Check for valid ranges
      if (mood.energyLevel < 1 || mood.energyLevel > 10) return false;
      if (mood.focusLevel < 1 || mood.focusLevel > 10) return false;
      if (mood.stressLevel < 1 || mood.stressLevel > 10) return false;
    }

    return true;
  }

  /// Get export file name with timestamp
  static String getExportFileName(String fileType) {
    final timestamp = DateTime.now().toIso8601String().split('.')[0].replaceAll(':', '-');
    return 'mood_export_$timestamp.$fileType';
  }
}

/// Export format options
enum ExportFormat { csv, json, summary, all }

/// Export result class
class ExportResult {
  final bool success;
  final String? filePath;
  final String? error;
  final String format;

  ExportResult({required this.success, this.filePath, this.error, required this.format});

  factory ExportResult.success(String filePath, String format) {
    return ExportResult(success: true, filePath: filePath, format: format);
  }

  factory ExportResult.failure(String error, String format) {
    return ExportResult(success: false, error: error, format: format);
  }
}
