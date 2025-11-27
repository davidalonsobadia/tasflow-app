/// Base exception class for all application-specific exceptions
abstract class AppException implements Exception {
  final String message;
  final Object? cause;

  AppException(this.message, [this.cause]);

  @override
  String toString() => '$runtimeType: $message';
}

/// Network-related exceptions
class NetworkException extends AppException {
  NetworkException(super.message, [super.cause]);
}

/// Authentication-related exceptions
class AuthenticationException extends AppException {
  AuthenticationException(super.message, [super.cause]);
}

/// Server-related exceptions
class ServerException extends AppException {
  ServerException(super.message, [super.cause]);
}

/// Resource not found exceptions
class NotFoundException extends AppException {
  NotFoundException(super.message, [super.cause]);
}

/// Permission-related exceptions
class PermissionException extends AppException {
  PermissionException(super.message, [super.cause]);
}

/// Validation-related exceptions
class ValidationException extends AppException {
  ValidationException(super.message, [super.cause]);
}

/// Unknown or unexpected exceptions
class UnknownException extends AppException {
  UnknownException(super.message, [super.cause]);
}
