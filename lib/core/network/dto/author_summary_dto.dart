class AuthorSummaryDto {
  const AuthorSummaryDto({
    required this.id,
    required this.nickname,
    required this.avatar,
  });

  final int id;
  final String nickname;
  final String avatar;

  factory AuthorSummaryDto.fromJson(Map<String, dynamic> json) {
    return AuthorSummaryDto(
      id: json['id'] as int,
      nickname: json['nickname'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
    );
  }
}
