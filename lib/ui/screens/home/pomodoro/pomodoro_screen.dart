import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart' show ChangeNotifierProvider;
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';
import 'package:tazbeet/services/app_logging_service.dart';
import 'package:tazbeet/services/pomodoro_service.dart';
import 'package:tazbeet/models/pomodoro_template_model.dart';

import '../../../../services/localization_service.dart';
import '../../../../services/pomodoro_service_locator.dart';

// Session completion celebration
class _SessionCompletionCelebration extends StatefulWidget {
  final VoidCallback onDismiss;

  const _SessionCompletionCelebration({required this.onDismiss});

  @override
  State<_SessionCompletionCelebration> createState() => _SessionCompletionCelebrationState();
}

class _SessionCompletionCelebrationState extends State<_SessionCompletionCelebration> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut));

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();

    // Auto dismiss after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (mounted) widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Center(
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.celebration, size: 48, color: Colors.green),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.sessionComplete,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    const SizedBox(height: 8),
                    Text(AppLocalizations.of(context)!.greatJobTakeABreak, style: TextStyle(fontSize: 16, color: Colors.black54)),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Animated button with accessibility
class _AnimatedButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final String? semanticLabel;

  const _AnimatedButton({required this.child, required this.onTap, this.semanticLabel});

  @override
  State<_AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<_AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 150), vsync: this);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticLabel,
      child: GestureDetector(
        onTapDown: (_) => _controller.forward(),
        onTapUp: (_) {
          _controller.reverse();
          widget.onTap();
        },
        onTapCancel: () => _controller.reverse(),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(scale: _scaleAnimation.value, child: child);
          },
          child: widget.child,
        ),
      ),
    );
  }
}

class PomodoroScreen extends StatefulWidget {
  final Task? initialTask;
  final PomodoroTemplate? template;
  final VoidCallback? onTimerStopped;

  const PomodoroScreen({super.key, this.initialTask, this.template, this.onTimerStopped});

  @override
  State<PomodoroScreen> createState() => _PomodoroScreenState();

  // Static method to show as modal page
  static Future<void> showAsPage(BuildContext context, {Task? initialTask, PomodoroTemplate? template}) {
    AppLogging.logInfo('PomodoroScreen: Starting navigation to timer screen', name: 'PomodoroNavigation');
    AppLogging.logInfo('PomodoroScreen: Navigation stack depth before push: ${Navigator.of(context).canPop() ? "has back stack" : "no back stack"}', name: 'PomodoroNavigation');

    return Navigator.of(context)
        .push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => PomodoroScreen(initialTask: initialTask, template: template),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(0.0, 1.0);
              const end = Offset.zero;
              const curve = Curves.ease;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

              return SlideTransition(position: animation.drive(tween), child: child);
            },
          ),
        )
        .then((_) {
          AppLogging.logInfo('PomodoroScreen: Returned from timer screen', name: 'PomodoroNavigation');
        });
  }
}

class _PomodoroScreenState extends State<PomodoroScreen> with TickerProviderStateMixin, WidgetsBindingObserver {
  late PomodoroTimer _timer;
  late PomodoroTemplate _currentTemplate;

  // Statistics data
  int _completedSessions = 0;
  int _workTimeMinutes = 0;
  int _breakTimeMinutes = 0;

  // Celebration state
  bool _showCelebration = false;
  PomodoroState _lastState = PomodoroState.idle;

