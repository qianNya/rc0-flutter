import 'package:rc0_flutter/features/auth/domain/entities/auth_tokens.dart';
import 'package:rc0_flutter/features/auth/domain/entities/auth_user.dart';

class AuthUserDto {
  const AuthUserDto({
    required this.id,
    required this.username,
    required this.nickname,
    required this.email,
    this.avatar,
  });

  factory AuthUserDto.fromJson(Map<String, dynamic> json) {
    return AuthUserDto(
      id: '${json['id']}',
      username: json['username'] as String? ?? '',
      nickname: json['nickname'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String?,
    );
  }

  /// Parses `/users/me` envelope where user fields may be nested under `user`.
  factory AuthUserDto.fromMeJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>? ?? json;
    return AuthUserDto.fromJson(userJson);
  }

  final String id;
  final String username;
  final String nickname;
  final String email;
  final String? avatar;

  AuthUser toEntity() {
    return AuthUser(
      id: id,
      username: username,
      nickname: nickname,
      email: email,
      avatar: avatar,
    );
  }
}

class AuthTokensDto {
  const AuthTokensDto({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
  });

  factory AuthTokensDto.fromJson(Map<String, dynamic> json) {
    return AuthTokensDto(
      accessToken: json['access_token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? '',
      expiresIn: json['expires_in'] as int? ?? 0,
    );
  }

  final String accessToken;
  final String refreshToken;
  final int expiresIn;

  AuthTokens toEntity() {
    return AuthTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiresIn: expiresIn,
    );
  }
}

class AuthResponseDto {
  const AuthResponseDto({
    required this.user,
    required this.tokens,
  });

  factory AuthResponseDto.fromJson(Map<String, dynamic> json) {
    return AuthResponseDto(
      user: AuthUserDto.fromJson(json['user'] as Map<String, dynamic>),
      tokens: AuthTokensDto.fromJson(json['tokens'] as Map<String, dynamic>),
    );
  }

  final AuthUserDto user;
  final AuthTokensDto tokens;
}
