import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_session.dart';
import 'package:rc0_flutter/features/auth/domain/entities/register_credentials.dart';
import 'package:rc0_flutter/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  const RegisterUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<AuthSession>> call(RegisterCredentials credentials) {
    return _repository.register(credentials);
  }
}
