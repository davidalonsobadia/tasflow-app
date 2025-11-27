import 'package:taskflow_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<bool> isDeviceRegistered(String deviceId);
  Future<UserEntity?> getUserIfDeviceRegistered(String deviceId);
  Future<UserEntity?> getUserIfValidPassCode(String passCode);
  Future<UserEntity> registerDevice(String userId, String verificationCode);
  Future<void> unbindDevice(String userId);
}
