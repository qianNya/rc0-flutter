import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_session.dart';
import 'package:rc0_flutter/features/auth/domain/entities/login_credentials.dart';
import 'package:rc0_flutter/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  const LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call(LoginCredentials credentials) {
    return _repository.login(credentials);
  }
}
