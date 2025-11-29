import 'package:taskflow_app/core/mixins/error_reporting_mixin.dart';
import 'package:taskflow_app/core/utils/device_utils.dart';
import 'package:taskflow_app/core/utils/error_handler.dart';
import 'package:taskflow_app/features/auth/domain/usecases/check_device_registered.dart';
import 'package:taskflow_app/features/auth/domain/usecases/forgot_password_use_case.dart';
import 'package:taskflow_app/features/auth/domain/usecases/login_use_case.dart';
import 'package:taskflow_app/features/auth/domain/usecases/register_device.dart';
import 'package:taskflow_app/features/auth/domain/usecases/register_user_use_case.dart';
import 'package:taskflow_app/features/auth/domain/usecases/reset_password_use_case.dart';
import 'package:taskflow_app/features/auth/domain/usecases/unbind_device.dart';
import 'package:taskflow_app/features/auth/presentation/cubit/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_translate/flutter_translate.dart';

// Authentication flow:
// 1. When user enters in the app: --> AuthInitial
//    - Check if user is logged in --> AuthLoading
//    - If not, Go to login screen --> Unauthenticated
//    - If yes, Go to main page --> Authenticated
// 2. When user logs in with email/password:
//    - Validate credentials --> AuthLoading
//    - If valid, Go to main page --> Authenticated
//    - If invalid, show error --> AuthFailure

class AuthCubit extends Cubit<AuthState> with ErrorReportingMixin {
  final CheckDeviceRegisteredUseCase checkDeviceRegistered;
  final RegisterDeviceUseCase registerDeviceUseCase;
  final UnbindDeviceUseCase unbindDeviceUseCase;
  final LoginUseCase loginUseCase;
  final RegisterUserUseCase registerUserUseCase;
  final ForgotPasswordUseCase forgotPasswordUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthCubit(
    this.checkDeviceRegistered,
    this.registerDeviceUseCase,
    this.unbindDeviceUseCase,
    this.loginUseCase,
    this.registerUserUseCase,
    this.forgotPasswordUseCase,
    this.resetPasswordUseCase,
  ) : super(AuthInitial());

  // 1. When user enters in the app: --> AuthInitial
  //    - Check if device is registered --> AuthLoading
  //    - If not, Go to verification code screen --> Unauthenticated
  //    - If yes, Go to main page and get data from that user (so far, we will get data from TallerBCN) --> Authenticated
  Future<void> checkAuthStatus() async {
    emit(AuthLoading());
    try {
      String deviceId = await DeviceUtils.getDeviceId();
      final user = await checkDeviceRegistered.getUserIfDeviceRegistered(
        deviceId,
      );

      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report - critical auth operation
        context: 'checkAuthStatus',
      );
      emit(AuthFailure(ErrorHandler.handle(exception)));
    }
  }

  // 2. When user logs in (adds a proper Verification Code):
  //    - Check if device is registered --> AuthLoading
  //    - If not, register device --> Authenticated
  //    - If yes, show there is already a device registered with that code --> AuthError??, Unauthenticated
  Future<void> registerDevice(String verificationCode) async {
    emit(AuthLoading());
    try {
      String deviceId = await DeviceUtils.getDeviceId();
      final isRegistered = await checkDeviceRegistered.isDeviceRegistered(
        deviceId,
      );
      if (!isRegistered) {
        //check if passCode is valid. If valid, register device
        final user = await registerDeviceUseCase.registerDevice(
          deviceId,
          verificationCode,
        );
        emit(Authenticated(user));
      } else {
        emit(
          AuthFailure(
            AppError(
              message:
                  "Device already registered. Please contact your administrator.",
              type: ErrorType.validation,
            ),
          ),
        );
      }
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true, // Report - critical auth operation
        context: 'registerDevice',
      );
      emit(AuthFailure(ErrorHandler.handle(exception)));
    }
  }

  Future<void> unbindDevice() async {
    // check if user is authenticated
    if (state is Authenticated) {
      // if yes, unbind device
      final user = (state as Authenticated).user;
      await unbindDeviceUseCase.unbindDevice(user.id);
      emit(Unauthenticated());
      return;
    } else {
      // if no, show error, not possible to unbind device
      emit(
        AuthFailure(
          AppError(
            message: translate('notPossibleToUnbindDevice'),
            type: ErrorType.authentication,
          ),
        ),
      );
    }
  }

  // Login with email and password
  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await loginUseCase.execute(email, password);
      emit(Authenticated(user));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true,
        context: 'login',
      );
      emit(AuthFailure(ErrorHandler.handle(exception)));
    }
  }

  // Register new user with email and password
  Future<void> register(String email, String password, String name) async {
    emit(AuthLoading());
    try {
      final user = await registerUserUseCase.execute(email, password, name);
      emit(RegistrationSuccess(user));
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true,
        context: 'register',
      );
      emit(AuthFailure(ErrorHandler.handle(exception)));
    }
  }

  // Request password reset
  Future<void> forgotPassword(String email) async {
    emit(AuthLoading());
    try {
      await forgotPasswordUseCase.execute(email);
      emit(PasswordResetEmailSent());
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true,
        context: 'forgotPassword',
      );
      emit(AuthFailure(ErrorHandler.handle(exception)));
    }
  }

  // Reset password with token
  Future<void> resetPassword(
    String email,
    String newPassword,
    String token,
  ) async {
    emit(AuthLoading());
    try {
      await resetPasswordUseCase.execute(email, newPassword, token);
      emit(PasswordResetSuccess());
    } catch (exception, stackTrace) {
      handleError(
        exception,
        stackTrace,
        shouldReport: true,
        context: 'resetPassword',
      );
      emit(AuthFailure(ErrorHandler.handle(exception)));
    }
  }

  // Logout user
  void logout() {
    emit(Unauthenticated());
  }
}
