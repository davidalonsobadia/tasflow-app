import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Mixin for Cubits/Blocs to handle errors consistently with optional Crashlytics reporting
///
/// Usage:
/// ```dart
/// class MyCubit extends Cubit<MyState> with ErrorReportingMixin {
///   Future<void> someOperation() async {
///     try {
///       // ... your code
///     } catch (exception, stackTrace) {
///       handleError(
///         exception,
///         stackTrace,
///         shouldReport: true, // Report to Crashlytics
///         context: 'someOperation',
///       );
///       emit(MyFailureState(ErrorHandler.handle(exception)));
///     }
///   }
/// }
/// ```
mixin ErrorReportingMixin<T> on BlocBase<T> {
  /// Handle an error with optional Crashlytics reporting
  ///
  /// [exception] - The exception that was caught
  /// [stackTrace] - The stack trace of the exception
  /// [shouldReport] - Whether to report this error to Crashlytics (via BlocObserver)
  /// [context] - Optional context string for debugging (e.g., method name)
  void handleError(
    Object exception,
    StackTrace stackTrace, {
    required bool shouldReport,
    String? context,
  }) {
    // Print to console in debug mode
    if (kDebugMode) {
      final contextStr = context != null ? ' in $context' : '';
      debugPrint('Error$contextStr: ${exception.toString()}');
      debugPrint('Stack trace: $stackTrace');
    }

    // Report to Crashlytics via BlocObserver if requested
    if (shouldReport) {
      addError(exception, stackTrace);
    }
  }
}

