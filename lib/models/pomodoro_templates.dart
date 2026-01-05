enum RecommendedFor { normal, adhd, no }

enum SessionType { deepWork, quickTasks, creativeFlow, learning, custom }

enum FocusLevel { high, medium, low }

class PomodoroData {
  final List<PomodoroTemplate> pomodoroTemplates;

  PomodoroData({required this.pomodoroTemplates});

  factory PomodoroData.fromJson(Map<String, dynamic> json) {
    return PomodoroData(pomodoroTemplates: (json['pomodoro_templates'] as List).map((e) => PomodoroTemplate.fromJson(e)).toList());
  }

  Map<String, dynamic> toJson() {
    return {'pomodoro_templates': pomodoroTemplates.map((e) => e.toJson()).toList()};
  }

  /// Get predefined session templates
  static List<PomodoroTemplate> getPredefinedTemplates() {
    return [
      // Deep Work Templates
      PomodoroTemplate(
        name: 'Deep Work',
        work: 50,
        rest: 10,
        longRest: 20,
        cycles: 4,
        recommendedFor: RecommendedFor.normal,
        sessionType: SessionType.deepWork,
        focusLevel: FocusLevel.high,
        description: 'Extended work sessions for complex tasks requiring deep concentration',
        benefits: ['Maximum focus', 'Reduced interruptions', 'Better for complex problem solving'],
        metadata: {
          'intensity': 'high',
          'best_for': ['programming', 'writing', 'research'],
        },
      ),

      PomodoroTemplate(
        name: 'Ultra Deep Work',
        work: 90,
        rest: 15,
        longRest: 30,
        cycles: 3,
        recommendedFor: RecommendedFor.normal,
        sessionType: SessionType.deepWork,
        focusLevel: FocusLevel.high,
        description: 'Very long sessions for highly focused work on critical tasks',
        benefits: ['Flow state induction', 'Maximum productivity', 'Best for creative work'],
        metadata: {
          'intensity': 'very_high',
          'best_for': ['creative projects', 'deep analysis'],
        },
      ),

      // Quick Tasks Templates
      PomodoroTemplate(
        name: 'Quick Tasks',
        work: 15,
        rest: 5,
        longRest: 10,
        cycles: 6,
        recommendedFor: RecommendedFor.normal,
        sessionType: SessionType.quickTasks,
        focusLevel: FocusLevel.low,
        description: 'Short bursts for quick tasks and administrative work',
        benefits: ['Fast completion', 'Reduced procrastination', 'Good for momentum'],
        metadata: {
          'intensity': 'low',
          'best_for': ['email', 'admin', 'small fixes'],
        },
      ),

      PomodoroTemplate(
        name: 'Micro Tasks',
        work: 10,
        rest: 3,
        longRest: 8,
        cycles: 8,
        recommendedFor: RecommendedFor.adhd,
        sessionType: SessionType.quickTasks,
        focusLevel: FocusLevel.low,
        description: 'Very short sessions for maintaining focus on routine tasks',
        benefits: ['ADHD friendly', 'High frequency', 'Prevents boredom'],
        metadata: {
          'intensity': 'very_low',
          'best_for': ['routine tasks', 'habit building'],
        },
      ),

      // Creative Flow Templates
      PomodoroTemplate(
        name: 'Creative Flow',
        work: 45,
        rest: 15,
        longRest: 25,
        cycles: 3,
        recommendedFor: RecommendedFor.normal,
        sessionType: SessionType.creativeFlow,
        focusLevel: FocusLevel.medium,
        description: 'Balanced sessions for creative work and brainstorming',
        benefits: ['Encourages creativity', 'Good for ideation', 'Prevents burnout'],
        metadata: {
          'intensity': 'medium',
          'best_for': ['design', 'brainstorming', 'content creation'],
        },
      ),

      PomodoroTemplate(
        name: 'Inspiration Burst',
        work: 25,
        rest: 10,
        longRest: 20,
        cycles: 4,
        recommendedFor: RecommendedFor.normal,
        sessionType: SessionType.creativeFlow,
        focusLevel: FocusLevel.medium,
        description: 'Standard pomodoro with longer breaks for creative thinking',
        benefits: ['Classic structure', 'Good balance', 'Creative breaks'],
        metadata: {
          'intensity': 'medium',
          'best_for': ['writing', 'design', 'problem solving'],
        },
      ),

      // Learning Templates
      PomodoroTemplate(
        name: 'Learning',
        work: 25,
        rest: 5,
        longRest: 15,
        cycles: 4,
        recommendedFor: RecommendedFor.normal,
        sessionType: SessionType.learning,
        focusLevel: FocusLevel.medium,
        description: 'Optimized for studying and knowledge retention',
        benefits: ['Better retention', 'Spaced repetition', 'Reduced fatigue'],
        metadata: {
          'intensity': 'medium',
          'best_for': ['studying', 'reading', 'skill development'],
        },
      ),

      PomodoroTemplate(
        name: 'Study Sprint',
        work: 35,
        rest: 8,
        longRest: 18,
        cycles: 3,
        recommendedFor: RecommendedFor.normal,
        sessionType: SessionType.learning,
        focusLevel: FocusLevel.high,
        description: 'Extended study sessions for intensive learning',
        benefits: ['Deep learning', 'Good for complex topics', 'Better focus'],
        metadata: {
          'intensity': 'high',
          'best_for': ['exam prep', 'complex subjects'],
        },
      ),

      // ADHD-Friendly Templates
      PomodoroTemplate(
        name: 'ADHD Focus',
        work: 20,
        rest: 7,
        longRest: 12,
        cycles: 5,
        recommendedFor: RecommendedFor.adhd,
        sessionType: SessionType.custom,
        focusLevel: FocusLevel.medium,
        description: 'Shorter work sessions with frequent breaks for maintaining attention',
        benefits: ['ADHD optimized', 'Frequent breaks', 'Maintains engagement'],
        metadata: {
          'intensity': 'medium',
          'best_for': ['focus maintenance', 'attention management'],
        },
      ),

      PomodoroTemplate(
        name: 'Hyperfocus',
        work: 30,
        rest: 5,
        longRest: 10,
        cycles: 4,
        recommendedFor: RecommendedFor.adhd,
        sessionType: SessionType.custom,
        focusLevel: FocusLevel.high,
        description: 'Leverages hyperfocus tendencies with structured breaks',
        benefits: ['Uses hyperfocus', 'Structured breaks', 'Prevents overextension'],
        metadata: {
          'intensity': 'high',
          'best_for': ['engaging tasks', 'interest-driven work'],
        },
      ),

      // Standard Templates
      PomodoroTemplate(
        name: 'Classic Pomodoro',
        work: 25,
        rest: 5,
        longRest: 15,
        cycles: 4,
        recommendedFor: RecommendedFor.normal,
        sessionType: SessionType.custom,
        focusLevel: FocusLevel.medium,
        description: 'The original pomodoro technique by Francesco Cirillo',
        benefits: ['Time-tested', 'Balanced approach', 'Widely adopted'],
        metadata: {
          'intensity': 'medium',
          'best_for': ['general use', 'beginners'],
        },
      ),

      PomodoroTemplate(
        name: 'Modified Pomodoro',
        work: 30,
        rest: 5,
        longRest: 15,
        cycles: 4,
        recommendedFor: RecommendedFor.normal,
        sessionType: SessionType.custom,
        focusLevel: FocusLevel.medium,
        description: 'Slightly longer work sessions for modern work patterns',
        benefits: ['More work time', 'Still balanced', 'Popular variation'],
        metadata: {
          'intensity': 'medium',
          'best_for': ['modern work', 'flexible schedules'],
        },
      ),
    ];
  }

