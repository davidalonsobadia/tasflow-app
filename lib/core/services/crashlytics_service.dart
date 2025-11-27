import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

/// Service wrapper for Firebase Crashlytics
/// Provides a clean interface for crash reporting and error logging
/// following best practices and supporting multiple environments
abstract class CrashlyticsService {
  /// Initialize Crashlytics with environment-specific settings
  Future<void> initialize({required bool isProduction});

  /// Log a non-fatal error with optional stack trace
  Future<void> logError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    Iterable<Object>? information,
    bool fatal = false,
  });

  /// Log a message for debugging purposes
  void log(String message);

  /// Set user identifier for crash reports
  Future<void> setUserIdentifier(String identifier);

  /// Set custom key-value pairs for crash reports
  Future<void> setCustomKey(String key, dynamic value);

  /// Check if crash collection is enabled
  bool get isCrashlyticsCollectionEnabled;

  /// Enable or disable crash collection
  Future<void> setCrashlyticsCollectionEnabled(bool enabled);
}

/// Implementation of CrashlyticsService using Firebase Crashlytics
/// Only active in PRODUCTION environment
class FirebaseCrashlyticsService implements CrashlyticsService {
  // Lazy getter to avoid accessing Firebase before initialization
  FirebaseCrashlytics get _crashlytics => FirebaseCrashlytics.instance;
  bool _isProduction = false;

  @override
  Future<void> initialize({required bool isProduction}) async {
    _isProduction = isProduction;

    // Only initialize Crashlytics in production environment
    if (!isProduction) {
      if (kDebugMode) {
        debugPrint('Crashlytics: Skipped initialization (dev environment)');
      }
      return;
    }

    try {
      // Enable Crashlytics collection
      await _crashlytics.setCrashlyticsCollectionEnabled(true);
      log('Crashlytics initialized in PRODUCTION mode');

      // Pass all uncaught errors from the Flutter framework to Crashlytics
      FlutterError.onError = (FlutterErrorDetails details) {
        _crashlytics.recordFlutterFatalError(details);
      };

      // Pass all uncaught asynchronous errors to Crashlytics
      PlatformDispatcher.instance.onError = (error, stack) {
        _crashlytics.recordError(error, stack, fatal: true);
        return true;
      };

      log('Crashlytics initialization completed');
    } catch (e, stackTrace) {
      // If Crashlytics fails to initialize, log to console
      debugPrint('Failed to initialize Crashlytics: $e');
      debugPrint('Stack trace: $stackTrace');
    }
  }

  @override
  Future<void> logError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    Iterable<Object>? information,
    bool fatal = false,
  }) async {
    // Only log to Crashlytics in production
    if (!_isProduction) {
      if (kDebugMode) {
        debugPrint('Dev Error: $exception');
        if (stackTrace != null) debugPrint('Stack trace: $stackTrace');
      }
      return;
    }

    try {
      // Log additional information if provided
      if (reason != null) {
        log('Error reason: $reason');
      }

      if (information != null) {
        for (var info in information) {
          log('Additional info: $info');
        }
      }

      // Record the error to Crashlytics
      await _crashlytics.recordError(
        exception,
        stackTrace,
        reason: reason,
        information: information != null ? List<Object>.from(information) : [],
        fatal: fatal,
      );

      // Also log to console in debug mode
      if (kDebugMode) {
        debugPrint('Crashlytics Error: $exception');
        if (stackTrace != null) {
          debugPrint('Stack trace: $stackTrace');
        }
      }
    } catch (e) {
      debugPrint('Failed to log error to Crashlytics: $e');
    }
  }

  @override
  void log(String message) {
    // Only log to Crashlytics in production
    if (!_isProduction) {
      if (kDebugMode) {
        debugPrint('Dev Log: $message');
      }
      return;
    }

    try {
      _crashlytics.log(message);
      if (kDebugMode) {
        debugPrint('Crashlytics Log: $message');
      }
    } catch (e) {
      debugPrint('Failed to log message to Crashlytics: $e');
    }
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    // Only set in production
    if (!_isProduction) return;

    try {
      await _crashlytics.setUserIdentifier(identifier);
      log('User identifier set: $identifier');
    } catch (e) {
      debugPrint('Failed to set user identifier: $e');
    }
  }

  @override
  Future<void> setCustomKey(String key, dynamic value) async {
    // Only set in production
    if (!_isProduction) return;

    try {
      await _crashlytics.setCustomKey(key, value);
      if (kDebugMode) {
        debugPrint('Custom key set: $key = $value');
      }
    } catch (e) {
      debugPrint('Failed to set custom key: $e');
    }
  }

  @override
  bool get isCrashlyticsCollectionEnabled {
    if (!_isProduction) return false;
    return _crashlytics.isCrashlyticsCollectionEnabled;
  }

  @override
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    // Only allow in production
    if (!_isProduction) return;

    try {
      await _crashlytics.setCrashlyticsCollectionEnabled(enabled);
      log('Crashlytics collection ${enabled ? 'enabled' : 'disabled'}');
    } catch (e) {
      debugPrint('Failed to set Crashlytics collection enabled: $e');
    }
  }
}

/// Mock implementation for testing
class MockCrashlyticsService implements CrashlyticsService {
  final List<String> _logs = [];
  final List<Map<String, dynamic>> _errors = [];
  bool _isEnabled = false;

  List<String> get logs => List.unmodifiable(_logs);
  List<Map<String, dynamic>> get errors => List.unmodifiable(_errors);

  @override
  Future<void> initialize({required bool isProduction}) async {
    _isEnabled = true;
    _logs.add('Mock Crashlytics initialized (production: $isProduction)');
  }

  @override
  Future<void> logError(
    dynamic exception,
    StackTrace? stackTrace, {
    String? reason,
    Iterable<Object>? information,
    bool fatal = false,
  }) async {
    _errors.add({
      'exception': exception,
      'stackTrace': stackTrace,
      'reason': reason,
      'information': information,
      'fatal': fatal,
      'timestamp': DateTime.now(),
    });
  }

  @override
  void log(String message) {
    _logs.add(message);
  }

  @override
  Future<void> setUserIdentifier(String identifier) async {
    _logs.add('User identifier: $identifier');
  }

  @override
  Future<void> setCustomKey(String key, dynamic value) async {
    _logs.add('Custom key: $key = $value');
  }

  @override
  bool get isCrashlyticsCollectionEnabled => _isEnabled;

  @override
  Future<void> setCrashlyticsCollectionEnabled(bool enabled) async {
    _isEnabled = enabled;
  }

  void clear() {
    _logs.clear();
    _errors.clear();
  }
}

