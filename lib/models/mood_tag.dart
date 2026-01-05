import 'package:equatable/equatable.dart';

/// Represents a tag category for mood tracking
enum MoodTagCategory { activity, people, location, physical, event }

/// Represents a tag that can be associated with a mood entry
class MoodTag extends Equatable {
  final String id;
  final String label;
  final String emoji;
  final MoodTagCategory category;
  final bool isCustom;

  const MoodTag({required this.id, required this.label, required this.emoji, required this.category, this.isCustom = false});

  MoodTag copyWith({String? id, String? label, String? emoji, MoodTagCategory? category, bool? isCustom}) {
    return MoodTag(id: id ?? this.id, label: label ?? this.label, emoji: emoji ?? this.emoji, category: category ?? this.category, isCustom: isCustom ?? this.isCustom);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'label': label, 'emoji': emoji, 'category': category.name, 'isCustom': isCustom};
  }

  factory MoodTag.fromJson(Map<String, dynamic> json) {
    return MoodTag(
      id: json['id'],
      label: json['label'],
      emoji: json['emoji'],
      category: MoodTagCategory.values.firstWhere((e) => e.name == json['category'], orElse: () => MoodTagCategory.activity),
      isCustom: json['isCustom'] ?? false,
    );
  }

  @override
  List<Object?> get props => [id, label, emoji, category, isCustom];
}

/// Predefined mood tags
class MoodTags {
  // Activities
  static const work = MoodTag(id: 'work', label: 'Work', emoji: '💼', category: MoodTagCategory.activity);
  static const exercise = MoodTag(id: 'exercise', label: 'Exercise', emoji: '🏃', category: MoodTagCategory.activity);
  static const social = MoodTag(id: 'social', label: 'Social', emoji: '👥', category: MoodTagCategory.activity);
  static const rest = MoodTag(id: 'rest', label: 'Rest', emoji: '😴', category: MoodTagCategory.activity);
  static const hobbies = MoodTag(id: 'hobbies', label: 'Hobbies', emoji: '🎨', category: MoodTagCategory.activity);
  static const commute = MoodTag(id: 'commute', label: 'Commute', emoji: '🚗', category: MoodTagCategory.activity);

  // People
  static const alone = MoodTag(id: 'alone', label: 'Alone', emoji: '🧘', category: MoodTagCategory.people);
  static const family = MoodTag(id: 'family', label: 'Family', emoji: '👨‍👩‍👧‍👦', category: MoodTagCategory.people);
  static const friends = MoodTag(id: 'friends', label: 'Friends', emoji: '👯', category: MoodTagCategory.people);
  static const partner = MoodTag(id: 'partner', label: 'Partner', emoji: '💑', category: MoodTagCategory.people);
  static const colleagues = MoodTag(id: 'colleagues', label: 'Colleagues', emoji: '👔', category: MoodTagCategory.people);

  // Location
  static const home = MoodTag(id: 'home', label: 'Home', emoji: '🏠', category: MoodTagCategory.location);
  static const office = MoodTag(id: 'office', label: 'Office', emoji: '🏢', category: MoodTagCategory.location);
  static const outdoors = MoodTag(id: 'outdoors', label: 'Outdoors', emoji: '🌳', category: MoodTagCategory.location);
  static const gym = MoodTag(id: 'gym', label: 'Gym', emoji: '💪', category: MoodTagCategory.location);
  static const cafe = MoodTag(id: 'cafe', label: 'Café', emoji: '☕', category: MoodTagCategory.location);

  // Physical
  static const hungry = MoodTag(id: 'hungry', label: 'Hungry', emoji: '🍽️', category: MoodTagCategory.physical);
  static const tired = MoodTag(id: 'tired', label: 'Tired', emoji: '😴', category: MoodTagCategory.physical);
  static const sick = MoodTag(id: 'sick', label: 'Sick', emoji: '🤒', category: MoodTagCategory.physical);
  static const energized = MoodTag(id: 'energized', label: 'Energized', emoji: '⚡', category: MoodTagCategory.physical);
  static const pain = MoodTag(id: 'pain', label: 'Pain', emoji: '🤕', category: MoodTagCategory.physical);

  // Events
  static const meeting = MoodTag(id: 'meeting', label: 'Meeting', emoji: '📅', category: MoodTagCategory.event);
  static const deadline = MoodTag(id: 'deadline', label: 'Deadline', emoji: '⏰', category: MoodTagCategory.event);
  static const conflict = MoodTag(id: 'conflict', label: 'Conflict', emoji: '⚠️', category: MoodTagCategory.event);
  static const achievement = MoodTag(id: 'achievement', label: 'Achievement', emoji: '🎉', category: MoodTagCategory.event);
  static const news = MoodTag(id: 'news', label: 'News', emoji: '📰', category: MoodTagCategory.event);

  static List<MoodTag> get allTags => [
    // Activities
    work,
    exercise,
    social,
    rest,
    hobbies,
    commute,
    // People
    alone,
    family,
    friends,
    partner,
    colleagues,
    // Location
    home,
    office,
    outdoors,
    gym,
    cafe,
    // Physical
    hungry,
    tired,
    sick,
    energized,
    pain,
    // Events
    meeting,
    deadline,
    conflict,
    achievement,
    news,
  ];

  static List<MoodTag> getTagsByCategory(MoodTagCategory category) {
    return allTags.where((tag) => tag.category == category).toList();
  }
}