  /// Get template by name
  static PomodoroTemplate? getTemplateByName(String name) {
    final templates = getPredefinedTemplates();
    try {
      return templates.firstWhere((template) => template.name == name);
    } catch (e) {
      return null;
    }
  }

  /// Get templates by session type
  static List<PomodoroTemplate> getTemplatesByType(SessionType type) {
    return getPredefinedTemplates().where((template) => template.sessionType == type).toList();
  }

  /// Get templates by focus level
  static List<PomodoroTemplate> getTemplatesByFocusLevel(FocusLevel level) {
    return getPredefinedTemplates().where((template) => template.focusLevel == level).toList();
  }

  /// Get templates by recommendation
  static List<PomodoroTemplate> getTemplatesByRecommendation(RecommendedFor recommendation) {
    return getPredefinedTemplates().where((template) => template.recommendedFor == recommendation).toList();
  }

  /// Get recommended templates for task
  static List<PomodoroTemplate> getRecommendedTemplatesForTask(String taskTitle, String? taskDescription) {
    final allTemplates = getPredefinedTemplates();
    final suitable = allTemplates.where((template) => template.isSuitableForTask(taskTitle, taskDescription)).toList();

    // If no specific matches, return general purpose templates
    if (suitable.isEmpty) {
      return allTemplates.where((template) => template.sessionType == SessionType.custom).take(3).toList();
    }

    return suitable;
  }
}

