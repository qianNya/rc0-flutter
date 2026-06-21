class EngagementStateDto {
  const EngagementStateDto({
    this.isLiked = false,
    this.isFavorited = false,
    this.isFollowingAuthor = false,
  });

  final bool isLiked;
  final bool isFavorited;
  final bool isFollowingAuthor;

  factory EngagementStateDto.fromJson(Map<String, dynamic> json) {
    return EngagementStateDto(
      isLiked: json['is_liked'] as bool? ?? false,
      isFavorited: json['is_favorited'] as bool? ?? false,
      isFollowingAuthor: json['is_following_author'] as bool? ?? false,
    );
  }
}
