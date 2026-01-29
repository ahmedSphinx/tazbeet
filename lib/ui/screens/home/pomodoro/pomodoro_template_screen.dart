import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/models/task.dart';
import '../../../../services/app_logging_service.dart';
import '../../../../models/pomodoro_template_model.dart';

class PomodoroTemplateScreen extends StatefulWidget {
  final Task? initialTask;

  const PomodoroTemplateScreen({super.key, this.initialTask});

  @override
  State<PomodoroTemplateScreen> createState() => _PomodoroTemplateScreenState();

  // Static method to show as modal bottom sheet
  static Future<PomodoroTemplate?> showAsModal(BuildContext context, {Task? initialTask}) {
    AppLogging.logInfo('PomodoroTemplateScreen: Opening template selection modal', name: 'PomodoroNavigation');
    AppLogging.logInfo('PomodoroTemplateScreen: Initial task: ${initialTask?.title ?? "none"}', name: 'PomodoroNavigation');

    return showModalBottomSheet<PomodoroTemplate>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => PomodoroTemplateScreen(initialTask: initialTask),
        )
        .then((template) {
          if (template != null) {
            AppLogging.logInfo('PomodoroTemplateScreen: Template selected: ${template.name}', name: 'PomodoroNavigation');
          } else {
            AppLogging.logInfo('PomodoroTemplateScreen: Template selection cancelled', name: 'PomodoroNavigation');
          }
          return template;
        })
        .catchError((error) {
          AppLogging.logError('PomodoroTemplateScreen: Error in template selection: $error', name: 'PomodoroNavigation');
          return null;
        });
  }
}

class _PomodoroTemplateScreenState extends State<PomodoroTemplateScreen> {
  List<PomodoroTemplate> templates = [];
  bool isLoading = true;
  String? selectedTemplateId;

