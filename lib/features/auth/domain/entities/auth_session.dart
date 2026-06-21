import 'package:rc0_flutter/features/auth/domain/entities/auth_tokens.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_user.dart';

class AuthSession {
  const AuthSession({
    required this.user,
    required this.tokens,
  });

  final AuthUser user;
  final AuthTokens tokens;
}
