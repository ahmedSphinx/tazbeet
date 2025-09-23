// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tazbeet/main.dart';
import 'package:tazbeet/repositories/mood_repository.dart';
import 'package:tazbeet/repositories/task_repository.dart';
import 'package:tazbeet/repositories/category_repository.dart';
import 'package:tazbeet/repositories/user_repository.dart';
import 'package:tazbeet/services/auth_service.dart';
import 'package:tazbeet/services/color_customization_service.dart';
import 'package:tazbeet/services/task_sound_service.dart';
import 'package:tazbeet/services/notification_service.dart';
import 'package:tazbeet/services/settings_service.dart';
import 'package:tazbeet/services/update_service.dart';

void main() {
  late TaskRepository taskRepository;
  late CategoryRepository categoryRepository;
  late NotificationService notificationService;
  late SettingsService settingsService;
  late MoodRepository moodRepository;
  late ColorCustomizationService colorCustomizationService;
  late AuthService authService;
  late UserRepository userRepository;
  late TaskSoundService taskSoundService;
  late UpdateService updateService;

  setUp(() async {
    await Hive.initFlutter();
    taskRepository = TaskRepository();
    categoryRepository = CategoryRepository();
    notificationService = NotificationService();
    settingsService = SettingsService();
    moodRepository = MoodRepository();
    colorCustomizationService = ColorCustomizationService();
    authService = AuthService();
    userRepository = UserRepository();
    taskSoundService = TaskSoundService();
    await settingsService.initialize();
    await moodRepository.init();
    await taskRepository.init();
    await categoryRepository.init();
    await colorCustomizationService.initialize();
    await userRepository.init();
    await notificationService.initialize();
    await taskSoundService.initialize();
    updateService = UpdateService();
  });

  tearDown(() async {
    await Hive.close();
  });

  testWidgets('App loads and displays empty task list', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MyApp(
        taskRepository: taskRepository,
        categoryRepository: categoryRepository,
        notificationService: notificationService,
        settingsService: settingsService,
        moodRepository: moodRepository,
        colorCustomizationService: colorCustomizationService,
        authService: authService,
        userRepository: userRepository,
        taskSoundService: taskSoundService,
        updateService: updateService,
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Tazbeet'), findsOneWidget);
  });
}
