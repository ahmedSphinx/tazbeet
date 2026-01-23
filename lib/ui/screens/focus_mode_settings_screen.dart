import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../l10n/app_localizations.dart';
import '../../services/focus_mode.dart';
import '../../services/settings_service.dart';
import '../../models/task.dart';

class FocusModeSettingsScreen extends StatefulWidget {
  const FocusModeSettingsScreen({super.key});

  @override
  State<FocusModeSettingsScreen> createState() => _FocusModeSettingsScreenState();
}

class _FocusModeSettingsScreenState extends State<FocusModeSettingsScreen> {
  bool _focusModeEnabled = false;
  bool _blockNotifications = true;
  bool _dimNonEssentialUI = true;
  bool _showOnlyTaskNotifications = true;
  bool _enableDoNotDisturb = false;
  bool _blockSocialMedia = false;
  bool _playFocusAudio = true;
  String _audioType = 'ambient';
  double _audioVolume = 0.3;
  bool _enableHapticFeedback = true;
  bool _showMotivationalQuotes = true;
  bool _enableEyeBreakReminders = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settings = await SettingsService.getFocusModeSettings();
    setState(() {
      _focusModeEnabled = settings['enabled'] ?? false;
      _blockNotifications = settings['blockNotifications'] ?? true;
      _dimNonEssentialUI = settings['dimNonEssentialUI'] ?? true;
      _showOnlyTaskNotifications = settings['showOnlyTaskNotifications'] ?? true;
      _enableDoNotDisturb = settings['enableDoNotDisturb'] ?? false;
      _blockSocialMedia = settings['blockSocialMedia'] ?? false;
      _playFocusAudio = settings['playFocusAudio'] ?? true;
      _audioType = settings['audioType'] ?? 'ambient';
      _audioVolume = settings['audioVolume'] ?? 0.3;
      _enableHapticFeedback = settings['enableHapticFeedback'] ?? true;
      _showMotivationalQuotes = settings['showMotivationalQuotes'] ?? true;
      _enableEyeBreakReminders = settings['enableEyeBreakReminders'] ?? true;
    });
  }

  Future<void> _saveSettings() async {
    final settings = {
      'enabled': _focusModeEnabled,
      'blockNotifications': _blockNotifications,
      'dimNonEssentialUI': _dimNonEssentialUI,
      'showOnlyTaskNotifications': _showOnlyTaskNotifications,
      'enableDoNotDisturb': _enableDoNotDisturb,
      'blockSocialMedia': _blockSocialMedia,
      'playFocusAudio': _playFocusAudio,
      'audioType': _audioType,
      'audioVolume': _audioVolume,
      'enableHapticFeedback': _enableHapticFeedback,
      'showMotivationalQuotes': _showMotivationalQuotes,
      'enableEyeBreakReminders': _enableEyeBreakReminders,
    };

    await SettingsService.saveFocusModeSettings(settings);

    // Apply focus mode settings
    if (_focusModeEnabled) {
      await FocusMode.enableFocusMode(customSettings: settings);
    } else if (FocusMode.isActive) {
      await FocusMode.disableFocusMode(reason: 'Settings disabled');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text('Focus Mode Settings'), backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Main Toggle
          Card(
            child: SwitchListTile(
              title: Text('Enable Focus Mode'),
              subtitle: Text('Block distractions during work sessions'),
              value: _focusModeEnabled,
              onChanged: (value) {
                setState(() {
                  _focusModeEnabled = value;
                });
                _saveSettings();
              },
              secondary: Icon(Icons.center_focus_strong),
            ),
          ),

          const SizedBox(height: 16),

          // Notification Settings
          _buildSectionHeader('Notifications'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Block Notifications'),
                  subtitle: Text('Block all non-essential notifications'),
                  value: _blockNotifications,
                  onChanged: _focusModeEnabled
                      ? (value) {
                          setState(() {
                            _blockNotifications = value;
                          });
                          _saveSettings();
                        }
                      : null,
                  secondary: Icon(Icons.notifications_off),
                ),
                const Divider(),
                SwitchListTile(
                  title: Text('Show Only Task Notifications'),
                  subtitle: Text('Allow task-related notifications only'),
                  value: _showOnlyTaskNotifications,
                  onChanged: _focusModeEnabled
                      ? (value) {
                          setState(() {
                            _showOnlyTaskNotifications = value;
                          });
                          _saveSettings();
                        }
                      : null,
                  secondary: Icon(Icons.task),
                ),
                const Divider(),
                SwitchListTile(
                  title: Text('Enable Do Not Disturb'),
                  subtitle: Text('System-wide Do Not Disturb (Android only)'),
                  value: _enableDoNotDisturb,
                  onChanged: _focusModeEnabled
                      ? (value) {
                          setState(() {
                            _enableDoNotDisturb = value;
                          });
                          _saveSettings();
                        }
                      : null,
                  secondary: Icon(Icons.do_not_disturb),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Audio Settings
          _buildSectionHeader('Audio'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Play Focus Audio'),
                  subtitle: Text('Background sounds for concentration'),
                  value: _playFocusAudio,
                  onChanged: _focusModeEnabled
                      ? (value) {
                          setState(() {
                            _playFocusAudio = value;
                          });
                          _saveSettings();
                        }
                      : null,
                  secondary: Icon(Icons.volume_up),
                ),
                if (_playFocusAudio) ...[
                  const Divider(),
                  ListTile(
                    title: Text('Audio Type'),
                    subtitle: Text(_getAudioTypeLabel()),
                    trailing: DropdownButton<String>(
                      value: _audioType,
                      onChanged: _focusModeEnabled
                          ? (value) {
                              setState(() {
                                _audioType = value!;
                              });
                              _saveSettings();
                            }
                          : null,
                      items: ['ambient', 'white_noise', 'nature', 'instrumental'].map((type) => DropdownMenuItem(value: type, child: Text(_getAudioTypeLabel(type)))).toList(),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text('Volume'),
                    subtitle: Slider(
                      value: _audioVolume,
                      onChanged: _focusModeEnabled
                          ? (value) {
                              setState(() {
                                _audioVolume = value;
                              });
                              _saveSettings();
                            }
                          : null,
                      min: 0.0,
                      max: 1.0,
                    ),
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Enhancement Settings
          _buildSectionHeader('Enhancements'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Haptic Feedback'),
                  subtitle: Text('Vibration for focus mode events'),
                  value: _enableHapticFeedback,
                  onChanged: _focusModeEnabled
                      ? (value) {
                          setState(() {
                            _enableHapticFeedback = value;
                          });
                          _saveSettings();
                        }
                      : null,
                  secondary: Icon(Icons.vibration),
                ),
                const Divider(),
                SwitchListTile(
                  title: Text('Motivational Quotes'),
                  subtitle: Text('Show inspiring quotes during sessions'),
                  value: _showMotivationalQuotes,
                  onChanged: _focusModeEnabled
                      ? (value) {
                          setState(() {
                            _showMotivationalQuotes = value;
                          });
                          _saveSettings();
                        }
                      : null,
                  secondary: Icon(Icons.format_quote),
                ),
                const Divider(),
                SwitchListTile(
                  title: Text('Eye Break Reminders'),
                  subtitle: Text('Reminders to rest your eyes every 20 minutes'),
                  value: _enableEyeBreakReminders,
                  onChanged: _focusModeEnabled
                      ? (value) {
                          setState(() {
                            _enableEyeBreakReminders = value;
                          });
                          _saveSettings();
                        }
                      : null,
                  secondary: Icon(Icons.visibility),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Advanced Settings
          _buildSectionHeader('Advanced'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: Text('Dim Non-Essential UI'),
                  subtitle: Text('Reduce visual distractions in the app'),
                  value: _dimNonEssentialUI,
                  onChanged: _focusModeEnabled
                      ? (value) {
                          setState(() {
                            _dimNonEssentialUI = value;
                          });
                          _saveSettings();
                        }
                      : null,
                  secondary: Icon(Icons.brightness_low),
                ),
                const Divider(),
                SwitchListTile(
                  title: Text('Block Social Media'),
                  subtitle: Text('Block distracting apps (Android only)'),
                  value: _blockSocialMedia,
                  onChanged: _focusModeEnabled
                      ? (value) {
                          setState(() {
                            _blockSocialMedia = value;
                          });
                          _saveSettings();
                        }
                      : null,
                  secondary: Icon(Icons.block),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Status Card
          if (FocusMode.isActive)
            Card(
              color: Colors.green.withOpacity(0.1),
              child: ListTile(
                leading: Icon(Icons.center_focus_strong, color: Colors.green),
                title: Text('Focus Mode Active'),
                subtitle: Text('Distractions are currently blocked'),
                trailing: ElevatedButton(
                  onPressed: () async {
                    await FocusMode.disableFocusMode(reason: 'Manual disable');
                    setState(() {});
                  },
                  child: Text('Stop'),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }

  String _getAudioTypeLabel([String? type]) {
    type ??= _audioType;
    switch (type) {
      case 'ambient':
        return 'Ambient Sounds';
      case 'white_noise':
        return 'White Noise';
      case 'nature':
        return 'Nature Sounds';
      case 'instrumental':
        return 'Instrumental Music';
      default:
        return 'Unknown';
    }
  }
}
