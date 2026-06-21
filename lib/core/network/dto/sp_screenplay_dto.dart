class SpScreenplayDto {
  const SpScreenplayDto({
    required this.id,
    required this.title,
    this.subtitle,
    this.summary,
    this.coverUrl,
    this.kind,
    this.publishStatus,
    this.likeCount = 0,
    this.commentCount = 0,
    this.viewCount = 0,
    this.forkCount = 0,
    this.actCount = 0,
    this.sceneCount = 0,
    this.frameCount = 0,
    this.hotScore,
    this.updateAt,
  });

  final int id;
  final String title;
  final String? subtitle;
  final String? summary;
  final String? coverUrl;
  final int? kind;
  final int? publishStatus;
  final int likeCount;
  final int commentCount;
  final int viewCount;
  final int forkCount;
  final int actCount;
  final int sceneCount;
  final int frameCount;
  final double? hotScore;
  final DateTime? updateAt;

  factory SpScreenplayDto.fromJson(Map<String, dynamic> json) {
    return SpScreenplayDto(
      id: json['id'] as int,
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String?,
      summary: json['summary'] as String?,
      coverUrl: json['cover_url'] as String?,
      kind: json['kind'] as int?,
      publishStatus: json['publish_status'] as int?,
      likeCount: json['like_count'] as int? ?? json['likes'] as int? ?? 0,
      commentCount: json['comment_count'] as int? ?? json['comments'] as int? ?? 0,
      viewCount: json['view_count'] as int? ?? json['views'] as int? ?? 0,
      forkCount: json['fork_count'] as int? ?? 0,
      actCount: json['act_count'] as int? ?? 0,
      sceneCount: json['scene_count'] as int? ?? 0,
      frameCount: json['frame_count'] as int? ?? 0,
      hotScore: (json['hot_score'] as num?)?.toDouble(),
      updateAt: json['update_at'] != null
          ? DateTime.tryParse(json['update_at'] as String)
          : null,
    );
  }
}
