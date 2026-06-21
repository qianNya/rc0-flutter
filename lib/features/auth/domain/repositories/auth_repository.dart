import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_session.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_tokens.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_user.dart';
import 'package:rc0_flutter/features/auth/domain/entities/login_credentials.dart';
import 'package:rc0_flutter/features/auth/domain/entities/register_credentials.dart';

abstract class AuthRepository {
  Future<Result<AuthSession>> login(LoginCredentials credentials);

  Future<Result<AuthSession>> register(RegisterCredentials credentials);

  Future<Result<AuthUser>> getCurrentUser();

  Future<Result<AuthTokens>> refreshSession();
}
