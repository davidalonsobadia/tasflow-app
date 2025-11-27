import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taskflow_app/core/services/crashlytics_service.dart';

/// Custom BlocObserver that logs all Bloc events and errors to Crashlytics
/// This helps track state management issues and errors in production
class AppBlocObserver extends BlocObserver {
  final CrashlyticsService _crashlyticsService;

  AppBlocObserver(this._crashlyticsService);

  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    if (kDebugMode) {
      debugPrint('Bloc created: ${bloc.runtimeType}');
    }
    _crashlyticsService.log('Bloc created: ${bloc.runtimeType}');
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    if (kDebugMode) {
      debugPrint('Bloc event: ${bloc.runtimeType} - $event');
    }
    _crashlyticsService.log('Bloc event: ${bloc.runtimeType} - $event');
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    if (kDebugMode) {
      debugPrint('Bloc change: ${bloc.runtimeType} - $change');
    }
    // Only log state changes in production if needed
    // Uncomment the line below if you want to track all state changes
    // _crashlyticsService.log('Bloc change: ${bloc.runtimeType}');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    if (kDebugMode) {
      debugPrint('Bloc transition: ${bloc.runtimeType} - $transition');
    }
    // Only log transitions in production if needed
    // Uncomment the line below if you want to track all transitions
    // _crashlyticsService.log('Bloc transition: ${bloc.runtimeType}');
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);

    // Always log errors to console in debug mode
    if (kDebugMode) {
      debugPrint('Bloc error: ${bloc.runtimeType} - $error');
      debugPrint('Stack trace: $stackTrace');
    }

    // Log all Bloc errors to Crashlytics
    _crashlyticsService.logError(
      error,
      stackTrace,
      reason: 'Bloc error in ${bloc.runtimeType}',
      information: [
        'Bloc type: ${bloc.runtimeType}',
        'Current state: ${bloc.state}',
      ],
      fatal: false, // Bloc errors are usually non-fatal
    );
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    if (kDebugMode) {
      debugPrint('Bloc closed: ${bloc.runtimeType}');
    }
    _crashlyticsService.log('Bloc closed: ${bloc.runtimeType}');
  }
}
