import 'package:taskflow_app/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository repository;

  ForgotPasswordUseCase(this.repository);

  Future<void> execute(String email) async {
    return await repository.requestPasswordReset(email);
  }
}