  @override
  void initState() {
    super.initState();
    _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    try {
      final String jsonString = await rootBundle.loadString('lib/ui/screens/home/pomodoro/template.json');
      final Map<String, dynamic> data = json.decode(jsonString) as Map<String, dynamic>;

      // Validate JSON structure
      if (!data.containsKey('pomodoro_templates')) {
        throw FormatException('Invalid template JSON: missing pomodoro_templates key');
      }

      final templatesList = data['pomodoro_templates'] as List?;
      if (templatesList == null) {
        throw FormatException('Invalid template JSON: pomodoro_templates is null');
      }

      templates = templatesList
          .whereType<Map<String, dynamic>>()
          .map((json) {
            try {
              return PomodoroTemplate.fromJson(json);
            } catch (e) {
              AppLogging.logError('Error parsing template: $e, JSON: $json');
              return null;
            }
          })
          .where((template) => template != null && template.name.isNotEmpty)
          .cast<PomodoroTemplate>()
          .toList();

      // Set first template as default selected
      if (templates.isNotEmpty) {
        selectedTemplateId = templates.first.id;
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      AppLogging.logError('Error loading templates: $e');
      setState(() {
        isLoading = false;
        // Create fallback template if loading fails
        templates = [PomodoroTemplate(id: 'classic_25_5', name: 'Classic 25-5', workDuration: 25, restDuration: 5, longRestDuration: 15, cycles: 4, recommendedFor: 'normal')];
        selectedTemplateId = templates.first.id;
      });
    }
  }

  PomodoroTemplate? get selectedTemplate {
    if (templates.isEmpty) return null;
    if (selectedTemplateId == null) return templates.first;

    // Debug logging
    AppLogging.logInfo('Looking for template ID: $selectedTemplateId');
    AppLogging.logInfo('Available templates: ${templates.map((t) => '${t.name} (${t.id})').toList()}');

    try {
      final found = templates.firstWhere((template) => template.id == selectedTemplateId);
      AppLogging.logInfo('Found template: ${found.name} (${found.id})');
      return found;
    } catch (e) {
      AppLogging.logError('Template not found: $selectedTemplateId, falling back to first template. Error: $e');
      // Fallback to first template but log the error
      return templates.first;
    }
  }

  void _selectTemplate(String templateId) {
    setState(() {
      selectedTemplateId = templateId;
    });
    HapticFeedback.lightImpact();
  }

  void _startPomodoro() {
    final template = selectedTemplate;
    AppLogging.logInfo('PomodoroTemplateScreen: _startPomodoro called. selectedTemplate: ${template?.name} (ID: ${template?.id})', name: 'PomodoroNavigation');

    if (template != null) {
      try {
        if (template.isCustom) {
          AppLogging.logInfo('PomodoroTemplateScreen: Opening custom template dialog', name: 'PomodoroNavigation');
          _showCustomTemplateDialog();
        } else {
          AppLogging.logInfo('PomodoroTemplateScreen: Template selected - Work: ${template.workDuration}min, Rest: ${template.restDuration}min, Long Rest: ${template.longRestDuration}min, Cycles: ${template.cycles}', name: 'PomodoroNavigation');
          AppLogging.logInfo('PomodoroTemplateScreen: Template ID: ${template.id}, Name: ${template.name}, RecommendedFor: ${template.recommendedFor}', name: 'PomodoroNavigation');
          HapticFeedback.mediumImpact();

          // Return the selected template and close modal
          Navigator.of(context).pop(template);
          AppLogging.logInfo('PomodoroTemplateScreen: Template selection completed successfully', name: 'PomodoroNavigation');
        }
      } catch (e) {
        AppLogging.logError('PomodoroTemplateScreen: Error in _startPomodoro: $e', name: 'PomodoroNavigation');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to start Pomodoro session. Please try again.'), backgroundColor: Colors.red));
        }
      }
    } else {
      AppLogging.logError('PomodoroTemplateScreen: No template selected in _startPomodoro!', name: 'PomodoroNavigation');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a template to continue.'), backgroundColor: Colors.orange));
      }
    }
  }

  void _showCustomTemplateDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CustomTemplateDialog(
        onTemplateCreated: (customTemplate) {
          Navigator.of(context).pop(customTemplate); // Close both dialogs with result
        },
      ),
    );
  }

  void _closeModal() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.restaurant_menu, color: Colors.orange[600], size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.chooseYourFocusSession,
                        style: TextStyle(color: Colors.black87, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(AppLocalizations.of(context)!.selectATemplateThatFitsYourWorkStyle, style: TextStyle(color: Colors.black54, fontSize: 14)),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _closeModal,
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Templates List
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: templates.length,
                    itemBuilder: (context, index) {
                      final template = templates[index];
                      final isSelected = template.id == selectedTemplateId;

                      return Padding(padding: const EdgeInsets.only(bottom: 16), child: _buildTemplateCard(template, isSelected));
                    },
                  ),
          ),

          // Start Button
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -2))],
            ),
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(28),
                  onTap: _startPomodoro,
                  child: Center(
                    child: Text(
                      AppLocalizations.of(context)!.startFocusSession,
                      style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTemplateCard(PomodoroTemplate template, bool isSelected) {
    return GestureDetector(
      onTap: () => _selectTemplate(template.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.green[400]! : Colors.grey[200]!, width: isSelected ? 2 : 1),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 2))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Clock icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(color: isSelected ? Colors.green[50] : Colors.grey[100], borderRadius: BorderRadius.circular(12)),
                child: Icon(Icons.schedule, color: isSelected ? Colors.green[600] : Colors.grey[600], size: 24),
              ),
              const SizedBox(width: 16),

              // Template details
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Template name
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            template.name,
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        if (template.isCustom) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(8)),
                            child: Text(
                              AppLocalizations.of(context)!.custom,
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.orange[600]),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Work and rest duration
                    Text(AppLocalizations.of(context)!.minWorkRest(template.workDuration.toString(), template.restDuration.toString()), style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    const SizedBox(height: 8),

                    // Tags
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (template.id == 'classic') ...[
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.yellow[100], borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star, color: Colors.yellow[600], size: 14),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        AppLocalizations.of(context)!.mostPopular,
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.yellow[800]),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ] else if (template.recommendedFor == 'adhd') ...[
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(color: Colors.purple[100], borderRadius: BorderRadius.circular(12)),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.auto_awesome, color: Colors.purple[600], size: 14),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        AppLocalizations.of(context)!.recommendedForAdhders,
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.purple[800]),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Play button
              GestureDetector(
                onTap: () {
                  _selectTemplate(template.id);
                  _startPomodoro();
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: isSelected ? Colors.green[400] : Colors.grey[200], borderRadius: BorderRadius.circular(24)),
                  child: Icon(Icons.play_arrow, color: Colors.white, size: 24),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CustomTemplateDialog extends StatefulWidget {
  final Function(PomodoroTemplate) onTemplateCreated;

  const _CustomTemplateDialog({required this.onTemplateCreated});

  @override
  State<_CustomTemplateDialog> createState() => _CustomTemplateDialogState();
}

class _CustomTemplateDialogState extends State<_CustomTemplateDialog> {
  final _formKey = GlobalKey<FormState>();
  final _workController = TextEditingController(text: '25');
  final _restController = TextEditingController(text: '5');
  final _longRestController = TextEditingController(text: '15');
  final _cyclesController = TextEditingController(text: '4');
  final _nameController = TextEditingController(text: 'My Custom Template');

  @override
  void dispose() {
    _workController.dispose();
    _restController.dispose();
    _longRestController.dispose();
    _cyclesController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _createTemplate() {
    if (_formKey.currentState!.validate()) {
      final customTemplate = PomodoroTemplate(
        id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        workDuration: int.parse(_workController.text),
        restDuration: int.parse(_restController.text),
        longRestDuration: int.parse(_longRestController.text),
        cycles: int.parse(_cyclesController.text),
        recommendedFor: 'custom',
        isCustom: true,
      );

      widget.onTemplateCreated(customTemplate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Color(0xFFF8F9FA),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.orange[100], borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.edit, color: Colors.orange[600], size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.makeMyCustomTemplate,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2D3748)),
                      ),
                      Text(AppLocalizations.of(context)!.createYourPerfectPomodoroSetup, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(Icons.close, color: Colors.grey[600]),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Form
          Expanded(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Template Name
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)!.templateName,
                        hintText: AppLocalizations.of(context)!.egMyFocusPower,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        prefixIcon: Icon(Icons.label, color: Colors.grey[600]),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return AppLocalizations.of(context)!.pleaseEnterATemplateName;
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Duration Fields
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _workController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.workMin,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.work, color: Colors.blue[600]),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.required;
                              }
                              final minutes = int.tryParse(value);
                              if (minutes == null || minutes < 1 || minutes > 120) {
                                return AppLocalizations.of(context)!.min120;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _restController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.shortBreakMin,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.coffee, color: Colors.green[600]),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.required;
                              }
                              final minutes = int.tryParse(value);
                              if (minutes == null || minutes < 1 || minutes > 30) {
                                return AppLocalizations.of(context)!.min30;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _longRestController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.longBreakMin,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.weekend, color: Colors.purple[600]),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.required;
                              }
                              final minutes = int.tryParse(value);
                              if (minutes == null || minutes < 1 || minutes > 60) {
                                return AppLocalizations.of(context)!.min60;
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _cyclesController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.cycles,
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              prefixIcon: Icon(Icons.repeat, color: Colors.orange[600]),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!.required;
                              }
                              final cycles = int.tryParse(value);
                              if (cycles == null || cycles < 1 || cycles > 10) {
                                return AppLocalizations.of(context)!.cycles10;
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Preview Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.preview, color: Colors.blue[600], size: 20),
                              const SizedBox(width: 8),
                              Text(
                                AppLocalizations.of(context)!.preview,
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[800]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(AppLocalizations.of(context)!.minWorkMinBreak(_workController.text, _restController.text), style: const TextStyle(fontSize: 16)),
                          Text(AppLocalizations.of(context)!.longBreakAfterCycles(_longRestController.text, _cyclesController.text), style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Create Button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _createTemplate,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[600],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.create, size: 20),
                            SizedBox(width: 8),
                            Text(AppLocalizations.of(context)!.createTemplate, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
