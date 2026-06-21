class SceneItem {
  const SceneItem({
    required this.id,
    required this.title,
    this.frameCount = 0,
    this.thumbnailUrl,
  });

  final String id;
  final String title;
  final int frameCount;
  final String? thumbnailUrl;
}

class ActItem {
  const ActItem({
    required this.id,
    required this.title,
    required this.scenes,
  });

  final String id;
  final String title;
  final List<SceneItem> scenes;
}

class TemplateDetail {
  const TemplateDetail({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.authorLevel,
    required this.likes,
    required this.comments,
    required this.views,
    required this.tags,
    required this.acts,
  });

  final String id;
  final String title;
  final String coverUrl;
  final String authorName;
  final String authorAvatarUrl;
  final int authorLevel;
  final int likes;
  final int comments;
  final int views;
  final List<String> tags;
  final List<ActItem> acts;
}
