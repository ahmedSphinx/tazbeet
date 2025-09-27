import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/task.dart';
import '../repositories/task_repository.dart';
class DataManagementService {
  final TaskRepository _taskRepository = TaskRepository();

  Future<String> exportTasksToCSV() async {
    final tasks = await _taskRepository.getAllTasks();
    List<List<String>> csvData = [
      ['ID', 'Title', 'Description', 'Priority', 'DueDate', 'ReminderDate', 'CategoryId', 'IsCompleted']
    ];

    for (var task in tasks) {
      csvData.add([
        task.id,
        task.title,
        task.description ?? '',
        task.priority.toString(),
        task.dueDate?.toIso8601String() ?? '',
        task.reminderDate?.toIso8601String() ?? '',
        task.categoryId ?? '',
        task.isCompleted.toString(),
      ]);
    }

    String csv = const ListToCsvConverter().convert(csvData);
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/tasks_export_${DateTime.now().millisecondsSinceEpoch}.csv';
    final file = File(path);
    await file.writeAsString(csv);
    return path;
  }

  Future<String> exportTasksToJSON() async {
    final tasks = await _taskRepository.getAllTasks();
    final jsonList = tasks.map((task) => task.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/tasks_export_${DateTime.now().millisecondsSinceEpoch}.json';
    final file = File(path);
    await file.writeAsString(jsonString);
    return path;
  }

  Future<String> exportTasksToICS() async {
    final tasks = await _taskRepository.getAllTasks();
    final icsContent = _generateICSContent(tasks);
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/tasks_export_${DateTime.now().millisecondsSinceEpoch}.ics';
    final file = File(path);
    await file.writeAsString(icsContent);
    return path;
  }

  String _generateICSContent(List<Task> tasks) {
    final buffer = StringBuffer();
    buffer.writeln('BEGIN:VCALENDAR');
    buffer.writeln('VERSION:2.0');
    buffer.writeln('PRODID:-//Tazbeet//EN');

    for (final task in tasks) {
      if (task.dueDate != null) {
        buffer.writeln('BEGIN:VEVENT');
        buffer.writeln('UID:${task.id}@tazbeet');
        buffer.writeln('SUMMARY:${task.title}');
        if (task.description != null && task.description!.isNotEmpty) {
          buffer.writeln('DESCRIPTION:${task.description}');
        }
        buffer.writeln('DTSTART:${_formatICSDate(task.dueDate!)}');
        buffer.writeln('DTEND:${_formatICSDate(task.dueDate!.add(const Duration(hours: 1)))}');
        buffer.writeln('STATUS:${task.isCompleted ? 'COMPLETED' : 'CONFIRMED'}');
        if (task.reminderDate != null) {
          buffer.writeln('BEGIN:VALARM');
          buffer.writeln('TRIGGER:-PT${task.reminderDate!.difference(DateTime.now()).inMinutes}M');
          buffer.writeln('ACTION:DISPLAY');
          buffer.writeln('DESCRIPTION:Reminder for ${task.title}');
          buffer.writeln('END:VALARM');
        }
        buffer.writeln('END:VEVENT');
      }
    }

    buffer.writeln('END:VCALENDAR');
    return buffer.toString();
  }

  String _formatICSDate(DateTime date) {
    return '${date.toUtc().toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first}Z';
  }

  Future<void> shareFile(String filePath) async {
    await Share.shareXFiles([XFile(filePath)]);
  }

  Future<String?> pickImportFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'json'],
    );
    if (result != null && result.files.single.path != null) {
      return result.files.single.path;
    }
    return null;
  }

  Future<void> importTasksFromCSV(String filePath) async {
    final file = File(filePath);
    final content = await file.readAsString();
    List<List<dynamic>> csvTable = const CsvToListConverter().convert(content, eol: '\n');

    if (csvTable.isEmpty) return;

    final headers = csvTable.first;
    final rows = csvTable.sublist(1);

    for (var row in rows) {
      final taskMap = <String, dynamic>{};
      for (int i = 0; i < headers.length; i++) {
        taskMap[headers[i].toString()] = row[i];
      }
      final task = Task.fromJson(taskMap);
      final existingTask = await _taskRepository.getTaskById(task.id);
      if (existingTask != null) {
        await _taskRepository.updateTask(task);
      } else {
        await _taskRepository.addTask(task);
      }
    }
  }

  Future<void> importTasksFromJSON(String filePath) async {
    final file = File(filePath);
    final content = await file.readAsString();
    final List<dynamic> jsonList = jsonDecode(content);

    for (var jsonTask in jsonList) {
      if (jsonTask is Map) {
        // Convert Map<dynamic, dynamic> to Map<String, dynamic> safely
        final Map<String, dynamic> convertedJson = {};
        jsonTask.forEach((key, value) {
          convertedJson[key.toString()] = value;
        });
        final task = Task.fromJson(convertedJson);
        final existingTask = await _taskRepository.getTaskById(task.id);
        if (existingTask != null) {
          await _taskRepository.updateTask(task);
        } else {
          await _taskRepository.addTask(task);
        }
      }
    }
  }
}
