import 'package:taskflow_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<bool> isDeviceRegistered(String deviceId);
  Future<UserEntity?> getUserIfDeviceRegistered(String deviceId);
  Future<UserEntity?> getUserIfValidPassCode(String passCode);
  Future<UserEntity> registerDevice(String userId, String verificationCode);
  Future<void> unbindDevice(String userId);

  // Email/Password authentication methods
  Future<UserEntity?> loginWithEmailPassword(String email, String password);
  Future<UserEntity> registerUser(String email, String password, String name);
  Future<void> requestPasswordReset(String email);
  Future<void> resetPassword(String email, String newPassword, String token);
}
