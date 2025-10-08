import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

class TutorialService {
  TutorialCoachMark? _tutorialCoachMark;
  final List<TargetFocus> targets = [];

  void initTargets({
    required GlobalKey addTaskKey,
    required GlobalKey pomodoroKey,
    required GlobalKey categoryFilterKey,
    required GlobalKey moodTrackingKey,
    required GlobalKey taskDetailsKey,
    required BuildContext context,
  }) {
    targets.clear();

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context)!;

    targets.add(
      TargetFocus(
        identify: "AddTask",
        keyTarget: addTaskKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: _buildTutorialContent(context: context, icon: Icons.add_task, title: l10n.addTaskTitle, description: l10n.tapToAddFirstTask, step: 1, totalSteps: 5, color: colorScheme.primary),
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 16,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "CategoryFilter",
        keyTarget: categoryFilterKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildTutorialContent(context: context, icon: Icons.filter_list, title: l10n.filterTasksTitle, description: l10n.createCategoriesToOrganize, step: 2, totalSteps: 5, color: colorScheme.secondary),
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 12,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "Pomodoro",
        keyTarget: pomodoroKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildTutorialContent(context: context, icon: Icons.timer, title: l10n.pomodoroSection, description: l10n.pomodoroDescription, step: 3, totalSteps: 5, color: colorScheme.tertiary),
          ),
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "MoodTracking",
        keyTarget: moodTrackingKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildTutorialContent(context: context, icon: Icons.mood, title: l10n.moodTracking, description: l10n.tapToLogMood, step: 4, totalSteps: 5, color: colorScheme.primaryContainer),
          ),
        ],
        shape: ShapeLightFocus.Circle,
      ),
    );

    targets.add(
      TargetFocus(
        identify: "TaskDetails",
        keyTarget: taskDetailsKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: _buildTutorialContent(context: context, icon: Icons.task_alt, title: l10n.taskDetails, description: l10n.editProfileInfo, step: 5, totalSteps: 5, color: colorScheme.secondaryContainer),
          ),
        ],
        shape: ShapeLightFocus.RRect,
        radius: 16,
      ),
    );
  }

  Widget _buildTutorialContent({required BuildContext context, required IconData icon, required String title, required String description, required int step, required int totalSteps, required Color color}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Enhanced Progress indicator with better styling
          Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Step $step of $totalSteps',
                  style: theme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                ),
                const SizedBox(width: 12),
                ...List.generate(totalSteps, (index) {
                  final isCompleted = index < step - 1;
                  final isCurrent = index == step - 1;
                //  final isUpcoming = index > step - 1;

                  return Container(
                    width: 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 1.5),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? Colors.white
                          : isCurrent
                          ? color
                          : Colors.white.withOpacity(0.3),
                      boxShadow: isCurrent ? [BoxShadow(color: color.withOpacity(0.5), blurRadius: 4, spreadRadius: 1)] : null,
                    ),
                  ).animate(delay: Duration(milliseconds: index * 100)).scale(begin: Offset.zero, end: const Offset(1, 1), duration: const Duration(milliseconds: 400), curve: Curves.elasticOut);
                }),
              ],
            ),
          ),

          // Enhanced Icon with better visual design
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [color, color.withOpacity(0.8), Color.lerp(color, colorScheme.surface, 0.3)!], begin: Alignment.topLeft, end: Alignment.bottomRight, stops: const [0.0, 0.7, 1.0]),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: color.withOpacity(0.4), blurRadius: 20, offset: const Offset(0, 8), spreadRadius: 2),
                BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 40, offset: const Offset(0, 16)),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 36),
          ).animate().scale(begin: const Offset(0.3, 0.3), end: const Offset(1, 1), duration: const Duration(milliseconds: 600), curve: Curves.elasticOut).then().shake(duration: const Duration(milliseconds: 500), hz: 4),

          const SizedBox(height: 24),

          // Enhanced Title with better typography
          Container(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    height: 1.2,
                    shadows: [Shadow(color: Colors.black.withOpacity(0.3), offset: const Offset(0, 2), blurRadius: 4)],
                  ),
                  textAlign: TextAlign.center,
                ),
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 300), duration: const Duration(milliseconds: 500))
              .slideY(begin: 0.3, end: 0, delay: const Duration(milliseconds: 300), duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic),

          const SizedBox(height: 12),

          // Enhanced Description with better styling
          Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  description,
                  style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white.withOpacity(0.95), height: 1.5, fontSize: 16, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 500), duration: const Duration(milliseconds: 500))
              .slideY(begin: 0.2, end: 0, delay: const Duration(milliseconds: 500), duration: const Duration(milliseconds: 500), curve: Curves.easeOutCubic),

          const SizedBox(height: 24),

          // Enhanced action hint
          Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.touch_app_rounded, color: Colors.white.withOpacity(0.9), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      'Tap anywhere to continue',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.white.withOpacity(0.9), fontWeight: FontWeight.w500, fontSize: 13),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(delay: const Duration(milliseconds: 700), duration: const Duration(milliseconds: 400))
              .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1), delay: const Duration(milliseconds: 700), duration: const Duration(milliseconds: 400), curve: Curves.elasticOut),
        ],
      ),
    );
  }

  void showTutorial(BuildContext context, VoidCallback onFinish, {List<String>? targetIds}) {
    final filteredTargets = targetIds == null ? targets : targets.where((t) => targetIds.contains(t.identify)).toList();
    _tutorialCoachMark = TutorialCoachMark(
      targets: filteredTargets,
      colorShadow: Colors.black.withOpacity(0.7),
      textSkip: "Skip Tutorial",
      paddingFocus: 8,
      opacityShadow: 0.8,
      onFinish: () {
        onFinish();
        return true;
      },
      onSkip: () {
        onFinish();
        return true;
      },
    );
    _tutorialCoachMark!.show(context: context);
  }

  void dispose() {
    _tutorialCoachMark?.finish();
    _tutorialCoachMark = null;
    targets.clear();
  }
}
