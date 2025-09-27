import 'package:hive/hive.dart';
import '../models/task.dart';

class TaskRepository {
  static const String _boxName = 'tasks';

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(TaskAdapter());
    }
  }

  Future<Box<Task>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<Task>(_boxName);
    }
    return Hive.box<Task>(_boxName);
  }

  Future<List<Task>> getAllTasks() async {
    final box = await _getBox();
    return box.values.toList();
  }

  Future<Task?> getTaskById(String id) async {
    final box = await _getBox();
    return box.get(id);
  }

  Future<void> addTask(Task task) async {
    final box = await _getBox();
    await box.put(task.id, task);
  }

  Future<void> updateTask(Task task) async {
    final box = await _getBox();
    await box.put(task.id, task);
  }

  Future<void> deleteTask(String id) async {
    final box = await _getBox();
    await box.delete(id);
  }

  Future<List<Task>> getTasksByCategory(String categoryId) async {
    final box = await _getBox();
    return box.values.where((task) => task.categoryId == categoryId).toList();
  }

  Future<List<Task>> getTasksDueToday() async {
    final box = await _getBox();
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    return box.values.where((task) {
      if (task.dueDate == null) return false;
      return task.dueDate!.isAfter(startOfDay) &&
             task.dueDate!.isBefore(endOfDay);
    }).toList();
  }

  Future<List<Task>> getOverdueTasks() async {
    final box = await _getBox();
    final now = DateTime.now();

    return box.values.where((task) {
      if (task.dueDate == null || task.isCompleted) return false;
      return task.dueDate!.isBefore(now);
    }).toList();
  }

  Future<void> clearAllTasks() async {
    final box = await _getBox();
    await box.clear();
  }
}

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    try {
      final json = reader.readMap();
      // Convert Map<dynamic, dynamic> to Map<String, dynamic> safely
      final Map<String, dynamic> convertedJson = {};
      json.forEach((key, value) {
        convertedJson[key.toString()] = value;
      });
      return Task.fromJson(convertedJson);
    } catch (e) {
      // If deserialization fails, create a basic task
      return Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: 'Error Loading Task',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
    }
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.writeMap(obj.toJson());
  }
}
