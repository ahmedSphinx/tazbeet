import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:tazbeet/blocs/auth/auth_bloc.dart';
import 'package:tazbeet/blocs/auth/auth_event.dart';
import 'package:tazbeet/blocs/auth/auth_state.dart';
import 'package:tazbeet/blocs/mood/mood_bloc.dart';
import 'package:tazbeet/blocs/task_details/task_details_bloc.dart';
import 'package:tazbeet/blocs/user/user_bloc.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'package:tazbeet/services/auth_service.dart';
import 'package:tazbeet/services/color_customization_service.dart';
import 'package:tazbeet/services/task_sound_service.dart';
import 'package:tazbeet/services/ambient_service.dart';
import 'package:tazbeet/services/update_service.dart';
import 'package:tazbeet/services/firebase_service_wrapper.dart';
import 'models/mood.dart';
import 'models/user.dart';
import 'blocs/task_list/task_list_bloc.dart';
import 'blocs/category/category_bloc.dart';
import 'repositories/task_repository.dart';
import 'repositories/category_repository.dart';
import 'repositories/mood_repository.dart';
import 'repositories/user_repository.dart';
import 'services/notification_service.dart';
import 'services/background_service.dart';
import 'services/emergency_service.dart';
import 'services/settings_service.dart' as settings;
import 'services/localization_service.dart';

import 'ui/screens/splash_screen.dart';
import 'ui/themes/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  final firebaseAvailable = await FirebaseServiceWrapper.initializeFirebase();
  if (!firebaseAvailable) {
    debugPrint('Firebase not available - app will work in offline mode');
  }

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(MoodLevelAdapter());
  Hive.registerAdapter(MoodAdapter());
  Hive.registerAdapter(UserAdapter());

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Initialize background service
  final backgroundService = BackgroundService();
  await backgroundService.initialize();

  // Initialize settings service
  final settingsService = settings.SettingsService();
  await settingsService.initialize();

  // Initialize auth service
  final authService = AuthService();

  // Initialize task sound service
  final taskSoundService = TaskSoundService();
  await taskSoundService.initialize();

  // Initialize update service
  final updateService = UpdateService();

  // Perform automatic update check
  await updateService.checkForUpdatesAutomatically();

  // Initialize repositories
  final taskRepository = TaskRepository();
  final categoryRepository = CategoryRepository();
  final moodRepository = MoodRepository();
  final userRepository = UserRepository();
  final colorCustomizationService = ColorCustomizationService();

  await taskRepository.init();
  await categoryRepository.init();
  await moodRepository.init();
  await colorCustomizationService.initialize();

  // Create default categories if they don't exist  await categoryRepository.createDefaultCategories();

  runApp(
    MyApp(
      taskRepository: taskRepository,
      categoryRepository: categoryRepository,
      notificationService: notificationService,
      settingsService: settingsService,
      moodRepository: moodRepository,
      userRepository: userRepository,
      colorCustomizationService: colorCustomizationService,
      authService: authService,
      taskSoundService: taskSoundService,
      updateService: updateService,
    ),
  );
}

class MyApp extends StatelessWidget {
  final TaskRepository taskRepository;
  final CategoryRepository categoryRepository;
  final NotificationService notificationService;
  final settings.SettingsService settingsService;
  final MoodRepository moodRepository;
  final UserRepository userRepository;
  final ColorCustomizationService colorCustomizationService;
  final AuthService authService;
  final TaskSoundService taskSoundService;
  final UpdateService updateService;

  const MyApp({
    super.key,
    required this.taskRepository,
    required this.categoryRepository,
    required this.notificationService,
    required this.settingsService,
    required this.moodRepository,
    required this.userRepository,
    required this.colorCustomizationService,
    required this.authService,
    required this.taskSoundService,
    required this.updateService,
  });

  ThemeMode _getThemeMode(settings.ThemeMode customThemeMode) {
    switch (customThemeMode) {
      case settings.ThemeMode.light:
        return ThemeMode.light;
      case settings.ThemeMode.dark:
        return ThemeMode.dark;
      case settings.ThemeMode.system:
        return ThemeMode.system;
    }
  }

  Locale _getLocale(String languageCode) {
    return Locale(languageCode);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TaskRepository>.value(value: taskRepository),
        Provider<CategoryRepository>.value(value: categoryRepository),
        Provider<MoodRepository>.value(value: moodRepository),
        Provider<UserRepository>.value(value: userRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc(authService)..add(AuthStarted())),
          BlocProvider<TaskListBloc>(
            create: (context) => TaskListBloc(taskRepository: context.read<TaskRepository>(), categoryRepository: context.read<CategoryRepository>(), notificationService: notificationService),
          ),
          BlocProvider<TaskDetailsBloc>(create: (context) => TaskDetailsBloc(taskRepository: context.read<TaskRepository>())),
          BlocProvider<CategoryBloc>(create: (context) => CategoryBloc(categoryRepository: context.read<CategoryRepository>())),
          BlocProvider<MoodBloc>(create: (context) => MoodBloc(context.read<MoodRepository>())),
          BlocProvider<UserBloc>(create: (context) => UserBloc(context.read<UserRepository>())),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: settingsService),
            ChangeNotifierProvider.value(value: colorCustomizationService),
            ChangeNotifierProvider.value(value: AmbientService()),
            ChangeNotifierProvider.value(value: EmergencyService()),
            ChangeNotifierProvider.value(value: taskSoundService),
            ChangeNotifierProvider.value(value: updateService),
          ],
          child: Consumer2<settings.SettingsService, ColorCustomizationService>(
            builder: (context, settingsService, colorCustomizationService, child) {
              // Initialize localization service
              LocalizationService.initialize(context);

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'Tazbeet',
                theme: AppThemes.getLightThemeWithCustomization(colorCustomizationService),
                darkTheme: AppThemes.getDarkThemeWithCustomization(colorCustomizationService),
                themeMode: _getThemeMode(settingsService.settings.themeMode),
                builder: (context, child) {
                  final mediaQuery = MediaQuery.of(context);
                  return MediaQuery(
                    data: mediaQuery.copyWith(textScaler: TextScaler.linear(settingsService.settings.enableLargeText ? 1.3 : 1.0)),
                    child: child!,
                  );
                },
                locale: _getLocale(settingsService.settings.language),
                localizationsDelegates: const [AppLocalizations.delegate, GlobalMaterialLocalizations.delegate, GlobalWidgetsLocalizations.delegate, GlobalCupertinoLocalizations.delegate],
                supportedLocales: AppLocalizations.supportedLocales,
                home: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    return const SplashScreen();
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