  @override
  void initState() {
    super.initState();

    // Add lifecycle observer for state restoration
    WidgetsBinding.instance.addObserver(this);

    // Initialize services
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocalizationService.initialize(context);
    });

    // Initialize PomodoroServiceLocator if not already done
    if (PomodoroServiceLocator.taskRepository == null) {
      PomodoroServiceLocator.initialize();
    }

    // Use provided template or default
    _currentTemplate = widget.template ?? PomodoroTemplate(id: 'classic', name: AppLocalizations.of(context)!.classicPreset, workDuration: 25, restDuration: 5, longRestDuration: 15, cycles: 4, recommendedFor: 'normal');

    // Log template info for debugging
    if (widget.template != null) {
      AppLogging.logInfo('PomodoroScreen received template: ${widget.template!.name} - Work: ${widget.template!.workDuration}min, Rest: ${widget.template!.restDuration}min');
    } else {
      AppLogging.logInfo('PomodoroScreen received no template, using default: ${_currentTemplate.name}');
    }

    // Initialize timer with template (async)
    _initializeTimer();
  }

  @override
  void dispose() {
    AppLogging.logInfo('PomodoroScreen: Disposing - saving state', name: 'PomodoroNavigation');
    _saveTimerState();
    WidgetsBinding.instance.removeObserver(this);
    _timer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        AppLogging.logInfo('PomodoroScreen: App paused - saving timer state', name: 'PomodoroNavigation');
        _saveTimerState();
        break;
      case AppLifecycleState.resumed:
        AppLogging.logInfo('PomodoroScreen: App resumed - checking for state restoration', name: 'PomodoroNavigation');
        _restoreTimerState();
        break;
      case AppLifecycleState.detached:
        AppLogging.logInfo('PomodoroScreen: App detached - cleaning up', name: 'PomodoroNavigation');
        _saveTimerState();
        break;
      default:
        break;
    }
  }

  void _saveTimerState() {
    try {
      // Save current timer state (simplified version)
      final timerState = {
        'remainingSeconds': _timer.remainingSeconds,
        'currentState': _timer.state.toString(),
        'completedSessions': _completedSessions,
        'workTimeMinutes': _workTimeMinutes,
        'breakTimeMinutes': _breakTimeMinutes,
        'templateId': _currentTemplate.id,
        'timestamp': DateTime.now().toIso8601String(),
      };

      // In a real implementation, you would save this to SharedPreferences or similar
      AppLogging.logInfo('PomodoroScreen: Timer state saved: ${timerState['remainingSeconds']}s remaining', name: 'PomodoroNavigation');
    } catch (e) {
      AppLogging.logError('PomodoroScreen: Error saving timer state: $e', name: 'PomodoroNavigation');
    }
  }

  void _restoreTimerState() {
    try {
      // In a real implementation, you would load this from SharedPreferences
      // For now, we'll just log that restoration would happen here
      AppLogging.logInfo('PomodoroScreen: Timer state restoration would happen here', name: 'PomodoroNavigation');

      // Example restoration logic (commented out for now):
      /*
      final savedState = await _loadTimerState();
      if (savedState != null && _isStateValid(savedState)) {
        // Restore timer state
        _timer.restoreFromState(savedState);
        _completedSessions = savedState['completedSessions'] ?? 0;
        _workTimeMinutes = savedState['workTimeMinutes'] ?? 0;
        _breakTimeMinutes = savedState['breakTimeMinutes'] ?? 0;
        
        AppLogging.logInfo('PomodoroScreen: Timer state restored successfully', name: 'PomodoroNavigation');
      }
      */
    } catch (e) {
      AppLogging.logError('PomodoroScreen: Error restoring timer state: $e', name: 'PomodoroNavigation');
    }
  }

  void _initializeTimer() async {
    AppLogging.logInfo('_initializeTimer called with template: ${_currentTemplate.name}');
    AppLogging.logInfo('Session settings - Work: ${_currentTemplate.workDuration}min, Rest: ${_currentTemplate.restDuration}min, Long Rest: ${_currentTemplate.longRestDuration}min, Cycles: ${_currentTemplate.cycles}');

    _timer = PomodoroServiceLocator.createTimer(
      session: PomodoroSession(
        workDuration: _currentTemplate.workDuration,
        shortBreakDuration: _currentTemplate.restDuration,
        longBreakDuration: _currentTemplate.longRestDuration,
        sessionsUntilLongBreak: _currentTemplate.cycles,
      ),
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
    _timer.addListener(() {
      if (mounted) {
        // Check for state transitions that should trigger celebration
        if (_timer.state != _lastState) {
          // Celebration when transitioning from work to break
          if (_lastState == PomodoroState.work && (_timer.state == PomodoroState.shortBreak || _timer.state == PomodoroState.longBreak)) {
            _showCelebration = true;
            _updateStatistics();
          }
          _lastState = _timer.state;
        }
        setState(() {});
      }
    });

    // Auto-start the timer when screen opens
    _timer.start();
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  String _getStateLabel() {
    final l10n = AppLocalizations.of(context)!;
    switch (_timer.effectiveState) {
      case PomodoroState.work:
        return l10n.work;
      case PomodoroState.shortBreak:
        return l10n.shortBreak;
      case PomodoroState.longBreak:
        return l10n.longBreak;
      case PomodoroState.idle:
      default:
        return l10n.work;
    }
  }

  void _adjustTime(int minutes) {
    // Adjust the current session duration
    if (_timer.state != PomodoroState.idle) {
      if (minutes > 0) {
        _timer.addTime(minutes);
      } else {
        _timer.subtractTime(minutes.abs());
      }
      HapticFeedback.lightImpact();
    }
  }

  void _showStopConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)!.stopSession,
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
          ),
          content: Text(AppLocalizations.of(context)!.areYouSureYouWantToStopTheCurrentSession, style: TextStyle(color: Colors.black54)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text(
                AppLocalizations.of(context)!.cancel,
                style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w500),
              ),
            ),

            TextButton(
              onPressed: () {
                AppLogging.logInfo('PomodoroScreen: Stop timer requested', name: 'PomodoroNavigation');

                try {
                  // Close dialog first
                  Navigator.of(context).pop();

                  // Stop timer and update statistics
                  _timer.stop();
                  _updateStatistics();

                  // Call the callback to notify parent screen
                  widget.onTimerStopped?.call();

                  // Then pop back to the previous screen
                  Navigator.of(context).pop();
                  AppLogging.logInfo('PomodoroScreen: Timer stopped and returned to previous screen', name: 'PomodoroNavigation');
                } catch (e) {
                  AppLogging.logError('Error during timer exit: $e', name: 'PomodoroNavigation');
                  // Fallback to simple pop if something fails
                  try {
                    Navigator.of(context).pop();
                  } catch (e2) {
                    AppLogging.logError('Fallback navigation also failed: $e2', name: 'PomodoroNavigation');
                  }
                }
              },
              child: Text(
                AppLocalizations.of(context)!.stop,
                style: TextStyle(color: Colors.red[600], fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  void _updateStatistics() {
    // Update statistics when sessions complete
    if (_timer.state == PomodoroState.idle && _timer.currentSession > 0) {
      setState(() {
        _completedSessions = _timer.currentSession - 1;
        _workTimeMinutes = _completedSessions * _currentTemplate.workDuration;
        _breakTimeMinutes = _completedSessions * _currentTemplate.restDuration;
      });
    }
  }

  List<Color> _getBackgroundColors(PomodoroState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    switch (state) {
      case PomodoroState.work:
        return isDark ? [colorScheme.primary.withOpacity(0.8), colorScheme.primaryContainer.withOpacity(0.6)] : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
      case PomodoroState.shortBreak:
        return isDark ? [colorScheme.secondary.withOpacity(0.8), colorScheme.secondaryContainer.withOpacity(0.6)] : [const Color(0xFF10B981), const Color(0xFF34D399)];
      case PomodoroState.longBreak:
        return isDark ? [colorScheme.tertiary.withOpacity(0.8), colorScheme.tertiaryContainer.withOpacity(0.6)] : [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)];
      case PomodoroState.idle:
        return isDark ? [colorScheme.surface.withOpacity(0.9), colorScheme.surfaceContainer.withOpacity(0.7)] : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
      default:
        return isDark ? [colorScheme.primary.withOpacity(0.8), colorScheme.primaryContainer.withOpacity(0.6)] : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _timer,
      child: Scaffold(
        body: Stack(
          children: [
            // Background gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: _getBackgroundColors(_timer.effectiveState)),
              ),
            ),

            // Main content - restructured layout
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    // Session type label
                    const SizedBox(height: 20),
                    _buildSessionTypeLabel(),

                    const SizedBox(height: 40),

                    // Timer with time adjustment buttons
                    _buildTimerWithAdjustments(),

                    const SizedBox(height: 40),

                    // Primary action button
                    _buildPrimaryActionButton(),

                    const SizedBox(height: 24),

                    // Secondary action buttons
                    _buildSecondaryActionButtons(),

                    const SizedBox(height: 20),

                    // Progress bar (minimal)
                    _buildMinimalProgressBar(),

                    const SizedBox(height: 32),

                    // Statistics section (compact)
                    Expanded(child: _buildCompactStatistics()),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Session completion celebration overlay
            if (_showCelebration)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                  child: _SessionCompletionCelebration(
                    onDismiss: () {
                      setState(() {
                        _showCelebration = false;
                      });
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // New UI methods according to plan

  Widget _buildSessionTypeLabel() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      _getStateLabel(),
      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, color: isDark ? colorScheme.onSurface.withOpacity(0.8) : Colors.white.withOpacity(0.8)),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTimerWithAdjustments() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // -5 min button
        _buildTimeAdjustmentButton(icon: Icons.remove, label: '-5 min', onTap: () => _adjustTime(-5)),

        const SizedBox(width: 10),

        // Timer (hero element) - slightly smaller to fit
        _buildCircularTimer(),

        const SizedBox(width: 10),

        // +5 min button
        _buildTimeAdjustmentButton(icon: Icons.add, label: '+5 min', onTap: () => _adjustTime(5)),
      ],
    );
  }

  Widget _buildPrimaryActionButton() {
    final isRunning = _timer.isRunning;
    final isIdle = _timer.state == PomodoroState.idle;
    final actionLabel = isIdle ? AppLocalizations.of(context)!.resume : (isRunning ? AppLocalizations.of(context)!.pause : AppLocalizations.of(context)!.resume);
    final semanticLabel = '$actionLabel ${_timer.effectiveState == PomodoroState.work ? AppLocalizations.of(context)!.work : AppLocalizations.of(context)!.shortBreak}';

    return _AnimatedButton(
      semanticLabel: semanticLabel,
      onTap: () {
        if (isIdle) {
          _timer.start();
        } else if (isRunning) {
          _timer.pause();
        } else {
          _timer.start();
        }
      },
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isIdle ? Icons.play_arrow : (isRunning ? Icons.pause : Icons.play_arrow), color: _getBackgroundColors(_timer.effectiveState).first, size: 28),
            const SizedBox(height: 2),
            Text(
              actionLabel,
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: _getBackgroundColors(_timer.effectiveState).first),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecondaryActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Stop button
        _AnimatedButton(
          semanticLabel: '${AppLocalizations.of(context)!.stop} ${_timer.effectiveState == PomodoroState.work ? AppLocalizations.of(context)!.work : AppLocalizations.of(context)!.shortBreak}',
          onTap: () {
            _showStopConfirmation();
          },
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            child: Icon(Icons.stop, color: Colors.white.withOpacity(0.8), size: 20),
          ),
        ),

        // Skip button
        _AnimatedButton(
          semanticLabel: '${AppLocalizations.of(context)!.skip} ${_timer.effectiveState == PomodoroState.work ? AppLocalizations.of(context)!.work : AppLocalizations.of(context)!.shortBreak}',
          onTap: () {
            _timer.skip();
          },
          child: Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            ),
            child: Icon(Icons.skip_next, color: Colors.white.withOpacity(0.8), size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildMinimalProgressBar() {
    double progress = 0.0;
    if (_timer.state != PomodoroState.idle) {
      final totalSeconds = _currentTemplate.workDuration * 60;
      final elapsedSeconds = totalSeconds - _timer.remainingSeconds;
      progress = (elapsedSeconds / totalSeconds).clamp(0.0, 1.0);
    } else {
      progress = 1.0;
    }

    return Container(
      height: 8,
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
      child: Stack(
        children: [
          // Background track
          Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
          ),
          // Progress fill
          FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.white.withOpacity(0.8), Colors.white.withOpacity(0.6)]),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatistics() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface.withOpacity(0.2) : Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? colorScheme.outline.withOpacity(0.3) : Colors.white.withOpacity(0.2), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.todaysStatistics,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? colorScheme.onSurface.withOpacity(0.9) : Colors.white.withOpacity(0.9)),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCompactStatisticItem(icon: Icons.check_circle, value: '$_completedSessions'),
              _buildCompactStatisticItem(icon: Icons.work, value: '$_workTimeMinutes min'),
              _buildCompactStatisticItem(icon: Icons.coffee, value: '$_breakTimeMinutes min'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatisticItem({required IconData icon, required String value}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(icon, color: isDark ? colorScheme.onSurface.withOpacity(0.8) : Colors.white.withOpacity(0.8), size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: isDark ? colorScheme.onSurface.withOpacity(0.8) : Colors.white.withOpacity(0.8)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTimeAdjustmentButton({required IconData icon, required String label, required VoidCallback onTap}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        _AnimatedButton(
          semanticLabel: '$label ${_timer.effectiveState == PomodoroState.work ? AppLocalizations.of(context)!.work : AppLocalizations.of(context)!.shortBreak}',
          onTap: onTap,
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? colorScheme.surface.withOpacity(0.3) : Colors.white.withOpacity(0.2),
              border: Border.all(color: isDark ? colorScheme.outline.withOpacity(0.5) : Colors.white.withOpacity(0.3), width: 1),
            ),
            child: Icon(icon, color: isDark ? colorScheme.onSurface : Colors.white, size: 20),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(color: isDark ? colorScheme.onSurface.withOpacity(0.7) : Colors.white70, fontSize: 10, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildCircularTimer() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isDark ? colorScheme.surface.withOpacity(0.3) : Colors.white.withOpacity(0.2),
        border: Border.all(color: isDark ? colorScheme.outline.withOpacity(0.5) : Colors.white.withOpacity(0.3), width: 8),
      ),
      child: Stack(
        children: [
          // Progress indicator
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: CircularProgressIndicator(
                value: _timer.state == PomodoroState.idle ? 1.0 : _timer.remainingSeconds / (_currentTemplate.workDuration * 60),
                strokeWidth: 8,
                backgroundColor: Colors.transparent,
                valueColor: AlwaysStoppedAnimation<Color>(isDark ? colorScheme.onSurface.withOpacity(0.8) : Colors.white.withOpacity(0.8)),
              ),
            ),
          ),

          // Timer content (no play/pause button inside)
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _formatDuration(_timer.remainingSeconds),
                  style: TextStyle(fontSize: 44, fontWeight: FontWeight.bold, color: isDark ? colorScheme.onSurface : Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  _getStateLabel(),
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isDark ? colorScheme.onSurface.withOpacity(0.7) : Colors.white70),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
