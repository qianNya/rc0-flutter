class AuthUser {
  const AuthUser({
    required this.id,
    required this.username,
    required this.nickname,
    required this.email,
    this.avatar,
  });

  final String id;
  final String username;
  final String nickname;
  final String email;
  final String? avatar;
}
