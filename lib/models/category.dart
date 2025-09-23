import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final Color color;
  final String icon;
  final DateTime createdAt;
  final bool isDefault;
  final int tasksCount;

  const Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
    required this.createdAt,
    this.isDefault = false,
    this.tasksCount = 0,
  });

  Category copyWith({
    String? id,
    String? name,
    Color? color,
    String? icon,
    DateTime? createdAt,
    bool? isDefault,
    int? tasksCount,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      createdAt: createdAt ?? this.createdAt,
      isDefault: isDefault ?? this.isDefault,
      tasksCount: tasksCount ?? this.tasksCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'color': color.toARGB32(),
      'icon': icon,
      'createdAt': createdAt.toIso8601String(),
      'isDefault': isDefault,
      'tasksCount': tasksCount,
    };
  }

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      color: Color(json['color'] ?? Colors.blue.toARGB32()),
      icon: json['icon'] ?? 'folder',
      createdAt: DateTime.parse(json['createdAt']),
      isDefault: json['isDefault'] ?? false,
      tasksCount: json['tasksCount'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [id, name, color, icon, createdAt, isDefault, tasksCount];
}
