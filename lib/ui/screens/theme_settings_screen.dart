import 'package:flutter/material.dart';
import '../../services/theme_service.dart';
import '../../l10n/app_localizations.dart';

/// Theme settings screen for customizing app appearance
class ThemeSettingsScreen extends StatefulWidget {
  const ThemeSettingsScreen({super.key});

  @override
  State<ThemeSettingsScreen> createState() => _ThemeSettingsScreenState();
}

class _ThemeSettingsScreenState extends State<ThemeSettingsScreen> {
  late ThemeService _themeService;
  late ThemeNotifier _themeNotifier;

  @override
  void initState() {
    super.initState();
    _themeService = ThemeService();
    _themeService.initialize();
    _themeNotifier = ThemeNotifier();
  }

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settingsScreenTitle), backgroundColor: Theme.of(context).colorScheme.surface, elevation: 0),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Mode Section
            _buildSectionHeader('Theme Mode'),
            _buildThemeModeSection(),
            const SizedBox(height: 32),

            // Color Scheme Section
            _buildSectionHeader('Color Scheme'),
            _buildColorSchemeSection(),
            const SizedBox(height: 32),

            // Accessibility Section
            _buildSectionHeader('Accessibility'),
            _buildAccessibilitySection(),
            const SizedBox(height: 32),

            // Advanced Settings
            _buildSectionHeader('Advanced'),
            _buildAdvancedSection(),
            const SizedBox(height: 32),

            // Reset Button
            _buildResetSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildThemeModeSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(_getThemeModeIcon(_themeNotifier.themeMode), color: Theme.of(context).colorScheme.primary),
            title: Text('Theme Mode', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text('Choose how the app looks', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
            trailing: DropdownButton<ThemeMode>(
              value: _themeNotifier.themeMode,
              items: ThemeMode.values.map((mode) {
                return DropdownMenuItem(
                  value: mode,
                  child: Row(children: [Icon(_getThemeModeIcon(mode)), const SizedBox(width: 12), Text(_themeService.getThemeModeDisplayName(mode))]),
                );
              }).toList(),
              onChanged: (ThemeMode? value) {
                if (value != null) {
                  _themeNotifier.setThemeMode(value);
                }
              },
            ),
          ),

          const Divider(),

          ListTile(
            leading: Icon(Icons.brightness_auto, color: _themeNotifier.autoTheme ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            title: Text('Auto Theme', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text('Automatically match system theme', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
            trailing: Switch(
              value: _themeNotifier.autoTheme,
              onChanged: (value) {
                _themeNotifier.setAutoTheme(value);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorSchemeSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.palette, color: Theme.of(context).colorScheme.primary),
            title: Text('Color Scheme', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text('Customize app colors', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
          ),

          const SizedBox(height: 16),

          // Color scheme grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: _themeService.availableColorSchemes.length,
            itemBuilder: (context, index) {
              final scheme = _themeService.availableColorSchemes[index];
              final isSelected = scheme == _themeNotifier.customColorScheme;

              return GestureDetector(
                onTap: () => _themeNotifier.setCustomColorScheme(scheme),
                child: Container(
                  decoration: BoxDecoration(
                    color: _getColorSchemeColor(scheme),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent, width: 2),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(_getColorSchemeIcon(scheme), color: _getTextColorForScheme(scheme), size: 24),
                        const SizedBox(height: 8),
                        Text(
                          _themeService.getColorSchemeDisplayName(scheme),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: _getTextColorForScheme(scheme), fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAccessibilitySection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.contrast, color: _themeNotifier.highContrast ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            title: Text('High Contrast', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text('Increase color contrast for better visibility', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
            trailing: Switch(
              value: _themeNotifier.highContrast,
              onChanged: (value) {
                _themeNotifier.setHighContrast(value);
              },
            ),
          ),

          const Divider(),

          ListTile(
            leading: Icon(Icons.text_fields, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            title: Text('Text Size', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text('Adjust text size for better readability', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
            trailing: DropdownButton<String>(
              value: 'Normal',
              items: ['Small', 'Normal', 'Large', 'Extra Large'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (value) {
                // This would integrate with accessibility service
                print('Text size changed to: $value');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.animation, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            title: Text('Animations', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text('Control animation speed and effects', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
            trailing: DropdownButton<String>(
              value: 'Normal',
              items: ['Reduced', 'Normal', 'Enhanced'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (value) {
                // This would integrate with animation optimizer service
                print('Animation speed changed to: $value');
              },
            ),
          ),

          const Divider(),

          ListTile(
            leading: Icon(Icons.speed, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            title: Text('Performance', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text('Optimize app performance', style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6))),
            trailing: DropdownButton<String>(
              value: 'Balanced',
              items: ['Power Saver', 'Balanced', 'Performance'].map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (value) {
                // This would integrate with performance optimization service
                print('Performance mode changed to: $value');
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResetSection() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Icon(Icons.restore, color: Colors.orange),
            title: Text(AppLocalizations.of(context)!.resetToDefaults, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text(
              AppLocalizations.of(context)!.resetAllThemeSettingsToDefaultValues,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            trailing: OutlinedButton(onPressed: _showResetDialog, child: Text(AppLocalizations.of(context)!.reset)),
          ),
        ],
      ),
    );
  }

  void _showResetDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.resetThemeSettings),
        content: Text(AppLocalizations.of(context)!.thisWillResetAllThemeSettingsToTheirDefaultValues),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(AppLocalizations.of(context)!.cancelButton)),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _themeNotifier.resetToDefaults();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(AppLocalizations.of(context)!.themeSettingsResetToDefaults), backgroundColor: Colors.green));
            },
            child: Text(AppLocalizations.of(context)!.reset),
          ),
        ],
      ),
    );
  }

  IconData _getThemeModeIcon(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
      case ThemeMode.system:
        return Icons.brightness_auto;
    }
  }

  Color _getColorSchemeColor(String scheme) {
    switch (scheme) {
      case 'ocean':
        return Colors.blue;
      case 'forest':
        return Colors.green;
      case 'sunset':
        return Colors.orange;
      case 'purple':
        return Colors.purple;
      case 'teal':
        return Colors.teal;
      case 'rose':
        return Colors.pink;
      default:
        return Colors.blue;
    }
  }

  IconData _getColorSchemeIcon(String scheme) {
    switch (scheme) {
      case 'ocean':
        return Icons.water;
      case 'forest':
        return Icons.park;
      case 'sunset':
        return Icons.wb_sunny;
      case 'purple':
        return Icons.auto_awesome;
      case 'teal':
        return Icons.eco;
      case 'rose':
        return Icons.favorite;
      default:
        return Icons.palette;
    }
  }

  Color _getTextColorForScheme(String scheme) {
    switch (scheme) {
      case 'ocean':
      case 'forest':
      case 'teal':
        return Colors.white;
      case 'sunset':
        return Colors.black;
      case 'purple':
      case 'rose':
        return Colors.white;
      default:
        return Colors.white;
    }
  }
}
