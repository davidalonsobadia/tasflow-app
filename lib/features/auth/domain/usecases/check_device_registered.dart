import 'package:taskflow_app/features/auth/domain/entities/user_entity.dart';
import 'package:taskflow_app/features/auth/domain/repositories/auth_repository.dart';

class CheckDeviceRegisteredUseCase {
  final AuthRepository repository;

  CheckDeviceRegisteredUseCase(this.repository);

  Future<bool> isDeviceRegistered(String deviceId) {
    return repository.isDeviceRegistered(deviceId);
  }

  Future<UserEntity?> getUserIfDeviceRegistered(String deviceId) {
    return repository.getUserIfDeviceRegistered(deviceId);
  }
}
