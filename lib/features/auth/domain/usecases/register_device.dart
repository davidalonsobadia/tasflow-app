import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/features/auth/domain/entities/user_entity.dart';
import 'package:taskflow_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_translate/flutter_translate.dart';

class RegisterDeviceUseCase {
  final AuthRepository repository;

  RegisterDeviceUseCase(this.repository);

  Future<UserEntity> registerDevice(
    String deviceId,
    String verificationCode,
  ) async {
    // Check if the verification code is already associated with a device
    final user = await repository.getUserIfValidPassCode(verificationCode);
    if (user == null) {
      throw ValidationException(
        translate('invalidVerificationCode'),
        Exception(translate('invalidVerificationCode')),
      );
    }
    if (user.deviceId != '') {
      throw ValidationException(
        translate('deviceAlreadyRegistered'),
        Exception(translate('deviceAlreadyRegistered')),
      );
    }

    return await repository.registerDevice(user.id, deviceId);
  }
}
