import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  Authenticated(this.user);
}

class Unauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final AppError error;

  AuthFailure(this.error);

  String get errorMessage => error.message;
  ErrorType get errorType => error.type;
}

// Registration states
class RegistrationSuccess extends AuthState {
  final UserEntity user;
  RegistrationSuccess(this.user);
}

// Password reset states
class PasswordResetEmailSent extends AuthState {}

class PasswordResetSuccess extends AuthState {}
