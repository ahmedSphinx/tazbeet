import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

import '../themes/design_system.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/empty_state.json', // Add Lottie animation file
              height: 120,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: AppSpacing.lg),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppLocalizations.of(context)!.noTasksFound,
              style: context.headlineSmall.copyWith(color: Theme.of(context).colorScheme.onSurface),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppLocalizations.of(context)!.noTasksYet,
              style: context.bodyMedium.copyWith(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Tap the + button to add your first task!',
              style: context.bodyMedium.copyWith(color: Theme.of(context).colorScheme.primary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
