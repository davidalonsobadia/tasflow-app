import 'package:taskflow_app/config/app_config.dart';
import 'package:taskflow_app/config/constants/responsive_constants.dart';
import 'package:taskflow_app/config/routes/router.dart';
import 'package:taskflow_app/config/themes/theme_config.dart';
import 'package:taskflow_app/core/di/service_locator.dart';
import 'package:taskflow_app/core/observers/app_bloc_observer.dart';
import 'package:taskflow_app/core/providers/app_providers.dart';
import 'package:taskflow_app/core/services/crashlytics_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:get_it/get_it.dart';

const String appFlavor = String.fromEnvironment(
  'appFlavor',
  defaultValue: 'dev',
);

// Firebase is currently disabled - set to true once Firebase project is created
// and google-services.json / GoogleService-Info.plist are configured
const bool firebaseEnabled = false;

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load configuration
  await AppConfig.initialize(appFlavor);

  // Setup dependency injection
  setupServiceLocator();

  // Get crashlytics service (will be no-op when Firebase is disabled)
  final crashlyticsService = GetIt.instance<CrashlyticsService>();

  // Firebase is currently disabled - enable once Firebase project is configured
  // When Firebase is enabled, it will only initialize in production
  if (firebaseEnabled) {
    final isProduction = AppConfig.instance.environment == Environment.prod;
    if (isProduction) {
      try {
        // Uncomment when Firebase is configured:
        // await Firebase.initializeApp(
        //   options: DefaultFirebaseOptions.currentPlatform,
        // );
        await crashlyticsService.initialize(isProduction: true);
        await crashlyticsService.setCustomKey('environment', appFlavor);
        await crashlyticsService.setCustomKey('app_version', '1.0.0');
      } catch (e) {
        debugPrint('Firebase initialization failed: $e');
        debugPrint('App will continue without Crashlytics...');
        await crashlyticsService.initialize(isProduction: false);
      }
    } else {
      await crashlyticsService.initialize(isProduction: false);
    }
  } else {
    // Firebase is disabled - initialize crashlytics in no-op mode
    debugPrint('Firebase is disabled - Crashlytics will run in no-op mode');
    await crashlyticsService.initialize(isProduction: false);
  }

  // Set up BlocObserver to log all Bloc errors to Crashlytics (prod) or console (dev)
  Bloc.observer = AppBlocObserver(crashlyticsService);

  // Create localization delegate and run app
  var delegate = await LocalizationDelegate.create(
    fallbackLocale: 'es_ES',
    supportedLocales: ['es_ES'],
  );

  runApp(LocalizedApp(delegate, MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var localizationDelegate = LocalizedApp.of(context).delegate;

    return AppProviders(
      child: LocalizationProvider(
        state: LocalizationProvider.of(context).state,
        child: MaterialApp.router(
          title: 'Taskflow',
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            localizationDelegate,
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
          theme: theme,
          builder: (context, child) {
            final width = MediaQuery.of(context).size.width;
            final scaleFactor = width / ResponsiveConstants.figmaBaseWidth;

            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(scaleFactor)),
              child: child ?? const SizedBox.shrink(),
            );
          },
          routerConfig: appRouter,
        ),
      ),
    );
  }
}
