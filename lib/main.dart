import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tazbeet/blocs/auth/auth_event.dart';
import 'package:tazbeet/services/app_logging_service.dart';
import 'package:tazbeet/services/navigation_service.dart';
import 'package:tazbeet/services/analytics_service.dart';
import 'package:tazbeet/services/error_notification_service.dart';
import 'package:tazbeet/services/sync_status_service.dart';
import 'package:tazbeet/services/sync_queue.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tazbeet/services/settings_service.dart' as settings_service;
import 'package:tazbeet/blocs/auth/auth_bloc.dart';
import 'package:tazbeet/blocs/task_list/task_list_bloc.dart';
import 'package:tazbeet/blocs/category/category_bloc.dart';
import 'package:tazbeet/blocs/notification/notification_bloc.dart';
import 'package:tazbeet/repositories/task_repository.dart';
import 'package:tazbeet/repositories/category_repository.dart';
import 'package:tazbeet/ui/screens/splash_screen.dart';
import 'package:tazbeet/ui/screens/onboarding_screen.dart';
import 'package:tazbeet/ui/screens/theme_settings_screen.dart';
import 'package:tazbeet/ui/screens/notification_history_screen.dart';
import 'package:tazbeet/ui/screens/home/main_screen.dart';
import 'package:tazbeet/l10n/app_localizations.dart';
import 'models/mood_streak.dart';
import 'models/user.dart';
import 'models/notification_item.dart';
import 'models/notification_preferences.dart';

import 'package:tazbeet/services/auth_service.dart';
import 'package:tazbeet/services/color_customization_service.dart';
import 'package:tazbeet/services/task_sound_service.dart';
import 'package:tazbeet/services/ambient_service.dart';
import 'package:tazbeet/services/update_service.dart';
import 'package:tazbeet/services/firebase_service_wrapper.dart';
import 'models/mood.dart';
import 'models/mood_achievement.dart';
import 'blocs/mood/mood_bloc.dart';
import 'blocs/task_details/task_details_bloc.dart';
import 'blocs/user/user_bloc.dart';
import 'blocs/notification/notification_event.dart';
import 'repositories/mood_repository.dart';
import 'services/mood_achievement_service.dart';

import 'repositories/user_repository.dart';
import 'repositories/notification_repository.dart';
import 'services/notification_service.dart';
import 'services/background_service.dart';
import 'services/emergency_service.dart';
import 'services/settings_service.dart' as settings;
import 'services/localization_service.dart';
import 'ui/screens/home/mood/mood_input_screen.dart';
import 'ui/screens/notification_preferences_screen.dart';
import 'ui/screens/notification_test_screen.dart';
import 'ui/themes/app_themes.dart';

/* flutter build appbundle --release 
flutter clean && flutter pug get && cd ios && pod install
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with error handling
  final firebaseAvailable = await FirebaseServiceWrapper.initializeFirebase();
  if (!firebaseAvailable) {
    AppLogging.logWarning('Firebase not available - app will work in offline mode');
  }

  // Initialize Analytics & Crashlytics
  final analyticsService = AnalyticsService();
  await analyticsService.initialize();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive adapters
  Hive.registerAdapter(MoodLevelAdapter());
  Hive.registerAdapter(MoodAdapter());
  Hive.registerAdapter(MoodAchievementTypeAdapter());
  Hive.registerAdapter(MoodAchievementAdapter());
  Hive.registerAdapter(MoodStreakAdapter());
  Hive.registerAdapter(UserAdapter());
  // Notification adapters
  Hive.registerAdapter(NotificationTypeAdapter());
  Hive.registerAdapter(NotificationPriorityAdapter());
  Hive.registerAdapter(NotificationActionAdapter());
  Hive.registerAdapter(NotificationDeliveryStatusAdapter());
  Hive.registerAdapter(NotificationItemAdapter());
  Hive.registerAdapter(QuietHoursAdapter());
  Hive.registerAdapter(NotificationTypePreferencesAdapter());
  Hive.registerAdapter(NotificationPreferencesAdapter());

  // Initialize notification service
  final notificationService = NotificationService();
  await notificationService.initialize();

  // Initialize background service
  final backgroundService = BackgroundService();
  await backgroundService.initialize();

  // Initialize settings service
  final settingsService = settings.SettingsService();
  await settingsService.initialize();

  // Schedule mood check-in notifications if enabled
  if (settingsService.settings.enableMoodNotifications) {
    await notificationService.scheduleMoodCheckInNotifications(settingsService.settings.moodCheckInTimes);
  }

  // Initialize sync queue
  await syncQueue.initialize();

  // Initialize auth service
  final authService = AuthService();

  // Initialize task sound service
  final taskSoundService = TaskSoundService();
  await taskSoundService.initialize();

  // Initialize update service
  final updateService = UpdateService();
  if (kDebugMode) {
    // Initialize sync status service
    final syncStatusService = SyncStatusService();
    await syncStatusService.initialize();

    // Initialize performance monitor service (singleton)
    /*  if (kDebugMode) {
      PerformanceMonitorService();
      AppLogging.logInfo('Performance monitor initialized');

      // Initialize memory manager service (singleton)
      MemoryManagerService().initialize();
      AppLogging.logInfo('Memory manager initialized');

      // Initialize animation optimizer service (singleton)
      AnimationOptimizerService().initialize();
      AppLogging.logInfo('Animation optimizer initialized');

      // Initialize code quality monitor service (singleton)
      CodeQualityMonitorService();
      AppLogging.logInfo('Code quality monitor initialized');
    } */
  }

  // Perform automatic update check
  await updateService.checkForUpdatesAutomatically();

  // Initialize repositories
  final taskRepository = TaskRepository();
  final categoryRepository = CategoryRepository();
  final moodRepository = MoodRepository();
  final userRepository = UserRepository();
  final notificationRepository = NotificationRepository();
  final colorCustomizationService = ColorCustomizationService();

  // Initialize mood achievement service
  final moodAchievementService = MoodAchievementService();
  await moodAchievementService.init();

  await taskRepository.init();
  await categoryRepository.init();
  await moodRepository.init();
  await notificationRepository.init();
  await colorCustomizationService.initialize();

  // Create default categories if they don't exist  await categoryRepository.createDefaultCategories();

  runApp(
    Tazbeet(
      taskRepository: taskRepository,
      categoryRepository: categoryRepository,
      notificationService: notificationService,
      notificationRepository: notificationRepository,
      settingsService: settingsService,
      moodRepository: moodRepository,
      userRepository: userRepository,
      colorCustomizationService: colorCustomizationService,
      authService: authService,
      taskSoundService: taskSoundService,
      updateService: updateService,
      analyticsService: analyticsService,
    ),
  );
}

