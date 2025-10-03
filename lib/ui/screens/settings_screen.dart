// ignore_for_file: unused_element

import 'package:flutter/material.dart' hide ThemeMode;
import 'package:provider/provider.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import '../../services/settings_service.dart' as settings;
import '../../services/color_customization_service.dart';
import '../../services/task_sound_service.dart';
import '../../services/update_service.dart';
import '../../ui/widgets/color_customization_widget.dart';
import '../../ui/widgets/animated_expansion_card.dart';
import '../../ui/themes/app_themes.dart';
import '../../ui/themes/design_system.dart';

import 'profile_screen.dart';
import 'mood_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<settings.SettingsService>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settingsScreenTitle,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary),
        ),
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        elevation: 0,
        flexibleSpace: Container(decoration: BoxDecoration(gradient: AppThemes.getPrimaryGradient(isDark))),
        actions: [
          TextButton(
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Settings'),
                  content: const Text('Are you sure you want to reset all settings to their default values? This action cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
                    ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Reset')),
                  ],
                ),
              );
              if (confirmed == true) {
                context.read<settings.SettingsService>().resetToDefaults();
                context.read<ColorCustomizationService>().resetToDefault();
              }
            },
            child: Text(AppLocalizations.of(context)!.resetButton, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
          ),
        ],
      ),
      body: Consumer2<settings.SettingsService, ColorCustomizationService>(
        builder: (context, settingsService, colorService, child) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Semantics(
                  label: 'Search settings',
                  hint: 'Type to filter settings sections',
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search settings...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value.toLowerCase();
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.lg),
                  children: _filteredSections(settingsService, colorService),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: const Icon(Icons.person),
        title: Text(AppLocalizations.of(context)!.profile),
        subtitle: Text(AppLocalizations.of(context)!.editProfileInfo),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ProfileScreen()));
        },
      ),
    );
  }

  Widget _buildMoodSection() {
    return Card(
      margin: EdgeInsets.zero,
      child: ListTile(
        leading: const Icon(Icons.mood),
        title: Text(AppLocalizations.of(context)!.moodSettingsTitle),
        subtitle: Text(AppLocalizations.of(context)!.moodSettingsSubtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MoodSettingsScreen()));
        },
      ),
    );
  }

  Widget _buildAppearanceSection(settings.SettingsService settingsService, ColorCustomizationService colorService) {
    return AnimatedExpansionCard(
      leading: const Icon(Icons.palette),
      title: Text(AppLocalizations.of(context)!.appearanceSection),
      children: [
        _buildThemeSettings(settingsService),
        _buildAccessibilitySettings(settingsService),
        ColorCustomizationWidget(colorService: colorService),
      ],
    );
  }

  Widget _buildThemeSettings(settings.SettingsService settingsService) {
    String getThemeModeName(settings.ThemeMode mode) {
      switch (mode) {
        case settings.ThemeMode.system:
          return AppLocalizations.of(context)!.systemTheme;
        case settings.ThemeMode.light:
          return AppLocalizations.of(context)!.lightTheme;
        case settings.ThemeMode.dark:
          return AppLocalizations.of(context)!.darkTheme;
      }
    }

    return Container(
      decoration: AppCardStyles.standard(context),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            title: Text(AppLocalizations.of(context)!.themeLabel),
            subtitle: Text(getThemeModeName(settingsService.settings.themeMode)),
            trailing: DropdownButton<settings.ThemeMode>(
              value: settingsService.settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  settingsService.setThemeMode(value);
                }
              },
              items: settings.ThemeMode.values.map((mode) {
                return DropdownMenuItem(value: mode, child: Text(getThemeModeName(mode)));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilitySettings(settings.SettingsService settingsService) {
    return Container(
      decoration: AppCardStyles.standard(context),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('High Contrast'),
            subtitle: const Text('Increase contrast for better visibility'),
            value: settingsService.settings.enableHighContrast,
            onChanged: (value) {
              settingsService.updateSettings(settingsService.settings.copyWith(enableHighContrast: value));
            },
          ),
          SwitchListTile(
            title: const Text('Large Text'),
            subtitle: const Text('Use larger font sizes'),
            value: settingsService.settings.enableLargeText,
            onChanged: (value) {
              settingsService.updateSettings(settingsService.settings.copyWith(enableLargeText: value));
            },
          ),
          SwitchListTile(
            title: const Text('Screen Reader'),
            subtitle: const Text('Enable screen reader support'),
            value: settingsService.settings.enableScreenReader,
            onChanged: (value) {
              settingsService.updateSettings(settingsService.settings.copyWith(enableScreenReader: value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsSection(settings.SettingsService settingsService) {
    return AnimatedExpansionCard(leading: const Icon(Icons.notifications), title: Text(AppLocalizations.of(context)!.notificationsSection), children: [_buildNotificationSettings(settingsService)]);
  }

  Widget _buildNotificationSettings(settings.SettingsService settingsService) {
    String getNotificationFrequencyName(settings.NotificationFrequency frequency) {
      switch (frequency) {
        case settings.NotificationFrequency.immediate:
          return 'Immediate';
        case settings.NotificationFrequency.hourly:
          return 'Hourly';
        case settings.NotificationFrequency.daily:
          return 'Daily';
        case settings.NotificationFrequency.weekly:
          return 'Weekly';
      }
    }

    return Container(
      decoration: AppCardStyles.standard(context),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          SwitchListTile(title: const Text('Enable Notifications'), value: settingsService.settings.enableNotifications, onChanged: (value) => settingsService.setNotificationsEnabled(value)),
          if (settingsService.settings.enableNotifications) ...[
            ListTile(
              title: const Text('Notification Frequency'),
              subtitle: Text(getNotificationFrequencyName(settingsService.settings.notificationFrequency)),
              trailing: DropdownButton<settings.NotificationFrequency>(
                value: settingsService.settings.notificationFrequency,
                onChanged: (value) {
                  if (value != null) {
                    settingsService.setNotificationFrequency(value);
                  }
                },
                items: settings.NotificationFrequency.values.map((freq) {
                  return DropdownMenuItem(value: freq, child: Text(getNotificationFrequencyName(freq)));
                }).toList(),
              ),
            ),
            SwitchListTile(
              title: const Text('Sound'),
              value: settingsService.settings.enableSound,
              onChanged: (value) {
                settingsService.updateSettings(settingsService.settings.copyWith(enableSound: value));
              },
            ),
            SwitchListTile(
              title: const Text('Vibration'),
              value: settingsService.settings.enableVibration,
              onChanged: (value) {
                settingsService.updateSettings(settingsService.settings.copyWith(enableVibration: value));
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTaskSoundsSection() {
    return AnimatedExpansionCard(
      leading: const Icon(Icons.music_note),
      title: const Text('Task Completion Sounds'),
      children: [
        Consumer<TaskSoundService>(
          builder: (context, taskSoundService, child) {
            return Container(
              decoration: AppCardStyles.standard(context),
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Enable Task Completion Sound'),
                    subtitle: const Text('Play sound when tasks are completed'),
                    value: taskSoundService.soundEnabled,
                    onChanged: (value) {
                      taskSoundService.setSoundEnabled(value);
                    },
                  ),
                  if (taskSoundService.soundEnabled) ...[
                    ListTile(
                      title: const Text('Sound Selection'),
                      subtitle: Text(taskSoundService.availableSounds[taskSoundService.selectedSound] ?? 'Unknown'),
                      trailing: DropdownButton<String>(
                        value: taskSoundService.selectedSound,
                        onChanged: (value) {
                          if (value != null) {
                            taskSoundService.setSelectedSound(value);
                          }
                        },
                        items: taskSoundService.availableSounds.entries.map((entry) {
                          return DropdownMenuItem(value: entry.key, child: Text(entry.value));
                        }).toList(),
                      ),
                    ),
                    ListTile(
                      title: const Text('Volume'),
                      subtitle: Slider(
                        value: taskSoundService.volume,
                        onChanged: (value) {
                          taskSoundService.setVolume(value);
                        },
                        min: 0.0,
                        max: 1.0,
                        divisions: 10,
                        label: '${(taskSoundService.volume * 100).round()}%',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          taskSoundService.playTaskCompletionSound();
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Test Sound'),
                        style: AppButtonStyles.primary(context),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildPomodoroSection(settings.SettingsService settingsService) {
    return AnimatedExpansionCard(leading: const Icon(Icons.timer), title: Text(AppLocalizations.of(context)!.pomodoroSection), children: [_buildPomodoroSettings(settingsService)]);
  }

  Widget _buildPomodoroSettings(settings.SettingsService settingsService) {
    String getPomodoroPresetName(settings.PomodoroPreset preset) {
      switch (preset) {
        case settings.PomodoroPreset.classic:
          return 'Classic (25/5/15)';
        case settings.PomodoroPreset.short:
          return 'Short (15/3/10)';
        case settings.PomodoroPreset.long:
          return 'Long (50/10/30)';
        case settings.PomodoroPreset.custom:
          return 'Custom';
      }
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            title: const Text('Pomodoro Preset'),
            subtitle: Text(getPomodoroPresetName(settingsService.settings.pomodoroPreset)),
            trailing: DropdownButton<settings.PomodoroPreset>(
              value: settingsService.settings.pomodoroPreset,
              onChanged: (value) {
                if (value != null) {
                  settingsService.setPomodoroPreset(value);
                }
              },
              items: settings.PomodoroPreset.values.map((preset) {
                return DropdownMenuItem(value: preset, child: Text(getPomodoroPresetName(preset)));
              }).toList(),
            ),
          ),
          if (settingsService.settings.pomodoroPreset == settings.PomodoroPreset.custom) _buildCustomPomodoroSettings(settingsService),
        ],
      ),
    );
  }

  Widget _buildCustomPomodoroSettings(settings.SettingsService settingsService) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Custom Durations (minutes)'),
          const SizedBox(height: AppSpacing.md),
          _buildDurationSlider(
            label: 'Work Duration',
            value: settingsService.settings.customWorkDuration.toDouble(),
            min: 5,
            max: 60,
            onChanged: (value) => settingsService.setCustomPomodoroDurations(workDuration: value.toInt()),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDurationSlider(
            label: 'Short Break Duration',
            value: settingsService.settings.customShortBreakDuration.toDouble(),
            min: 1,
            max: 15,
            onChanged: (value) => settingsService.setCustomPomodoroDurations(shortBreakDuration: value.toInt()),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDurationSlider(
            label: 'Long Break Duration',
            value: settingsService.settings.customLongBreakDuration.toDouble(),
            min: 5,
            max: 30,
            onChanged: (value) => settingsService.setCustomPomodoroDurations(longBreakDuration: value.toInt()),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDurationSlider(
            label: 'Sessions to Long Break',
            value: settingsService.settings.sessionsUntilLongBreak.toDouble(),
            min: 2,
            max: 8,
            onChanged: (value) => settingsService.setCustomPomodoroDurations(sessionsUntilLongBreak: value.toInt()),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationSlider({required String label, required double value, required double min, required double max, required ValueChanged<double> onChanged}) {
    return Tooltip(
      message: 'Adjust the $label duration in minutes',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ${value.toInt()} min'),
          Slider(value: value, min: min, max: max, divisions: (max - min).toInt(), label: '${value.toInt()}', onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildBackupSection(settings.SettingsService settingsService) {
    return AnimatedExpansionCard(leading: const Icon(Icons.backup), title: Text(AppLocalizations.of(context)!.dataBackupSection), children: [_buildBackupSettings(settingsService)]);
  }

  Widget _buildBackupSettings(settings.SettingsService settingsService) {
    return Container(
      decoration: AppCardStyles.standard(context),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Auto Backup'),
            subtitle: const Text('Automatically backup your data'),
            value: settingsService.settings.enableAutoBackup,
            onChanged: (value) {
              settingsService.updateSettings(settingsService.settings.copyWith(enableAutoBackup: value));
            },
          ),
          if (settingsService.settings.enableAutoBackup)
            ListTile(
              title: const Text('Backup Frequency'),
              subtitle: Text('${settingsService.settings.backupFrequencyDays} days'),
              trailing: DropdownButton<int>(
                value: settingsService.settings.backupFrequencyDays,
                onChanged: (value) {
                  if (value != null) {
                    settingsService.updateSettings(settingsService.settings.copyWith(backupFrequencyDays: value));
                  }
                },
                items: [1, 3, 7, 14, 30].map((days) {
                  return DropdownMenuItem(value: days, child: Text('$days days'));
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection(settings.SettingsService settingsService) {
    return AnimatedExpansionCard(leading: const Icon(Icons.privacy_tip), title: Text(AppLocalizations.of(context)!.privacyAnalyticsSection), children: [_buildPrivacySettings(settingsService)]);
  }

  Widget _buildPrivacySettings(settings.SettingsService settingsService) {
    return Container(
      decoration: AppCardStyles.standard(context),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Analytics'),
            subtitle: const Text('Help improve the app with usage data'),
            value: settingsService.settings.enableAnalytics,
            onChanged: (value) {
              settingsService.updateSettings(settingsService.settings.copyWith(enableAnalytics: value));
            },
          ),
          SwitchListTile(
            title: const Text('Crash Reporting'),
            subtitle: const Text('Send crash reports to help fix issues'),
            value: settingsService.settings.enableCrashReporting,
            onChanged: (value) {
              settingsService.updateSettings(settingsService.settings.copyWith(enableCrashReporting: value));
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRegionalSection(settings.SettingsService settingsService) {
    return AnimatedExpansionCard(leading: const Icon(Icons.language), title: Text(AppLocalizations.of(context)!.regionalSection), children: [_buildRegionalSettings(settingsService)]);
  }

  Widget _buildRegionalSettings(settings.SettingsService settingsService) {
    return Container(
      decoration: AppCardStyles.standard(context),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            title: const Text('Language'),
            subtitle: Text(settingsService.settings.language),
            trailing: DropdownButton<String>(
              value: settingsService.settings.language,
              onChanged: (value) {
                if (value != null) {
                  settingsService.updateSettings(settingsService.settings.copyWith(language: value));
                }
              },
              items: ['en', 'ar', 'es', 'fr', 'de'].map((lang) {
                return DropdownMenuItem(value: lang, child: Text(_getLanguageName(lang)));
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('Date Format'),
            subtitle: Text(settingsService.settings.dateFormat),
            trailing: DropdownButton<String>(
              value: settingsService.settings.dateFormat,
              onChanged: (value) {
                if (value != null) {
                  settingsService.updateSettings(settingsService.settings.copyWith(dateFormat: value));
                }
              },
              items: ['MM/dd/yyyy', 'dd/MM/yyyy', 'yyyy-MM-dd'].map((format) {
                return DropdownMenuItem(value: format, child: Text(format));
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('Time Format'),
            subtitle: Text(settingsService.settings.timeFormat),
            trailing: DropdownButton<String>(
              value: settingsService.settings.timeFormat,
              onChanged: (value) {
                if (value != null) {
                  settingsService.updateSettings(settingsService.settings.copyWith(timeFormat: value));
                }
              },
              items: ['12h', '24h'].map((format) {
                return DropdownMenuItem(value: format, child: Text(format));
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  String _getLanguageName(String code) {
    switch (code) {
      case 'ar':
        return 'العربية';
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      case 'fr':
        return 'Français';
      case 'de':
        return 'Deutsch';
      default:
        return code;
    }
  }

  Widget _buildUpdatesSection() {
    return AnimatedExpansionCard(
      leading: const Icon(Icons.system_update),
      title: Text(AppLocalizations.of(context)!.appUpdates),
      children: [
        Consumer<UpdateService>(
          builder: (context, updateService, child) {
            return Container(
              decoration: AppCardStyles.standard(context),
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  ListTile(title: Text(AppLocalizations.of(context)!.currentVersion), subtitle: Text(AppLocalizations.of(context)!.version(updateService.currentVersion))),
                  const Divider(),
                  ListTile(
                    title: Text(AppLocalizations.of(context)!.checkForUpdates),
                    subtitle: Text(_getUpdateStatusText(updateService)),
                    trailing: updateService.isChecking
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : IconButton(icon: const Icon(Icons.refresh), onPressed: () => _checkForUpdates(updateService)),
                    onTap: () => _checkForUpdates(updateService),
                  ),
                  if (updateService.isUpdateAvailable) ...[
                    const Divider(),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.updateAvailable),
                      subtitle: Text(AppLocalizations.of(context)!.version(updateService.updateInfo?.version ?? '')),
                      trailing: updateService.isDownloading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                          : ElevatedButton(onPressed: () => _startUpdate(updateService), child: Text(AppLocalizations.of(context)!.installUpdate), style: AppButtonStyles.primary(context)),
                    ),
                  ],
                  if (updateService.hasError) ...[
                    const Divider(),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.updateError),
                      subtitle: const Text('Failed to check for updates'),
                      trailing: TextButton(onPressed: () => _checkForUpdates(updateService), child: Text(AppLocalizations.of(context)!.retry), style: AppButtonStyles.secondary(context)),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  String _getUpdateStatusText(UpdateService updateService) {
    if (updateService.isChecking) {
      return AppLocalizations.of(context)!.downloadingUpdate;
    } else if (updateService.isUpdateAvailable) {
      return AppLocalizations.of(context)!.updateAvailable;
    } else if (updateService.hasError) {
      return AppLocalizations.of(context)!.updateError;
    } else {
      return AppLocalizations.of(context)!.noUpdatesAvailable;
    }
  }

  Future<void> _checkForUpdates(UpdateService updateService) async {
    await updateService.checkForUpdates();
  }

  Future<void> _startUpdate(UpdateService updateService) async {
    if (updateService.updateInfo?.isImmediateUpdate == true) {
      await updateService.startImmediateUpdate();
    } else {
      await updateService.startFlexibleUpdate();
    }
  }

  List<Widget> _filteredSections(settings.SettingsService settingsService, ColorCustomizationService colorService) {
    final allSections = [
      {'title': 'profile', 'widget': _buildProfileSection()},
      {'title': 'mood', 'widget': _buildMoodSection()},
      {'title': 'appearance', 'widget': _buildAppearanceSection(settingsService, colorService)},
      {'title': 'notifications', 'widget': _buildNotificationsSection(settingsService)},
      {'title': 'task sounds', 'widget': _buildTaskSoundsSection()},
      {'title': 'pomodoro', 'widget': _buildPomodoroSection(settingsService)},
      {'title': 'backup', 'widget': _buildBackupSection(settingsService)},
      {'title': 'privacy', 'widget': _buildPrivacySection(settingsService)},
      {'title': 'regional', 'widget': _buildRegionalSection(settingsService)},
      {'title': 'updates', 'widget': _buildUpdatesSection()},
    ];

    final filtered = _searchQuery.isEmpty ? allSections : allSections.where((section) => (section['title'] as String).contains(_searchQuery)).toList();

    final widgets = <Widget>[];
    for (final section in filtered) {
      widgets.add(section['widget'] as Widget);
      widgets.add(const SizedBox(height: AppSpacing.lg));
    }
    if (widgets.isNotEmpty) {
      widgets.removeLast(); // Remove last spacing
    }
    return widgets;
  }
}
