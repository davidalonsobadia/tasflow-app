import 'package:dio/dio.dart';
import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:flutter_translate/flutter_translate.dart';

class AppError {
  final String message;
  final ErrorType type;
  final Object? originalError;

  AppError({required this.message, required this.type, this.originalError});
}

enum ErrorType {
  network,
  authentication,
  server,
  notFound,
  permission,
  validation,
  unknown,
}

class ErrorHandler {
  static AppError handle(Object error) {
    // If already an AppError, return it directly to avoid double-wrapping
    if (error is AppError) {
      return error;
    }

    // Handle custom exceptions
    if (error is NetworkException) {
      return AppError(
        message: error.message,
        type: ErrorType.network,
        originalError: error,
      );
    } else if (error is AuthenticationException) {
      return AppError(
        message: error.message,
        type: ErrorType.authentication,
        originalError: error,
      );
    } else if (error is ServerException) {
      return AppError(
        message: error.message,
        type: ErrorType.server,
        originalError: error,
      );
    } else if (error is NotFoundException) {
      return AppError(
        message: error.message,
        type: ErrorType.notFound,
        originalError: error,
      );
    } else if (error is PermissionException) {
      return AppError(
        message: error.message,
        type: ErrorType.permission,
        originalError: error,
      );
    } else if (error is ValidationException) {
      return AppError(
        message: error.message,
        type: ErrorType.validation,
        originalError: error,
      );
    } else if (error is UnknownException) {
      return AppError(
        message: error.message,
        type: ErrorType.unknown,
        originalError: error,
      );
    }

    // Handle Dio errors
    if (error is DioException) {
      return _handleDioError(error);
    } else if (error is TypeError) {
      return AppError(
        message: translate('unexpectedError'),
        type: ErrorType.unknown,
        originalError: error,
      );
    } else {
      // Handle any other exceptions with a generic message
      return AppError(
        message: error.toString(),
        type: ErrorType.unknown,
        originalError: error,
      );
    }
  }

  static AppError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppError(
          message: translate('connectionTimeout'),
          type: ErrorType.network,
          originalError: error,
        );

      case DioExceptionType.connectionError:
        return AppError(
          message: translate('noInternetConnection'),
          type: ErrorType.network,
          originalError: error,
        );

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode, error);

      case DioExceptionType.cancel:
        return AppError(
          message: translate('requestCancelled'),
          type: ErrorType.unknown,
          originalError: error,
        );

      default:
        return AppError(
          message: translate('unexpectedErrorTryAgain'),
          type: ErrorType.unknown,
          originalError: error,
        );
    }
  }

  static AppError _handleStatusCode(int? statusCode, DioException error) {
    switch (statusCode) {
      case 400:
        return AppError(
          message: translate('invalidRequest'),
          type: ErrorType.validation,
          originalError: error,
        );
      case 401:
        return AppError(
          message: translate('authenticationFailed'),
          type: ErrorType.authentication,
          originalError: error,
        );
      case 403:
        return AppError(
          message: translate('permissionDenied'),
          type: ErrorType.permission,
          originalError: error,
        );
      case 404:
        return AppError(
          message: translate('resourceNotFound'),
          type: ErrorType.notFound,
          originalError: error,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return AppError(
          message: translate('serverError'),
          type: ErrorType.server,
          originalError: error,
        );
      default:
        return AppError(
          message: translate('unexpectedErrorTryAgain'),
          type: ErrorType.unknown,
          originalError: error,
        );
    }
  }
}
