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
    final l10n = AppLocalizations.of(context)!;
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
                  title: Text(l10n.resetSettings),
                  content: Text(l10n.resetSettingsConfirmation),
                  actions: [
                    TextButton(onPressed: () => Navigator.of(context).pop(false), child: Text(l10n.cancelButton)),
                    ElevatedButton(onPressed: () => Navigator.of(context).pop(true), child: Text(l10n.resetButton)),
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
                  label: l10n.searchSettings,
                  hint: l10n.typeToFilterSettingsSections,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: l10n.searchSettingsHint,
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
    final l10n = AppLocalizations.of(context)!;
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
    final l10n = AppLocalizations.of(context)!;
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
    final l10n = AppLocalizations.of(context)!;
    return AnimatedExpansionCard(
      leading: const Icon(Icons.palette),
      title: Text(l10n.appearanceSection),
      children: [
        _buildThemeSettings(settingsService),
        _buildAccessibilitySettings(settingsService),
        ColorCustomizationWidget(colorService: colorService),
      ],
    );
  }

  Widget _buildThemeSettings(settings.SettingsService settingsService) {
    final l10n = AppLocalizations.of(context)!;
    String getThemeModeName(settings.ThemeMode mode) {
      switch (mode) {
        case settings.ThemeMode.system:
          return l10n.systemTheme;
        case settings.ThemeMode.light:
          return l10n.lightTheme;
        case settings.ThemeMode.dark:
          return l10n.darkTheme;
      }
    }

    return Container(
      decoration: AppCardStyles.standard(context),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            title: Text(l10n.themeLabel),
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
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: AppCardStyles.standard(context),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          SwitchListTile(
            title: Text(l10n.highContrast),
            subtitle: Text(l10n.increaseContrastForBetterVisibility),
            value: settingsService.settings.enableHighContrast,
            onChanged: (value) {
              settingsService.updateSettings(settingsService.settings.copyWith(enableHighContrast: value));
            },
          ),
          SwitchListTile(
            title: Text(l10n.largeText),
            subtitle: Text(l10n.useLargerFontSizes),
            value: settingsService.settings.enableLargeText,
            onChanged: (value) {
              settingsService.updateSettings(settingsService.settings.copyWith(enableLargeText: value));
            },
          ),
          SwitchListTile(
            title: Text(l10n.screenReader),
            subtitle: Text(l10n.enableScreenReaderSupport),
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
    final l10n = AppLocalizations.of(context)!;
    return AnimatedExpansionCard(leading: const Icon(Icons.notifications), title: Text(l10n.notificationsSection), children: [_buildNotificationSettings(settingsService)]);
  }

  Widget _buildNotificationSettings(settings.SettingsService settingsService) {
    final l10n = AppLocalizations.of(context)!;
    String getNotificationFrequencyName(settings.NotificationFrequency frequency) {
      switch (frequency) {
        case settings.NotificationFrequency.immediate:
          return l10n.immediate;
        case settings.NotificationFrequency.hourly:
          return l10n.hourly;
        case settings.NotificationFrequency.daily:
          return l10n.daily;
        case settings.NotificationFrequency.weekly:
          return l10n.weekly;
      }
    }

    return Container(
      decoration: AppCardStyles.standard(context),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          // NEW: Navigation to advanced notification features
       ListTile(
            leading: const Icon(Icons.history, color: Colors.green),
            title: Text(l10n.notificationHistory),
            subtitle: Text(l10n.viewPastNotifications),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/notification_history'),
          ),
          const Divider(height: 1),
             ListTile(
            leading: const Icon(Icons.settings_outlined, color: Colors.blue),
            title: Text(l10n.notificationPreferences),
            subtitle: Text(l10n.customizeNotificationBehavior),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/notification_preferences'),
          ),
         /*  const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.science, color: Colors.deepPurple),
            title: Text(l10n.testNotifications),
            subtitle: Text(l10n.tryAllNotificationFeatures),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.pushNamed(context, '/notification_test'),
          ), */
          /*    const Divider(height: 1),
          SwitchListTile(title: Text(l10n.enableNotifications), value: settingsService.settings.enableNotifications, onChanged: (value) => settingsService.setNotificationsEnabled(value)),
          if (settingsService.settings.enableNotifications) ...[
            ListTile(
              title: Text(l10n.notificationFrequency),
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
              title: Text(l10n.sound),
              value: settingsService.settings.enableSound,
              onChanged: (value) {
                settingsService.updateSettings(settingsService.settings.copyWith(enableSound: value));
              },
            ),
            SwitchListTile(
              title: Text(l10n.vibration),
              value: settingsService.settings.enableVibration,
              onChanged: (value) {
                settingsService.updateSettings(settingsService.settings.copyWith(enableVibration: value));
              },
            ),
          ],
        */
        ],
      ),
    );
  }

  Widget _buildTaskSoundsSection() {
    final l10n = AppLocalizations.of(context)!;
    return AnimatedExpansionCard(
      leading: const Icon(Icons.music_note),
      title: Text(l10n.taskCompletionSounds),
      children: [
        Consumer<TaskSoundService>(
          builder: (context, taskSoundService, child) {
            return Container(
              decoration: AppCardStyles.standard(context),
              margin: EdgeInsets.zero,
              child: Column(
                children: [
                  SwitchListTile(
                    title: Text(l10n.enableTaskCompletionSound),
                    subtitle: Text(l10n.playSoundWhenTasksAreCompleted),
                    value: taskSoundService.soundEnabled,
                    onChanged: (value) {
                      taskSoundService.setSoundEnabled(value);
                    },
                  ),
                  if (taskSoundService.soundEnabled) ...[
                    ListTile(
                      title: Text(l10n.soundSelection),
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
                      title: Text(l10n.volume),
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
                        label: Text(l10n.testSound),
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
    final l10n = AppLocalizations.of(context)!;
    String getPomodoroPresetName(settings.PomodoroPreset preset) {
      switch (preset) {
        case settings.PomodoroPreset.classic:
          return l10n.classicPreset;
        case settings.PomodoroPreset.short:
          return l10n.shortPreset;
        case settings.PomodoroPreset.long:
          return l10n.longPreset;
        case settings.PomodoroPreset.custom:
          return l10n.custom;
      }
    }

    return Card(
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            title: Text(l10n.pomodoroPreset),
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
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.customDurationsMinutes),
          const SizedBox(height: AppSpacing.md),
          _buildDurationSlider(
            label: l10n.workDuration,
            value: settingsService.settings.customWorkDuration.toDouble(),
            min: 5,
            max: 60,
            onChanged: (value) => settingsService.setCustomPomodoroDurations(workDuration: value.toInt()),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDurationSlider(
            label: l10n.shortBreakDuration,
            value: settingsService.settings.customShortBreakDuration.toDouble(),
            min: 1,
            max: 15,
            onChanged: (value) => settingsService.setCustomPomodoroDurations(shortBreakDuration: value.toInt()),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDurationSlider(
            label: l10n.longBreakDuration,
            value: settingsService.settings.customLongBreakDuration.toDouble(),
            min: 5,
            max: 30,
            onChanged: (value) => settingsService.setCustomPomodoroDurations(longBreakDuration: value.toInt()),
          ),
          const SizedBox(height: AppSpacing.md),
          _buildDurationSlider(
            label: l10n.sessionsToLongBreak,
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
      message: 'Adjust the duration in minutes: $label',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ${value.toInt()} minutes'),
          Slider(value: value, min: min, max: max, divisions: (max - min).toInt(), label: '${value.toInt()}', onChanged: onChanged),
        ],
      ),
    );
  }

  Widget _buildBackupSection(settings.SettingsService settingsService) {
    return AnimatedExpansionCard(leading: const Icon(Icons.backup), title: Text(AppLocalizations.of(context)!.dataBackupSection), children: [_buildBackupSettings(settingsService)]);
  }

  Widget _buildBackupSettings(settings.SettingsService settingsService) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: AppCardStyles.standard(context),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          SwitchListTile(
            title: Text(l10n.autoBackup),
            subtitle: Text(l10n.automaticallyBackupData),
            value: settingsService.settings.enableAutoBackup,
            onChanged: (value) {
              settingsService.updateSettings(settingsService.settings.copyWith(enableAutoBackup: value));
            },
          ),
          if (settingsService.settings.enableAutoBackup)
            ListTile(
              title: Text(l10n.backupFrequency),
              subtitle: Text(l10n.days(settingsService.settings.backupFrequencyDays)),
              trailing: DropdownButton<int>(
                value: settingsService.settings.backupFrequencyDays,
                onChanged: (value) {
                  if (value != null) {
                    settingsService.updateSettings(settingsService.settings.copyWith(backupFrequencyDays: value));
                  }
                },
                items: [1, 3, 7, 14, 30].map((days) {
                  return DropdownMenuItem(value: days, child: Text(l10n.days(days)));
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
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: AppCardStyles.standard(context),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          SwitchListTile(
            title: Text(l10n.analytics),
            subtitle: Text(l10n.helpImproveTheAppWithUsageData),
            value: settingsService.settings.enableAnalytics,
            onChanged: (value) {
              settingsService.updateSettings(settingsService.settings.copyWith(enableAnalytics: value));
            },
          ),
          SwitchListTile(
            title: Text(l10n.crashReporting),
            subtitle: Text(l10n.sendCrashReportsToHelpFixIssues),
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
    final l10n = AppLocalizations.of(context)!;
    return Container(
      decoration: AppCardStyles.standard(context),
      margin: EdgeInsets.zero,
      child: Column(
        children: [
          ListTile(
            title: Text(l10n.language),
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
            title: Text(l10n.dateFormat),
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
            title: Text(l10n.timeFormat),
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
    final l10n = AppLocalizations.of(context)!;
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
                      subtitle: Text(l10n.failedToCheckForUpdates),
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
    final l10n = AppLocalizations.of(context)!;
    if (updateService.isChecking) {
      return l10n.downloadingUpdate;
    } else if (updateService.isUpdateAvailable) {
      return l10n.updateAvailable;
    } else if (updateService.hasError) {
      return l10n.updateError;
    } else {
      return l10n.noUpdatesAvailable;
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
    final l10n = AppLocalizations.of(context)!;
    final allSections = [
      {'title': l10n.profile, 'widget': _buildProfileSection()},
      {'title': l10n.mood, 'widget': _buildMoodSection()},
      {'title': l10n.appearance, 'widget': _buildAppearanceSection(settingsService, colorService)},
      {'title': l10n.notifications, 'widget': _buildNotificationsSection(settingsService)},
      {'title': l10n.taskSounds, 'widget': _buildTaskSoundsSection()},
      {'title': l10n.pomodoro, 'widget': _buildPomodoroSection(settingsService)},
      {'title': l10n.backup, 'widget': _buildBackupSection(settingsService)},
      {'title': l10n.privacy, 'widget': _buildPrivacySection(settingsService)},
      {'title': l10n.regional, 'widget': _buildRegionalSection(settingsService)},
      {'title': l10n.updates, 'widget': _buildUpdatesSection()},
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
