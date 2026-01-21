class PomodoroTemplate {
  final String id;
  final String name;
  final int workDuration;
  final int restDuration;
  final int longRestDuration;
  final int cycles;
  final String recommendedFor;
  final bool isCustom;

  PomodoroTemplate({
    required this.id,
    required this.name,
    required this.workDuration,
    required this.restDuration,
    required this.longRestDuration,
    required this.cycles,
    required this.recommendedFor,
    this.isCustom = false,
  });

  factory PomodoroTemplate.fromJson(Map<String, dynamic> json) {
    final name = json['name'] ?? '';
    // More consistent ID generation
    final id = name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9_]+'), '_').replaceAll(RegExp(r'_+'), '_').replaceAll(RegExp(r'^_|_$'), '');

    return PomodoroTemplate(
      id: id.isEmpty ? 'default_template' : id,
      name: name,
      workDuration: json['work'] ?? 25,
      restDuration: json['rest'] ?? 5,
      longRestDuration: json['long_rest'] ?? 15,
      cycles: json['cycles'] ?? 4,
      recommendedFor: json['recommended_for'] ?? 'normal',
      isCustom: json['is_custom'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'work': workDuration, 'rest': restDuration, 'long_rest': longRestDuration, 'cycles': cycles, 'recommended_for': recommendedFor};
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is PomodoroTemplate && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'PomodoroTemplate{id: $id, name: $name, workDuration: $workDuration, restDuration: $restDuration}';
  }
}