class PomodoroTemplate {
  final String name;
  final int work;
  final int rest;
  final int longRest;
  final int cycles;
  final RecommendedFor recommendedFor;
  final SessionType sessionType;
  final FocusLevel focusLevel;
  final String description;
  final List<String> benefits;
  final Map<String, dynamic>? metadata;

  PomodoroTemplate({
    required this.name,
    required this.work,
    required this.rest,
    required this.longRest,
    required this.cycles,
    required this.recommendedFor,
    this.sessionType = SessionType.custom,
    this.focusLevel = FocusLevel.medium,
    this.description = '',
    this.benefits = const [],
    this.metadata,
  });

  factory PomodoroTemplate.fromJson(Map<String, dynamic> json) {
    return PomodoroTemplate(
      name: json['name'],
      work: json['work'],
      rest: json['rest'],
      longRest: json['long_rest'],
      cycles: json['cycles'],
      recommendedFor: RecommendedFor.values.firstWhere((e) => e.name == json['recommended_for']),
      sessionType: json['session_type'] != null ? SessionType.values.firstWhere((e) => e.name == json['session_type']) : SessionType.custom,
      focusLevel: json['focus_level'] != null ? FocusLevel.values.firstWhere((e) => e.name == json['focus_level']) : FocusLevel.medium,
      description: json['description'] ?? '',
      benefits: (json['benefits'] as List?)?.cast<String>() ?? [],
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'work': work,
      'rest': rest,
      'long_rest': longRest,
      'cycles': cycles,
      'recommended_for': recommendedFor.name,
      'session_type': sessionType.name,
      'focus_level': focusLevel.name,
      'description': description,
      'benefits': benefits,
      'metadata': metadata,
    };
  }

  /// Get total work time in minutes
  int get totalWorkTime => work * cycles;

  /// Get total break time in minutes
  int get totalBreakTime {
    final shortBreaks = cycles - 1;
    final longBreaks = (cycles / 4).floor(); // Assume long break every 4 cycles
    return (shortBreaks * rest) + (longBreaks * longRest);
  }

  /// Get total session time in minutes
  int get totalSessionTime => totalWorkTime + totalBreakTime;

  /// Get recommended task types for this template
  List<String> get recommendedTaskTypes {
    switch (sessionType) {
      case SessionType.deepWork:
        return ['coding', 'writing', 'research', 'analysis'];
      case SessionType.quickTasks:
        return ['email', 'admin', 'quick review', 'small fixes'];
      case SessionType.creativeFlow:
        return ['design', 'brainstorming', 'content creation', 'problem solving'];
      case SessionType.learning:
        return ['studying', 'reading', 'skill development', 'practice'];
      case SessionType.custom:
        return ['general', 'mixed tasks', 'flexible work'];
    }
  }

  /// Check if template is suitable for given task
  bool isSuitableForTask(String taskTitle, String? taskDescription) {
    final searchText = '${taskTitle.toLowerCase()} ${taskDescription?.toLowerCase() ?? ''}';

    for (final taskType in recommendedTaskTypes) {
      if (searchText.contains(taskType)) {
        return true;
      }
    }

    return false;
  }

  /// Get intensity score (1-10)
  int get intensityScore {
    final workRatio = work / (work + rest);
    final durationFactor = work >= 45
        ? 1.2
        : work <= 20
        ? 0.8
        : 1.0;
    final focusMultiplier = focusLevel == FocusLevel.high
        ? 1.3
        : focusLevel == FocusLevel.low
        ? 0.7
        : 1.0;

    return (workRatio * 10 * durationFactor * focusMultiplier).round().clamp(1, 10);
  }

  /// Get energy requirement (1-10)
  int get energyRequirement {
    if (sessionType == SessionType.deepWork) return 8;
    if (sessionType == SessionType.creativeFlow) return 7;
    if (sessionType == SessionType.learning) return 6;
    if (sessionType == SessionType.quickTasks) return 3;
    return 5;
  }
}
