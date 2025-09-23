import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/category.dart';

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 1;

  @override
  Category read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };

    return Category(
      id: fields[0] as String,
      name: fields[1] as String,
      color: Color(fields[2] as int),
      icon: fields[3] as String,
      createdAt: fields[4] as DateTime,
      isDefault: fields[5] as bool,
      tasksCount: fields[6] as int? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.color.toARGB32())
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.isDefault)
      ..writeByte(6)
      ..write(obj.tasksCount);
  }
}

class CategoryRepository {
  static const String _boxName = 'categories';
  late Box<Category> _categoryBox;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryAdapter());
    }
    _categoryBox = await Hive.openBox<Category>(_boxName);
  }

  Future<List<Category>> getAllCategories() async {
    return _categoryBox.values.toList();
  }

  Future<Category?> getCategoryById(String id) async {
    return _categoryBox.get(id);
  }

  Future<void> addCategory(Category category) async {
    await _categoryBox.put(category.id, category);
  }

  Future<void> updateCategory(Category category) async {
    await _categoryBox.put(category.id, category);
  }

  Future<void> deleteCategory(String id) async {
    await _categoryBox.delete(id);
  }

  Future<List<Category>> getDefaultCategories() async {
    final allCategories = await getAllCategories();
    return allCategories.where((category) => category.isDefault).toList();
  }

  Future<void> createDefaultCategories() async {
    final defaultCategories = [
      Category(
        id: 'work',
        name: 'Work',
        color: const Color(0xFF2196F3), // Blue
        icon: 'work',
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      Category(
        id: 'personal',
        name: 'Personal',
        color: const Color(0xFF4CAF50), // Green
        icon: 'person',
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      Category(
        id: 'learning',
        name: 'Learning',
        color: const Color(0xFFFF9800), // Orange
        icon: 'school',
        createdAt: DateTime.now(),
        isDefault: true,
      ),
      Category(
        id: 'health',
        name: 'Health',
        color: const Color(0xFFE91E63), // Pink
        icon: 'fitness_center',
        createdAt: DateTime.now(),
        isDefault: true,
      ),
    ];

    for (final category in defaultCategories) {
      if (await getCategoryById(category.id) == null) {
        await addCategory(category);
      }
    }
  }
}
