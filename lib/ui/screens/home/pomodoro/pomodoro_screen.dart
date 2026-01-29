import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../models/pomodoro_template_model.dart';
import '../../../../models/task.dart';
import '../../../../services/app_logging_service.dart';
import '../../../../services/localization_service.dart';
import '../../../../services/notification_service.dart';
import '../../../../services/pomodoro_service.dart';
import '../../../../services/pomodoro_service_locator.dart';
import 'pomodoro_template_screen.dart';

class PomodoroScreen extends StatefulWidget {
  final Task? initialTask;
  final PomodoroTemplate? template;
  final VoidCallback? onTimerStopped;

  const PomodoroScreen({super.key, this.initialTask, this.template, this.onTimerStopped});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();
}

class _PomodoroScreenState extends State<PomodoroScreen> with TickerProviderStateMixin {
  late final AnimationController _controller;
  late PomodoroTimer _timer;
  late PomodoroTemplate _currentTemplate;

  bool _showCelebration = false;
  int _completedSessions = 0;
  int _workTimeMinutes = 0;
  int _breakTimeMinutes = 0;
  DateTime? _startTime;
  DateTime? _workStartTime;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(seconds: 1), vsync: this);

    // Initialize services
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocalizationService.initialize(context);
    });

    // Initialize PomodoroServiceLocator if not already done
    if (PomodoroServiceLocator.taskRepository == null) {
      PomodoroServiceLocator.initialize();
    }

    // Use provided template or default
    _currentTemplate = widget.template ?? PomodoroTemplate(id: 'classic', name: 'Classic', workDuration: 25, restDuration: 5, longRestDuration: 15, cycles: 4, recommendedFor: 'normal');

    // Initialize timer with template
    _initializeTimer();

    // Initialize focus mode
    _initializeFocusMode();
    _timer.start();
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.dispose();
    super.dispose();
  }

  Future<void> _initializeTimer() async {
    AppLogging.logInfo('_initializeTimer called with template: ${_currentTemplate.name}');
    AppLogging.logInfo('Session settings - Work: ${_currentTemplate.workDuration}min, Rest: ${_currentTemplate.restDuration}min, Long Rest: ${_currentTemplate.longRestDuration}min, Cycles: ${_currentTemplate.cycles}');

    _timer = PomodoroServiceLocator.createTimer(
      session: PomodoroSession(workDuration: _currentTemplate.workDuration, shortBreakDuration: _currentTemplate.restDuration, longBreakDuration: _currentTemplate.longRestDuration, sessionsUntilLongBreak: _currentTemplate.cycles),
    );

    // Mark that we're using a custom template (disables adaptive timing)
    _timer.setUsingCustomTemplate(true);

    // Initialize the timer
    await _timer.initialize();

    // Set initial task if provided
    if (widget.initialTask != null) {
      _timer.setSelectedTask(widget.initialTask);
    }

    // Setup timer listeners
    _timer.addListener(_onTimerChanged);

    // Start animation
    _controller.repeat();
  }

  void _initializeFocusMode() {
    // Focus mode initialization disabled for now
    // TODO: Implement focus mode integration when available
  }

  void _onTimerChanged() {
    if (mounted) {
      setState(() {
        // Debug logging to track timer state changes
        AppLogging.logInfo('Timer state: ${_timer.state}, currentSession: ${_timer.currentSession}, completedSessions: ${_timer.completedSessions}');

        // Update our local tracking variables
        _completedSessions = _timer.completedSessions;
        _workTimeMinutes = _completedSessions * _currentTemplate.workDuration;
        _breakTimeMinutes = _completedSessions * _currentTemplate.restDuration;

        // Check if all cycles are completed when a work session just finished
        if (_timer.state == PomodoroState.shortBreak || _timer.state == PomodoroState.longBreak) {
          AppLogging.logInfo('Work session completed. Total completed: $_completedSessions/${_currentTemplate.cycles}');

          // Check if all cycles are completed
          if (_completedSessions >= _currentTemplate.cycles) {
            AppLogging.logInfo('All cycles completed! Showing dialog.');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _showCyclesCompleteDialog();
            });
          }
        }
      });
    }
  }

  void _showCyclesCompleteDialog() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? colorScheme.surface : Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(Icons.celebration, color: Colors.amber, size: 28),
              const SizedBox(width: 12),
              Text(
                l10n.greatJobCompleting,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: isDark ? colorScheme.onSurface : Colors.black87),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You\'ve completed all ${_currentTemplate.cycles} ${l10n.cycles} of the ${_currentTemplate.name} template!', style: TextStyle(fontSize: 16, color: isDark ? colorScheme.onSurface : Colors.black87)),
              const SizedBox(height: 8),
              Text('Total ${l10n.focus} time: ${_workTimeMinutes} ${l10n.minutes}', style: TextStyle(fontSize: 14, color: isDark ? colorScheme.onSurfaceVariant : Colors.grey[600])),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _stopTimer(); // Stop the timer completely
              },
              child: Text(
                l10n.stop,
                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartCycles(); // Restart the cycles
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text(l10n.reset),
            ),
          ],
        );
      },
    );
  }

  void _restartCycles() {
    // Reset completed sessions and restart the timer
    setState(() {
      _completedSessions = 0;
      _workTimeMinutes = 0;
      _breakTimeMinutes = 0;
    });
    _timer.stop();
    // Timer will be ready to start again with fresh cycles
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context)!;
    return ChangeNotifierProvider.value(
      value: _timer,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        /* appBar: AppBar(
          title: Text(_getAppBarTitle()),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.white,
          actions: [IconButton(icon: const Icon(Icons.settings), onPressed: () => _showSettings())],
        ), */
        body: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: _getBackgroundColors(_timer.effectiveState)),
              ),
            ),

            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // Integrated header with task and template info
                      _buildIntegratedHeader(),

                      const SizedBox(height: 32),

                      // Main timer display with enhanced design
                      _buildEnhancedTimerDisplay(l10n),

                      const SizedBox(height: 40),

                      // Quick actions row
                      _buildQuickActionsRow(),

                      const SizedBox(height: 32),

                      // Session progress and stats
                      _buildSessionProgressSection(),

                      const SizedBox(height: 24),

                      // Bottom controls area
                      _buildBottomControlsArea(),
                    ],
                  ),
                ),
              ),
            ),

            // Session completion celebration overlay
            if (_showCelebration) ...[
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(child: Icon(Icons.celebration, size: 100, color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Builds an integrated header combining task and template information
  Widget _buildIntegratedHeader() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: isDark ? [colorScheme.surfaceContainer.withValues(alpha: 0.9), colorScheme.surfaceContainer.withValues(alpha: 0.7)] : [Colors.white.withValues(alpha: 0.95), Colors.white.withValues(alpha: 0.8)]),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isDark ? colorScheme.outline.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1), width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task section (if available)
            if (widget.initialTask != null) ...[_buildTaskSection(), const SizedBox(height: 16), Container(height: 1, color: isDark ? colorScheme.outline.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1)), const SizedBox(height: 16)],

            // Template section
            _buildCompactTemplateSection(),
          ],
        ),
      ),
    );
  }

  /// Builds the task section of the integrated header
  Widget _buildTaskSection() {
    final l10n = AppLocalizations.of(context)!;
    final task = widget.initialTask!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: _getTaskPriorityColor(task.priority).withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
              child: Icon(_getTaskIcon(task), color: _getTaskPriorityColor(task.priority), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          task.title,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: isDark ? colorScheme.onSurface : Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getTaskPriorityColor(task.priority).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _getTaskPriorityColor(task.priority).withValues(alpha: 0.3), width: 1),
                        ),
                        child: Text(
                          task.priority.name.toUpperCase(),
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: _getTaskPriorityColor(task.priority)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      if (task.dueDate != null) ...[
                        Icon(Icons.calendar_today, size: 14, color: _getDueDateColor(task.dueDate!)),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(task.dueDate!),
                          style: TextStyle(fontSize: 12, color: _getDueDateColor(task.dueDate!), fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 16),
                      ],
                      if (task.subtasks.isNotEmpty) ...[
                        Icon(Icons.checklist, size: 14, color: Colors.blue),
                        const SizedBox(width: 4),
                        Text(
                          '${task.subtasks.where((st) => st.isCompleted).length}/${task.subtasks.length}',
                          style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(width: 16),
                      ],
                      Icon(Icons.psychology, size: 14, color: _getFocusScoreColor(task.focusScore)),
                      const SizedBox(width: 4),
                      Text(
                        '${l10n.focus} ${task.focusScore}/10',
                        style: TextStyle(fontSize: 12, color: _getFocusScoreColor(task.focusScore), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (task.description != null && task.description!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            task.description!,
            style: TextStyle(fontSize: 13, color: isDark ? colorScheme.onSurfaceVariant : Colors.grey[600], height: 1.4),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
        if (task.tags.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: task.tags
                .take(3)
                .map(
                  (tag) => Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      '#$tag',
                      style: TextStyle(fontSize: 10, color: isDark ? Colors.grey[300] : Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }

  /// Builds the compact template section
  Widget _buildCompactTemplateSection() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: _getTemplateColor().withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
          child: Icon(_getTemplateIcon(), color: _getTemplateColor(), size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _currentTemplate.name,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? colorScheme.onSurface : Colors.black87),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (_currentTemplate.recommendedFor == 'adhd')
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.purple.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.purple.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.purple[600], size: 12),
                          const SizedBox(width: 4),
                          Text(
                            l10n.recommendedForAdhd,
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.purple[600]),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(_getTemplateTypeLabel(), style: TextStyle(fontSize: 12, color: isDark ? colorScheme.onSurfaceVariant : Colors.grey[600])),
            ],
          ),
        ),
        // Quick stats
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${_currentTemplate.workDuration}${l10n.minutes}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? colorScheme.onSurface : Colors.black87),
            ),
            Text('${_currentTemplate.cycles} ${l10n.cycles}', style: TextStyle(fontSize: 11, color: isDark ? colorScheme.onSurfaceVariant : Colors.grey[600])),
          ],
        ),
      ],
    );
  }

  /// Builds an enhanced timer display with modern circular design
  Widget _buildEnhancedTimerDisplay(l10n) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate a reasonable size for the timer based on available space
        final timerSize = constraints.maxWidth * 0.7; // Use 70% of available width
        final maxTimerSize = 280.0; // Maximum size to prevent it from being too large
        final finalSize = timerSize > maxTimerSize ? maxTimerSize : timerSize;

        return SizedBox(
          width: finalSize,
          height: finalSize,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: isDark ? [colorScheme.surfaceContainer.withValues(alpha: 0.8), colorScheme.surfaceContainer.withValues(alpha: 0.6)] : [Colors.white.withValues(alpha: 0.9), Colors.white.withValues(alpha: 0.7)]),
              borderRadius: BorderRadius.circular(200),
              border: Border.all(color: isDark ? colorScheme.outline.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1), width: 2),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 30, offset: const Offset(0, 15))],
            ),
            child: Stack(
              children: [
                // Background circle
                Positioned.fill(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: isDark ? colorScheme.surface.withValues(alpha: 0.5) : Colors.grey.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(180)),
                  ),
                ),

                // Progress ring
                Positioned.fill(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: CircularProgressIndicator(
                      value: _timer.state == PomodoroState.idle ? 1.0 : _timer.remainingSeconds / (_currentTemplate.workDuration * 60),
                      strokeWidth: 8,
                      backgroundColor: isDark ? colorScheme.surfaceContainer.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(_getTimerColor(_timer.effectiveState)),
                    ),
                  ),
                ),

                // Timer content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Session type
                      Text(
                        _getSessionTypeLabel(),
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? colorScheme.onSurfaceVariant : Colors.grey[600], letterSpacing: 1.2),
                      ),

                      const SizedBox(height: 8),

                      // Time display
                      Text(
                        _formatTime(_timer.remainingSeconds),
                        style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300, color: isDark ? colorScheme.onSurface : Colors.black87, fontFeatures: const [FontFeature.tabularFigures()]),
                      ),

                      const SizedBox(height: 8),

                      // Session progress
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.repeat, size: 16, color: isDark ? colorScheme.onSurfaceVariant : Colors.grey[600]),
                          const SizedBox(width: 4),
                          Text('${l10n.session} ${_timer.currentSession}/${_currentTemplate.cycles}', style: TextStyle(fontSize: 12, color: isDark ? colorScheme.onSurfaceVariant : Colors.grey[600])),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Builds quick actions row with primary controls
  Widget _buildQuickActionsRow() {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildQuickActionButton(icon: Icons.remove, label: '-5 min', onTap: () => _adjustTime(-5), color: Colors.red),
        _buildQuickActionButton(icon: Icons.add, label: '+5 min', onTap: () => _adjustTime(5), color: Colors.green),
        _buildQuickActionButton(icon: Icons.skip_next, label: l10n.skip, onTap: () => _skipCurrentSession(), color: Colors.orange),
        // Debug button to test dialog
        // _buildQuickActionButton(icon: Icons.celebration, label: 'Test', onTap: () => _showCyclesCompleteDialog(), color: Colors.purple),
      ],
    );
  }

  /// Builds individual quick action button
  Widget _buildQuickActionButton({required IconData icon, required String label, required VoidCallback onTap, required Color color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds session progress and statistics section
  Widget _buildSessionProgressSection() {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainer.withValues(alpha: 0.8) : Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? colorScheme.outline.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.1), width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.sessionProgress,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? colorScheme.onSurface : Colors.black87),
              ),
              Text('$_completedSessions/${_currentTemplate.cycles} ${l10n.completed}', style: TextStyle(fontSize: 12, color: isDark ? colorScheme.onSurfaceVariant : Colors.grey[600])),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: _completedSessions / _currentTemplate.cycles, backgroundColor: isDark ? colorScheme.surfaceContainer.withValues(alpha: 0.3) : Colors.grey.withValues(alpha: 0.2), valueColor: AlwaysStoppedAnimation<Color>(_getTimerColor(_timer.effectiveState))),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [_buildStatItem('${l10n.focus} Time', '${_workTimeMinutes} ${l10n.minutes}', Icons.work), _buildStatItem(l10n.breakTime, '${_breakTimeMinutes} ${l10n.minutes}', Icons.coffee), _buildStatItem(l10n.minsTotal, '${_workTimeMinutes + _breakTimeMinutes} ${l10n.minutes}', Icons.schedule)],
          ),
        ],
      ),
    );
  }

  /// Builds individual stat item
  Widget _buildStatItem(String label, String value, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(icon, size: 20, color: isDark ? colorScheme.onSurfaceVariant : Colors.grey[600]),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: isDark ? colorScheme.onSurface : Colors.black87),
        ),
        Text(label, style: TextStyle(fontSize: 10, color: isDark ? colorScheme.onSurfaceVariant : Colors.grey[600])),
      ],
    );
  }

  /// Builds bottom controls area
  Widget _buildBottomControlsArea() {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        // Primary action button
        Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _getTimerColor(_timer.effectiveState) == Colors.blue
                  ? [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]
                  : _getTimerColor(_timer.effectiveState) == Colors.green
                  ? [const Color(0xFF10B981), const Color(0xFF34D399)]
                  : [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)],
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: _getTimerColor(_timer.effectiveState).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(28),
              onTap: _toggleTimer,
              child: Center(
                child: Text(
                  _getPrimaryActionLabel(),
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Secondary actions
        Row(
          children: [
            Expanded(
              child: _buildSecondaryButton(icon: Icons.refresh, label: l10n.reset, onTap: _resetTimer),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSecondaryButton(icon: Icons.stop, label: l10n.stop, onTap: _stopTimer),
            ),
          ],
        ),
      ],
    );
  }

  /// Builds secondary action button
  Widget _buildSecondaryButton({required IconData icon, required String label, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainer.withValues(alpha: 0.8) : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? colorScheme.outline.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.2), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: isDark ? colorScheme.onSurfaceVariant : Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(color: isDark ? colorScheme.onSurfaceVariant : Colors.grey[600], fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Color> _getBackgroundColors(PomodoroState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    switch (state) {
      case PomodoroState.work:
        return isDark ? [colorScheme.primary.withValues(alpha: 0.8), colorScheme.primaryContainer.withValues(alpha: 0.6)] : [const Color(0xFF3B82F6), const Color(0xFF60A5FA)];
      case PomodoroState.shortBreak:
        return isDark ? [colorScheme.secondary.withValues(alpha: 0.8), colorScheme.secondaryContainer.withValues(alpha: 0.6)] : [const Color(0xFF10B981), const Color(0xFF34D399)];
      case PomodoroState.longBreak:
        return isDark ? [colorScheme.tertiary.withValues(alpha: 0.8), colorScheme.tertiaryContainer.withValues(alpha: 0.6)] : [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)];
      case PomodoroState.idle:
        return isDark ? [colorScheme.surface.withValues(alpha: 0.9), colorScheme.surfaceContainer.withValues(alpha: 0.7)] : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
      default:
        return isDark ? [colorScheme.primary.withValues(alpha: 0.8), colorScheme.primaryContainer.withValues(alpha: 0.6)] : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
    }
  }

  Color _getTimerColor(PomodoroState state) {
    switch (state) {
      case PomodoroState.work:
        return Colors.blue;
      case PomodoroState.shortBreak:
        return Colors.green;
      case PomodoroState.longBreak:
        return Colors.purple;
      case PomodoroState.idle:
        return Colors.grey;
      default:
        return Colors.blue;
    }
  }

  String _getSessionTypeLabel() {
    final l10n = AppLocalizations.of(context)!;

    switch (_timer.effectiveState) {
      case PomodoroState.work:
        return '${l10n.focus} TIME';
      case PomodoroState.shortBreak:
        return l10n.shortBreak;
      case PomodoroState.longBreak:
        return l10n.longBreak;
      case PomodoroState.idle:
        return 'READY';
      case PomodoroState.paused:
        return l10n.paused;
    }
  }

  String _getPrimaryActionLabel() {
    final l10n = AppLocalizations.of(context)!;

    switch (_timer.state) {
      case PomodoroState.idle:
        return l10n.startSession;
      case PomodoroState.work:
      case PomodoroState.shortBreak:
      case PomodoroState.longBreak:
        return l10n.pause;
      case PomodoroState.paused:
        return l10n.resume;
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  // Action methods
  void _toggleTimer() {
    switch (_timer.state) {
      case PomodoroState.idle:
        _timer.start();
        break;
      case PomodoroState.work:
      case PomodoroState.shortBreak:
      case PomodoroState.longBreak:
        _timer.pause();
        break;
      case PomodoroState.paused:
        _timer.start();
        break;
    }
  }

  void _adjustTime(int minutes) {
    if (_timer.state != PomodoroState.idle) {
      _timer.addTime(minutes);
    }
  }

  void _skipCurrentSession() {
    _timer.skip();
  }

  void _resetTimer() {
    _timer.stop();
    setState(() {
      _completedSessions = 0;
      _workTimeMinutes = 0;
      _breakTimeMinutes = 0;
    });
  }

  void _stopTimer() {
    _showStopConfirmation();
  }

  void _showStopConfirmation() {
    final l10n = AppLocalizations.of(context)!;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.stopPomodoroTimer),
        content: Text(l10n.areYouSureYouWantToStopTheCurrentSession),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              _timer.stop();
              widget.onTimerStopped?.call();
              // Removed extra pop - don't close the screen automatically
            },
            child: Text(l10n.stop, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Helper methods for task and template
  IconData _getTaskIcon(Task task) {
    if (task.subtasks.isNotEmpty) return Icons.checklist;
    if (task.tags.contains('urgent')) return Icons.priority_high;
    if (task.tags.contains('meeting')) return Icons.groups;
    if (task.tags.contains('study')) return Icons.school;
    if (task.tags.contains('work')) return Icons.work;
    return Icons.task;
  }

  Color _getTaskPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.low:
        return Colors.green;
    }
  }

  Color _getDueDateColor(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) return Colors.red; // Overdue
    if (difference.inDays == 0) return Colors.orange; // Today
    if (difference.inDays <= 1) return Colors.yellow; // Tomorrow
    return Colors.green; // Future
  }

  Color _getFocusScoreColor(int focusScore) {
    if (focusScore >= 8) return Colors.green;
    if (focusScore >= 6) return Colors.blue;
    if (focusScore >= 4) return Colors.orange;
    return Colors.red;
  }

  String _formatDate(DateTime date) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(date.year, date.month, date.day);

    if (taskDate == today) return l10n.today;
    if (taskDate == today.add(const Duration(days: 1))) return l10n.tomorrow;
    if (taskDate == today.subtract(const Duration(days: 1))) return l10n.yesterday;

    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getTemplateColor() {
    if (_currentTemplate.recommendedFor == 'adhd') return Colors.purple;
    if (_currentTemplate.recommendedFor == 'normal') return Colors.blue;
    if (_currentTemplate.isCustom) return Colors.orange;
    return Colors.grey;
  }

  IconData _getTemplateIcon() {
    if (_currentTemplate.recommendedFor == 'adhd') return Icons.auto_awesome;
    if (_currentTemplate.recommendedFor == 'normal') return Icons.schedule;
    if (_currentTemplate.isCustom) return Icons.edit;
    return Icons.timer;
  }

  String _getTemplateTypeLabel() {
    final l10n = AppLocalizations.of(context)!;

    if (_currentTemplate.recommendedFor == 'adhd') return l10n.recommendedForAdhd;
    if (_currentTemplate.recommendedFor == 'normal') return l10n.classicPreset;
    if (_currentTemplate.isCustom) return l10n.custom;
    return l10n.generalSettings;
  }
}
