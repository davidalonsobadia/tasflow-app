import 'package:taskflow_app/features/auth/data/data_sources/auth_remote_data_source.dart';
import 'package:taskflow_app/features/auth/domain/entities/user_entity.dart';
import 'package:taskflow_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<bool> isDeviceRegistered(String deviceId) async {
    return await remoteDataSource.isDeviceRegistered(deviceId);
  }

  @override
  Future<UserEntity?> getUserIfDeviceRegistered(String deviceId) async {
    return await remoteDataSource.getUserIfDeviceRegistered(deviceId);
  }

  @override
  Future<UserEntity> registerDevice(String userId, String deviceId) {
    return remoteDataSource.registerDevice(userId, deviceId);
  }

  @override
  Future<UserEntity?> getUserIfValidPassCode(String passCode) {
    return remoteDataSource.getUserIfValidPassCode(passCode);
  }

  @override
  Future<void> unbindDevice(String userId) {
    return remoteDataSource.unbindDevice(userId);
  }
}
