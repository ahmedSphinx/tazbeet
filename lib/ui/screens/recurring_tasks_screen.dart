import 'package:flutter/material.dart';
import 'package:tazbeet/l10n/app_localizations.dart';

import '../widgets/recurring_tasks_manager.dart';

class RecurringTasksScreen extends StatelessWidget {
  const RecurringTasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.recurringTasksManager), backgroundColor: Theme.of(context).colorScheme.primary, foregroundColor: Colors.white),
      body: const SingleChildScrollView(padding: EdgeInsets.all(16), child: RecurringTasksManager()),
    );
  }
}
