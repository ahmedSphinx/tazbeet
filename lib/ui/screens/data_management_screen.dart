import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/task_list/task_list_bloc.dart';
import '../../blocs/task_list/task_list_event.dart';
import '../../services/data_management_service.dart';

class DataManagementScreen extends StatefulWidget {
  const DataManagementScreen({super.key});

  @override
  State<DataManagementScreen> createState() => _DataManagementScreenState();
}

class _DataManagementScreenState extends State<DataManagementScreen> {
  final DataManagementService _dataService = DataManagementService();
  bool _isExporting = false;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Management'), backgroundColor: Theme.of(context).colorScheme.inversePrimary),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildSectionHeader('Export Data'),
          _buildExportSection(),
          const SizedBox(height: 24),
          _buildSectionHeader('Import Data'),
          _buildImportSection(),
          const SizedBox(height: 24),
          _buildSectionHeader('Backup & Restore'),
          _buildBackupSection(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildExportSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Export your tasks to external formats'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(onPressed: _isExporting ? null : _exportToCSV, icon: const Icon(Icons.table_chart), label: const Text('Export CSV')),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(onPressed: _isExporting ? null : _exportToJSON, icon: const Icon(Icons.code), label: const Text('Export JSON')),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(onPressed: _isExporting ? null : _exportToICS, icon: const Icon(Icons.calendar_today), label: const Text('Export ICS (Calendar)')),
            ),
            if (_isExporting) const Padding(padding: EdgeInsets.only(top: 16.0), child: LinearProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildImportSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Import tasks from external files'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(onPressed: _isImporting ? null : _importFromFile, icon: const Icon(Icons.file_upload), label: const Text('Import from File')),
            ),
            if (_isImporting) const Padding(padding: EdgeInsets.only(top: 16.0), child: LinearProgressIndicator()),
          ],
        ),
      ),
    );
  }

  Widget _buildBackupSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create and restore backups'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(onPressed: _createBackup, icon: const Icon(Icons.backup), label: const Text('Create Backup')),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(onPressed: _restoreBackup, icon: const Icon(Icons.restore), label: const Text('Restore Backup')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _exportToCSV() async {
    setState(() => _isExporting = true);
    try {
      final filePath = await _dataService.exportTasksToCSV();
      await _dataService.shareFile(filePath);
      _showSuccessSnackBar('CSV export completed');
    } catch (e) {
      _showErrorSnackBar('Failed to export CSV: $e');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportToJSON() async {
    setState(() => _isExporting = true);
    try {
      final filePath = await _dataService.exportTasksToJSON();
      await _dataService.shareFile(filePath);
      _showSuccessSnackBar('JSON export completed');
    } catch (e) {
      _showErrorSnackBar('Failed to export JSON: $e');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _exportToICS() async {
    setState(() => _isExporting = true);
    try {
      final filePath = await _dataService.exportTasksToICS();
      await _dataService.shareFile(filePath);
      _showSuccessSnackBar('ICS export completed');
    } catch (e) {
      _showErrorSnackBar('Failed to export ICS: $e');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  Future<void> _importFromFile() async {
    setState(() => _isImporting = true);
    try {
      final filePath = await _dataService.pickImportFile();
      if (filePath != null) {
        if (filePath.endsWith('.csv')) {
          await _dataService.importTasksFromCSV(filePath);
        } else if (filePath.endsWith('.json')) {
          await _dataService.importTasksFromJSON(filePath);
        } else {
          _showErrorSnackBar('Unsupported file format');
          return;
        }

        // Refresh the task list
        context.read<TaskListBloc>().add(LoadTasks());
        _showSuccessSnackBar('Import completed successfully');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to import: $e');
    } finally {
      setState(() => _isImporting = false);
    }
  }

  Future<void> _createBackup() async {
    try {
      final filePath = await _dataService.exportTasksToJSON();
      await _dataService.shareFile(filePath);
      _showSuccessSnackBar('Backup created successfully');
    } catch (e) {
      _showErrorSnackBar('Failed to create backup: $e');
    }
  }

  Future<void> _restoreBackup() async {
    try {
      final filePath = await _dataService.pickImportFile();
      if (filePath != null && filePath.endsWith('.json')) {
        await _dataService.importTasksFromJSON(filePath);
        context.read<TaskListBloc>().add(LoadTasks());
        _showSuccessSnackBar('Backup restored successfully');
      } else {
        _showErrorSnackBar('Please select a valid backup file');
      }
    } catch (e) {
      _showErrorSnackBar('Failed to restore backup: $e');
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.green));
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }
}
