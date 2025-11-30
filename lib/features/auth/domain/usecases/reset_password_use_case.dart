import 'package:taskflow_app/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<void> execute(String email, String newPassword, String token) async {
    return await repository.resetPassword(email, newPassword, token);
  }
}

