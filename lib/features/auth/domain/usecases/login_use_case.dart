import 'package:taskflow_app/core/network/exceptions.dart';
import 'package:taskflow_app/features/auth/domain/entities/user_entity.dart';
import 'package:taskflow_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_translate/flutter_translate.dart';

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> execute(String email, String password) async {
    final user = await repository.loginWithEmailPassword(email, password);
    if (user == null) {
      throw ValidationException(
        translate('invalidEmailOrPassword'),
        Exception(translate('invalidEmailOrPassword')),
      );
    }
    return user;
  }
}