class Tazbeet extends StatelessWidget {
  final TaskRepository taskRepository;
  final CategoryRepository categoryRepository;
  final NotificationService notificationService;
  final NotificationRepository notificationRepository;
  final settings.SettingsService settingsService;
  final MoodRepository moodRepository;
  final UserRepository userRepository;
  final ColorCustomizationService colorCustomizationService;
  final AuthService authService;
  final TaskSoundService taskSoundService;
  final UpdateService updateService;
  final AnalyticsService analyticsService;

  const Tazbeet({
    super.key,
    required this.taskRepository,
    required this.categoryRepository,
    required this.notificationService,
    required this.notificationRepository,
    required this.settingsService,
    required this.moodRepository,
    required this.userRepository,
    required this.colorCustomizationService,
    required this.authService,
    required this.taskSoundService,
    required this.updateService,
    required this.analyticsService,
  });

  ThemeMode _getThemeMode(settings_service.ThemeMode customThemeMode) {
    switch (customThemeMode) {
      case settings_service.ThemeMode.light:
        return ThemeMode.light;
      case settings_service.ThemeMode.dark:
        return ThemeMode.dark;
      case settings_service.ThemeMode.system:
        return ThemeMode.system;
    }
  }

  Locale _getLocale(String languageCode) {
    return AppLocalizations.supportedLocales.contains(Locale(languageCode)) ? Locale(languageCode) : const Locale('en');
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<TaskRepository>.value(value: taskRepository),
        Provider<CategoryRepository>.value(value: categoryRepository),
        Provider<MoodRepository>.value(value: moodRepository),
        Provider<UserRepository>.value(value: userRepository),
        Provider<NotificationRepository>.value(value: notificationRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(create: (context) => AuthBloc(authService)..add(AuthStarted())),
          BlocProvider<TaskListBloc>(
            create: (context) => TaskListBloc(taskRepository: context.read<TaskRepository>(), categoryRepository: context.read<CategoryRepository>(), notificationService: notificationService),
          ),
          BlocProvider<TaskDetailsBloc>(create: (context) => TaskDetailsBloc(taskRepository: context.read<TaskRepository>())),
          BlocProvider<CategoryBloc>(
            create: (context) => CategoryBloc(categoryRepository: context.read<CategoryRepository>(), taskRepository: context.read<TaskRepository>()),
          ),
          BlocProvider<MoodBloc>(create: (context) => MoodBloc(context.read<MoodRepository>())),
          BlocProvider<UserBloc>(create: (context) => UserBloc(context.read<UserRepository>())),
          BlocProvider<NotificationBloc>(
            create: (context) => NotificationBloc(repository: context.read<NotificationRepository>(), notificationService: notificationService)..add(const InitializeNotifications()),
          ),
        ],
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: settingsService),
            ChangeNotifierProvider.value(value: colorCustomizationService),
            ChangeNotifierProvider<AmbientService>(create: (_) => AmbientService()),
            ChangeNotifierProvider<EmergencyService>(create: (_) => EmergencyService()),
            ChangeNotifierProvider.value(value: taskSoundService),
            ChangeNotifierProvider.value(value: updateService),
            Provider<AnalyticsService>.value(value: analyticsService),
          ],
          child: Consumer2<settings.SettingsService, ColorCustomizationService>(
            builder: (context, settingsService, colorCustomizationService, child) {
              // Initialize localization service
              LocalizationService.initialize(context);

              return MaterialApp(
                debugShowCheckedModeBanner: false,
                navigatorKey: NavigationService.navigatorKey,
                scaffoldMessengerKey: ErrorNotificationService.scaffoldMessengerKey ??= GlobalKey<ScaffoldMessengerState>(),
                navigatorObservers: [analyticsService.getAnalyticsObserver()],
                title: 'Tazbeet',
                routes: {
                  '/onboarding': (context) => const OnboardingScreen(),
                  '/main': (context) => const MainScreen(),
                  '/accessibility_setup': (context) => const AccessibilityOnboardingScreen(),
                  '/theme_settings': (context) => const ThemeSettingsScreen(),
                  '/mood_input': (context) => BlocProvider.value(value: context.read<MoodBloc>(), child: const MoodInputScreen()),
                  '/notification_history': (context) => BlocProvider.value(value: context.read<NotificationBloc>(), child: const NotificationHistoryScreen()),
                  '/notification_preferences': (context) => BlocProvider.value(value: context.read<NotificationBloc>(), child: const NotificationPreferencesScreen()),
                  '/notification_test': (context) => BlocProvider.value(value: context.read<NotificationBloc>(), child: const NotificationTestScreen()),
                },
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
                home: const SplashScreen(),
              );
            },
          ),
        ),
      ),
    );
  }
}
