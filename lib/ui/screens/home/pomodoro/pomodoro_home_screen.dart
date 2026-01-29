import 'package:flutter/material.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'pomodoro_template_screen.dart';
import 'pomodoro_screen.dart';
import '../../../../models/pomodoro_template_model.dart';

class PomodoroHomeScreen extends StatefulWidget {
  final Task? initialTask;

  const PomodoroHomeScreen({super.key, this.initialTask});

  @override
  State<PomodoroHomeScreen> createState() => _PomodoroHomeScreenState();
}

class _PomodoroHomeScreenState extends State<PomodoroHomeScreen> {
  PomodoroTemplate? selectedTemplate;
  bool showTimer = false;

  void _handleTimerStopped() {
    setState(() {
      showTimer = false;
      selectedTemplate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  backgroundColor: const Color(0xFFF8F9FA),
      body: showTimer
          ? PomodoroScreen(
              initialTask: widget.initialTask,
              template: selectedTemplate!,
              onTimerStopped: _handleTimerStopped,
              /* showNavigation: false */
            )
          : _buildHomeContent(),
    );
  }

  Widget _buildHomeContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(60)),
            child: Icon(Icons.timer, color: Colors.blue[600], size: 60),
          ),
          const SizedBox(height: 24),
          Text(AppLocalizations.of(context)!.pomodoroTimer, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold /*  color: Colors.black87 */)),
          const SizedBox(height: 12),
          Text(AppLocalizations.of(context)!.startAFocusedWorkSession, style: TextStyle(fontSize: 16, color: Colors.grey[600])),
          const SizedBox(height: 48),
          Container(
            width: 200,
            height: 56,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(28),
                onTap: () async {
                  if (widget.initialTask != null) {
                    final task = widget.initialTask!;

                    // Create a custom template for the initial task using task-specific settings
                    final customTemplate = PomodoroTemplate(
                      id: 'custom_${task.id}',
                      name: task.title,
                      workDuration: task.estimatedDuration.inMinutes > 0 ? task.estimatedDuration.inMinutes : 25,
                      restDuration: 5,
                      longRestDuration: 15,
                      cycles: task.estimatedSessions > 0 ? task.estimatedSessions : 4,
                      recommendedFor: 'task_specific',
                      isCustom: true,
                    );

                    setState(() {
                      selectedTemplate = customTemplate;
                      showTimer = true;
                    });
                  } else {
                    // Show template selection modal for regular usage
                    final template = await PomodoroTemplateScreen.showAsModal(context, initialTask: widget.initialTask);

                    // If user selected a template, show timer inline
                    if (template != null) {
                      setState(() {
                        selectedTemplate = template;
                        showTimer = true;
                      });
                    }
                  }
                },
                child: Center(
                  child: Text(
                    AppLocalizations.of(context)!.startSession,
                    style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
