class RegisterCredentials {
  const RegisterCredentials({
    required this.username,
    required this.password,
    required this.email,
    this.nickname,
  });

  final String username;
  final String password;
  final String email;
  final String? nickname;
}
