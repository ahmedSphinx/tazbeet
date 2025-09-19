import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 34)
class User extends Equatable {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final String? profileImageUrl;
  @HiveField(3)
  final DateTime? birthday;
  @HiveField(4)
  final DateTime createdAt;
  @HiveField(5)
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.name,
    this.profileImageUrl,
    this.birthday,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? profileImageUrl,
    DateTime? birthday,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      birthday: birthday ?? this.birthday,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImageUrl': profileImageUrl,
      'birthday': birthday?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'] ?? '',
      profileImageUrl: json['profileImageUrl'],
      birthday: json['birthday'] != null ? DateTime.parse(json['birthday']) : null,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        profileImageUrl,
        birthday,
        createdAt,
        updatedAt,
      ];
}
