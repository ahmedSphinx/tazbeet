import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/mood.dart';
import 'dart:math' as math;

/// Intelligent mood suggestions widget with personalized recommendations
class MoodSuggestionsWidget extends StatefulWidget {
  final List<Mood> moods;
  final ValueChanged<String> onSuggestionTap;

  const MoodSuggestionsWidget({super.key, required this.moods, required this.onSuggestionTap});

  @override
  State<MoodSuggestionsWidget> createState() => _MoodSuggestionsWidgetState();
}

class _MoodSuggestionsWidgetState extends State<MoodSuggestionsWidget> with TickerProviderStateMixin {
  late AnimationController _suggestionController;
  late Animation<double> _suggestionAnimation;

  @override
  void initState() {
    super.initState();

    _suggestionController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);

    _suggestionAnimation = CurvedAnimation(parent: _suggestionController, curve: Curves.easeOutBack);

    _suggestionController.forward();
  }

  @override
  void dispose() {
    _suggestionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final suggestions = _generateSuggestions();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [theme.colorScheme.tertiaryContainer.withValues(alpha: 0.2), Colors.amber.withValues(alpha: 0.1), theme.colorScheme.surface], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.1)),
        boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.1), blurRadius: 30, offset: const Offset(0, 15))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(theme),

          const SizedBox(height: 20),

          // Suggestions grid
          AnimatedBuilder(
            animation: _suggestionAnimation,
            builder: (context, child) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 1.4),
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  final delay = index * 0.1;
                  final animationValue = math.max(0.0, math.min(1.0, (_suggestionAnimation.value - delay) / (1.0 - delay)));

                  return Transform.scale(
                    scale: 0.8 + (animationValue * 0.2),
                    child: Opacity(opacity: animationValue, child: _buildSuggestionCard(theme, suggestion, index)),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        // Lightbulb icon
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.amber, Colors.orange]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.amber.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))],
          ),
          child: const Icon(Icons.lightbulb, color: Colors.white, size: 20),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.moodSuggestionsTitle,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
              ),
              const SizedBox(height: 4),
              Text(AppLocalizations.of(context)!.moodSuggestionsSubtitle, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
            ],
          ),
        ),

        // AI badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.purple.withValues(alpha: 0.2), Colors.blue.withValues(alpha: 0.2)]),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
          ),
          child: Text(
            'AI',
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.purple),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestionCard(ThemeData theme, MoodSuggestion suggestion, int index) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onSuggestionTap(suggestion.title);
        _showSuggestionDetails(suggestion);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [suggestion.color.withValues(alpha: 0.1), suggestion.color.withValues(alpha: 0.05), theme.colorScheme.surface], begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: suggestion.color.withValues(alpha: 0.2)),
          boxShadow: [BoxShadow(color: suggestion.color.withValues(alpha: 0.1), blurRadius: 15, offset: const Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon and priority
            Row(
              children: [
                Text(suggestion.emoji, style: const TextStyle(fontSize: 20)),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                  decoration: BoxDecoration(color: suggestion.color.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(6)),
                  child: Text(
                    suggestion.priority,
                    style: theme.textTheme.bodySmall?.copyWith(fontSize: 9, fontWeight: FontWeight.bold, color: suggestion.color),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // Title
            Text(
              suggestion.title,
              style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 2),

            // Description
            Expanded(
              child: Text(
                suggestion.description,
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 4),

            // Action indicator
            Row(
              children: [
                Icon(Icons.touch_app, size: 12, color: suggestion.color),
                const SizedBox(width: 2),
                Text(
                  'اضغط للتجربة',
                  style: theme.textTheme.bodySmall?.copyWith(fontSize: 9, color: suggestion.color, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<MoodSuggestion> _generateSuggestions() {
    final suggestions = <MoodSuggestion>[];

    if (widget.moods.isEmpty) {
      return _getDefaultSuggestions();
    }

    // Analyze mood patterns
    final recentMoods = widget.moods.take(7).toList();
    final avgMood = recentMoods.map((m) => m.level.index).reduce((a, b) => a + b) / recentMoods.length;
    final avgEnergy = recentMoods.map((m) => m.energyLevel).reduce((a, b) => a + b) / recentMoods.length;
    final avgStress = recentMoods.map((m) => m.stressLevel).reduce((a, b) => a + b) / recentMoods.length;

    // Generate personalized suggestions based on patterns
    if (avgMood < 2.0) {
      suggestions.add(MoodSuggestion(title: 'أنشطة تحسين المزاج', description: 'جرب أنشطة إيجابية لتحسين مزاجك', emoji: '🌟', color: Colors.yellow, priority: 'عالي', actions: ['استمع لموسيقى مبهجة', 'اتصل بصديق', 'تمشى في الخارج']));
    }

    if (avgEnergy < 4.0) {
      suggestions.add(MoodSuggestion(title: 'محفزات الطاقة', description: 'طرق طبيعية لزيادة مستوى طاقتك', emoji: '⚡', color: Colors.orange, priority: 'متوسط', actions: ['خذ قيلولة قصيرة', 'اشرب الشاي الأخضر', 'مارس تمارين خفيفة']));
    }

    if (avgStress > 6.0) {
      suggestions.add(MoodSuggestion(title: 'تخفيف التوتر', description: 'تقنيات لمساعدتك على الاسترخاء والهدوء', emoji: '🧘', color: Colors.blue, priority: 'عالي', actions: ['مارس التنفس العميق', 'جرب التأمل', 'خذ حمام دافئ']));
    }

    // Time-based suggestions
    final hour = DateTime.now().hour;
    if (hour < 10) {
      suggestions.add(MoodSuggestion(title: 'روتين الصباح', description: 'ابدأ يومك بطاقة إيجابية', emoji: '🌅', color: Colors.amber, priority: 'متوسط', actions: ['تمارين الصباح', 'كتابة الامتنان', 'فطور صحي']));
    } else if (hour > 18) {
      suggestions.add(MoodSuggestion(title: 'استرخاء المساء', description: 'استعد لليلة هادئة ومريحة', emoji: '🌙', color: Colors.indigo, priority: 'متوسط', actions: ['اقرأ كتاب', 'شاي عشبي', 'يوجا لطيفة']));
    }

    // Add general wellness suggestions
    suggestions.addAll(_getWellnessSuggestions());

    // Limit to 6 suggestions and prioritize
    suggestions.sort((a, b) => _getPriorityValue(a.priority).compareTo(_getPriorityValue(b.priority)));
    return suggestions.take(6).toList();
  }

  List<MoodSuggestion> _getDefaultSuggestions() {
    return [
      MoodSuggestion(title: 'ابدأ التتبع', description: 'ابدأ رحلة مزاجك بفحوصات يومية', emoji: '📝', color: Colors.green, priority: 'عالي', actions: ['سجل مزاجك الأول', 'اضبط تذكيرات يومية', 'استكشف الميزات']),
      MoodSuggestion(title: 'اليقظة الذهنية', description: 'مارس التواجد في اللحظة الحالية', emoji: '🧘', color: Colors.blue, priority: 'متوسط', actions: ['تأمل 5 دقائق', 'تمرين التنفس', 'فحص الجسم']),
      MoodSuggestion(title: 'النشاط البدني', description: 'حرك جسمك لتحسين مزاجك', emoji: '🏃', color: Colors.red, priority: 'متوسط', actions: ['مشي سريع', 'تمدد', 'رقص على الموسيقى']),
      MoodSuggestion(title: 'التواصل الاجتماعي', description: 'تواصل مع الآخرين للحصول على الدعم العاطفي', emoji: '👥', color: Colors.purple, priority: 'منخفض', actions: ['راسل صديق', 'مكالمة فيديو مع العائلة', 'انضم لمجتمع']),
    ];
  }

  List<MoodSuggestion> _getWellnessSuggestions() {
    return [
      MoodSuggestion(title: 'فحص الترطيب', description: 'حافظ على الترطيب لمزاج وطاقة أفضل', emoji: '💧', color: Colors.cyan, priority: 'منخفض', actions: ['اشرب الماء', 'شاي عشبي', 'عصير فواكه']),
      MoodSuggestion(title: 'علاج الطبيعة', description: 'اقض وقتاً في الخارج لتحسين المزاج طبيعياً', emoji: '🌳', color: Colors.green, priority: 'متوسط', actions: ['زيارة الحديقة', 'وقت في البستان', 'أصوات الطبيعة']),
    ];
  }

  int _getPriorityValue(String priority) {
    switch (priority) {
      case 'عالي':
      case 'HIGH':
        return 0;
      case 'متوسط':
      case 'MED':
        return 1;
      case 'منخفض':
      case 'LOW':
        return 2;
      default:
        return 3;
    }
  }

  void _showSuggestionDetails(MoodSuggestion suggestion) {
    showModalBottomSheet(context: context, isScrollControlled: true, backgroundColor: Colors.transparent, builder: (context) => _buildSuggestionDetailsSheet(suggestion));
  }

  Widget _buildSuggestionDetailsSheet(MoodSuggestion suggestion) {
    final theme = Theme.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, -10))],
      ),
      child: Column(
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: theme.colorScheme.outline.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(suggestion.emoji, style: const TextStyle(fontSize: 32)),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(suggestion.title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(suggestion.description, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: suggestion.actions.length,
              itemBuilder: (context, index) {
                final action = suggestion.actions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: suggestion.color.withValues(alpha: 0.2),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(color: suggestion.color, fontWeight: FontWeight.bold),
                      ),
                    ),
                    title: Text(action),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.outline),
                    onTap: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                      widget.onSuggestionTap(action);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MoodSuggestion {
  final String title;
  final String description;
  final String emoji;
  final Color color;
  final String priority;
  final List<String> actions;

  MoodSuggestion({required this.title, required this.description, required this.emoji, required this.color, required this.priority, required this.actions});
}
