import 'package:taskflow_app/features/auth/domain/entities/user_entity.dart';
import 'package:taskflow_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUserUseCase {
  final AuthRepository repository;

  RegisterUserUseCase(this.repository);

  Future<UserEntity> execute(String email, String password, String name) async {
    return await repository.registerUser(email, password, name);
  }
}

