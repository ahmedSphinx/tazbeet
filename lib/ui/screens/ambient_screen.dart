import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../services/ambient_service.dart';

class AmbientScreen extends StatefulWidget {
  const AmbientScreen({super.key});

  @override
  State<AmbientScreen> createState() => _AmbientScreenState();
}

class _AmbientScreenState extends State<AmbientScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AmbientService>().initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context).ambientSounds)),
      body: Consumer<AmbientService>(
        builder: (context, ambientService, child) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).focusAndRelaxation,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).chooseBackgroundSound,
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),
                _buildVolumeControl(ambientService),
                const SizedBox(height: 24),
                Expanded(child: _buildSoundGrid(ambientService)),
                const SizedBox(height: 16),
                _buildPlaybackControls(ambientService),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVolumeControl(AmbientService ambientService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.volume_up,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text(
                  AppLocalizations.of(context).volume,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const Spacer(),
                Text('${(ambientService.volume * 100).round()}%'),
              ],
            ),
            const SizedBox(height: 12),
            Slider(
              value: ambientService.volume,
              onChanged: (value) {
                ambientService.setVolume(value);
              },
              min: 0.0,
              max: 1.0,
              divisions: 20,
              label: '${(ambientService.volume * 100).round()}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoundGrid(AmbientService ambientService) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.2,
      ),
      itemCount: AmbientSound.values.length,
      itemBuilder: (context, index) {
        final sound = AmbientSound.values[index];
        final isSelected = ambientService.currentSound == sound;
        final isPlaying = isSelected && ambientService.isPlaying;

        return Card(
          elevation: isSelected ? 4 : 1,
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          child: InkWell(
            onTap: () => ambientService.playSound(sound),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    ambientService.getSoundIcon(sound),
                    size: 48,
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onSurface,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    ambientService.getSoundName(sound),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  if (isPlaying) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.volume_up,
                        size: 12,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlaybackControls(AmbientService ambientService) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filledTonal(
              onPressed: ambientService.isPlaying
                  ? () => ambientService.pause()
                  : ambientService.currentSound != null
                  ? () => ambientService.playSound(ambientService.currentSound!)
                  : null,
              icon: Icon(
                ambientService.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              iconSize: 32,
            ),
            const SizedBox(width: 16),
            IconButton.filledTonal(
              onPressed: () => ambientService.stop(),
              icon: const Icon(Icons.stop),
              iconSize: 32,
            ),
            const SizedBox(width: 16),
            IconButton.filledTonal(
              onPressed: ambientService.isFading
                  ? null
                  : () => ambientService.fadeIn(),
              icon: const Icon(Icons.volume_up),
              tooltip: AppLocalizations.of(context).fadeIn,
            ),
            const SizedBox(width: 16),
            IconButton.filledTonal(
              onPressed: ambientService.isFading
                  ? null
                  : () => ambientService.fadeOut(),
              icon: const Icon(Icons.volume_down),
              tooltip: AppLocalizations.of(context).fadeOut,
            ),
          ],
        ),
      ),
    );
  }
}
