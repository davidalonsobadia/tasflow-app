import 'package:taskflow_app/features/auth/domain/repositories/auth_repository.dart';

class UnbindDeviceUseCase {
  final AuthRepository repository;

  UnbindDeviceUseCase(this.repository);

  Future<void> unbindDevice(String userId) async {
    return await repository.unbindDevice(userId);
  }
}
