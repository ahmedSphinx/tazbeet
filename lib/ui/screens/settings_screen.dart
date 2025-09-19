import 'package:flutter/material.dart' hide ThemeMode;
import 'package:provider/provider.dart';
import '../../services/settings_service.dart' as settings;
import '../../services/color_customization_service.dart';
import '../../ui/widgets/color_customization_widget.dart';
import '../../l10n/generated/app_localizations.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<settings.SettingsService>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Consumer2<settings.SettingsService, ColorCustomizationService>(
        builder: (context, settingsService, colorService, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildProfileSection(),
              const SizedBox(height: 24),
              _buildSectionHeader(AppLocalizations.of(context).appearanceSection),
              _buildThemeSettings(settingsService),
              _buildAccessibilitySettings(settingsService),
              Consumer<ColorCustomizationService>(
                builder: (context, colorService, child) {
                  return ColorCustomizationWidget(colorService: colorService);
                },
              ),
              const SizedBox(height: 24),

              _buildSectionHeader(AppLocalizations.of(context).notificationsSection),
              _buildNotificationSettings(settingsService),
              const SizedBox(height: 24),

              _buildSectionHeader(AppLocalizations.of(context).pomodoroSection),
              _buildPomodoroSettings(settingsService),
              const SizedBox(height: 24),

              _buildSectionHeader(AppLocalizations.of(context).dataBackupSection),
              _buildBackupSettings(settingsService),
              const SizedBox(height: 24),

              _buildSectionHeader(AppLocalizations.of(context).privacyAnalyticsSection),
              _buildPrivacySettings(settingsService),
              const SizedBox(height: 24),

              _buildSectionHeader(AppLocalizations.of(context).regionalSection),
              _buildRegionalSettings(settingsService),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileSection() {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.person),
        title: const Text('Profile'),
        subtitle: const Text('Edit your profile information'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const ProfileScreen()),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildThemeSettings(settings.SettingsService settingsService) {
    String getThemeModeName(settings.ThemeMode mode) {
      switch (mode) {
        case settings.ThemeMode.system:
          return 'System';
        case settings.ThemeMode.light:
          return 'Light';
        case settings.ThemeMode.dark:
          return 'Dark';
      }
    }

    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(
              getThemeModeName(settingsService.settings.themeMode),
            ),
            trailing: DropdownButton<settings.ThemeMode>(
              value: settingsService.settings.themeMode,
              onChanged: (value) {
                if (value != null) {
                  settingsService.setThemeMode(value);
                }
              },
              items: settings.ThemeMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Text(getThemeModeName(mode)),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilitySettings(settings.SettingsService settingsService) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('High Contrast'),
            subtitle: const Text('Increase contrast for better visibility'),
            value: settingsService.settings.enableHighContrast,
            onChanged: (value) {
              settingsService.updateSettings(
                settingsService.settings.copyWith(enableHighContrast: value),
              );
            },
          ),
          SwitchListTile(
            title: const Text('Large Text'),
            subtitle: const Text('Use larger font sizes'),
            value: settingsService.settings.enableLargeText,
            onChanged: (value) {
              settingsService.updateSettings(
                settingsService.settings.copyWith(enableLargeText: value),
              );
            },
          ),
          SwitchListTile(
            title: const Text('Screen Reader'),
            subtitle: const Text('Enable screen reader support'),
            value: settingsService.settings.enableScreenReader,
            onChanged: (value) {
              settingsService.updateSettings(
                settingsService.settings.copyWith(enableScreenReader: value),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSettings(settings.SettingsService settingsService) {
    String getNotificationFrequencyName(
      settings.NotificationFrequency frequency,
    ) {
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

    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: settingsService.settings.enableNotifications,
            onChanged: (value) =>
                settingsService.setNotificationsEnabled(value),
          ),
          if (settingsService.settings.enableNotifications) ...[
            ListTile(
              title: const Text('Notification Frequency'),
              subtitle: Text(
                getNotificationFrequencyName(
                  settingsService.settings.notificationFrequency,
                ),
              ),
              trailing: DropdownButton<settings.NotificationFrequency>(
                value: settingsService.settings.notificationFrequency,
                onChanged: (value) {
                  if (value != null) {
                    settingsService.setNotificationFrequency(value);
                  }
                },
                items: settings.NotificationFrequency.values.map((freq) {
                  return DropdownMenuItem(
                    value: freq,
                    child: Text(getNotificationFrequencyName(freq)),
                  );
                }).toList(),
              ),
            ),
            SwitchListTile(
              title: const Text('Sound'),
              value: settingsService.settings.enableSound,
              onChanged: (value) {
                settingsService.updateSettings(
                  settingsService.settings.copyWith(enableSound: value),
                );
              },
            ),
            SwitchListTile(
              title: const Text('Vibration'),
              value: settingsService.settings.enableVibration,
              onChanged: (value) {
                settingsService.updateSettings(
                  settingsService.settings.copyWith(enableVibration: value),
                );
              },
            ),
          ],
        ],
      ),
    );
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
      child: Column(
        children: [
          ListTile(
            title: const Text('Pomodoro Preset'),
            subtitle: Text(
              getPomodoroPresetName(settingsService.settings.pomodoroPreset),
            ),
            trailing: DropdownButton<settings.PomodoroPreset>(
              value: settingsService.settings.pomodoroPreset,
              onChanged: (value) {
                if (value != null) {
                  settingsService.setPomodoroPreset(value);
                }
              },
              items: settings.PomodoroPreset.values.map((preset) {
                return DropdownMenuItem(
                  value: preset,
                  child: Text(getPomodoroPresetName(preset)),
                );
              }).toList(),
            ),
          ),
          if (settingsService.settings.pomodoroPreset ==
              settings.PomodoroPreset.custom)
            _buildCustomPomodoroSettings(settingsService),
        ],
      ),
    );
  }

  Widget _buildCustomPomodoroSettings(
    settings.SettingsService settingsService,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Custom Durations (minutes)'),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Work',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                    text: settingsService.settings.customWorkDuration
                        .toString(),
                  ),
                  onChanged: (value) {
                    final duration = int.tryParse(value) ?? 25;
                    settingsService.setCustomPomodoroDurations(
                      workDuration: duration,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Short Break',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                    text: settingsService.settings.customShortBreakDuration
                        .toString(),
                  ),
                  onChanged: (value) {
                    final duration = int.tryParse(value) ?? 5;
                    settingsService.setCustomPomodoroDurations(
                      shortBreakDuration: duration,
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Long Break',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                    text: settingsService.settings.customLongBreakDuration
                        .toString(),
                  ),
                  onChanged: (value) {
                    final duration = int.tryParse(value) ?? 15;
                    settingsService.setCustomPomodoroDurations(
                      longBreakDuration: duration,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Sessions to Long Break',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  controller: TextEditingController(
                    text: settingsService.settings.sessionsUntilLongBreak
                        .toString(),
                  ),
                  onChanged: (value) {
                    final sessions = int.tryParse(value) ?? 4;
                    settingsService.setCustomPomodoroDurations(
                      sessionsUntilLongBreak: sessions,
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBackupSettings(settings.SettingsService settingsService) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Auto Backup'),
            subtitle: const Text('Automatically backup your data'),
            value: settingsService.settings.enableAutoBackup,
            onChanged: (value) {
              settingsService.updateSettings(
                settingsService.settings.copyWith(enableAutoBackup: value),
              );
            },
          ),
          if (settingsService.settings.enableAutoBackup)
            ListTile(
              title: const Text('Backup Frequency'),
              subtitle: Text(
                '${settingsService.settings.backupFrequencyDays} days',
              ),
              trailing: DropdownButton<int>(
                value: settingsService.settings.backupFrequencyDays,
                onChanged: (value) {
                  if (value != null) {
                    settingsService.updateSettings(
                      settingsService.settings.copyWith(
                        backupFrequencyDays: value,
                      ),
                    );
                  }
                },
                items: [1, 3, 7, 14, 30].map((days) {
                  return DropdownMenuItem(
                    value: days,
                    child: Text('$days days'),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPrivacySettings(settings.SettingsService settingsService) {
    return Card(
      child: Column(
        children: [
          SwitchListTile(
            title: const Text('Analytics'),
            subtitle: const Text('Help improve the app with usage data'),
            value: settingsService.settings.enableAnalytics,
            onChanged: (value) {
              settingsService.updateSettings(
                settingsService.settings.copyWith(enableAnalytics: value),
              );
            },
          ),
          SwitchListTile(
            title: const Text('Crash Reporting'),
            subtitle: const Text('Send crash reports to help fix issues'),
            value: settingsService.settings.enableCrashReporting,
            onChanged: (value) {
              settingsService.updateSettings(
                settingsService.settings.copyWith(enableCrashReporting: value),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRegionalSettings(settings.SettingsService settingsService) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: const Text('Language'),
            subtitle: Text(settingsService.settings.language),
            trailing: DropdownButton<String>(
              value: settingsService.settings.language,
              onChanged: (value) {
                if (value != null) {
                  settingsService.updateSettings(
                    settingsService.settings.copyWith(language: value),
                  );
                }
              },
              items: ['en','ar', 'es', 'fr', 'de'].map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text(_getLanguageName(lang)),
                );
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
                  settingsService.updateSettings(
                    settingsService.settings.copyWith(dateFormat: value),
                  );
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
                  settingsService.updateSettings(
                    settingsService.settings.copyWith(timeFormat: value),
                  );
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

  String _getThemeModeName(settings.ThemeMode mode) {
    switch (mode) {
      case settings.ThemeMode.system:
        return 'System';
      case settings.ThemeMode.light:
        return 'Light';
      case settings.ThemeMode.dark:
        return 'Dark';
    }
  }

  String _getNotificationFrequencyName(
    settings.NotificationFrequency frequency,
  ) {
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

  String _getPomodoroPresetName(settings.PomodoroPreset preset) {
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
}
