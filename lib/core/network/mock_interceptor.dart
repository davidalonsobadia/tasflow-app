import 'dart:math';
import 'package:dio/dio.dart';
import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A Dio interceptor that can simulate various error scenarios for testing purposes.
class MockErrorInterceptor extends Interceptor {
  bool enabled = false;
  ErrorType errorType = ErrorType.network;
  double errorProbability = 1.0; // 0.0 to 1.0, default is 100% error rate
  final Random _random = Random();

  // Keys for SharedPreferences
  static const String _enabledKey = 'mock_error_enabled';
  static const String _errorTypeKey = 'mock_error_type';
  static const String _probabilityKey = 'mock_error_probability';

  MockErrorInterceptor() {
    _loadSettings();
  }

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    enabled = prefs.getBool(_enabledKey) ?? false;
    final typeIndex = prefs.getInt(_errorTypeKey) ?? 0;
    errorType = ErrorType.values[typeIndex];
    errorProbability = prefs.getDouble(_probabilityKey) ?? 1.0;
  }

  /// Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, enabled);
    await prefs.setInt(_errorTypeKey, errorType.index);
    await prefs.setDouble(_probabilityKey, errorProbability);
  }

  /// Enable or disable the mock interceptor
  void setEnabled(bool isEnabled) {
    enabled = isEnabled;
    _saveSettings();
  }

  /// Configure the mock error type and probability
  void configure({required ErrorType type, double probability = 1.0}) {
    errorType = type;
    errorProbability = probability.clamp(0.0, 1.0);
    _saveSettings();
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!enabled || _random.nextDouble() > errorProbability) {
      // No error simulation, proceed normally
      return handler.next(options);
    }

    // Simulate different error types
    switch (errorType) {
      case ErrorType.network:
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            error: Exception("Simulated network error"),
            message:
                "Network connection error. Please check your internet connection.",
          ),
        );

      case ErrorType.authentication:
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            error: Exception("Simulated authentication error"),
            message: "Authentication failed",
            response: Response(
              requestOptions: options,
              statusCode: 401,
              data: {
                "error": "Unauthorized",
                "message": "Your session has expired",
              },
            ),
          ),
        );

      case ErrorType.server:
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            error: Exception("Simulated server error"),
            message: "Server error",
            response: Response(
              requestOptions: options,
              statusCode: 500,
              data: {"error": "Internal Server Error"},
            ),
          ),
        );

      case ErrorType.notFound:
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            error: Exception("Simulated not found error"),
            message: "Resource not found",
            response: Response(
              requestOptions: options,
              statusCode: 404,
              data: {
                "error": "Not Found",
                "message": "The requested resource was not found",
              },
            ),
          ),
        );

      case ErrorType.permission:
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            error: Exception("Simulated permission error"),
            message: "Permission denied",
            response: Response(
              requestOptions: options,
              statusCode: 403,
              data: {
                "error": "Forbidden",
                "message": "You don't have permission to access this resource",
              },
            ),
          ),
        );

      case ErrorType.validation:
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.badResponse,
            error: Exception("Simulated validation error"),
            message: "Validation error",
            response: Response(
              requestOptions: options,
              statusCode: 400,
              data: {
                "error": "Bad Request",
                "message": "Invalid data format received",
              },
            ),
          ),
        );

      case ErrorType.unknown:
        return handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.unknown,
            error: Exception("Simulated unknown error"),
            message: "An unexpected error occurred",
          ),
        );
    }
  }
}
