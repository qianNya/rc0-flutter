class FeedItem {
  const FeedItem({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.authorName,
    required this.authorAvatarUrl,
    required this.likes,
    required this.comments,
    this.tags = const [],
  });

  final String id;
  final String title;
  final String coverUrl;
  final String authorName;
  final String authorAvatarUrl;
  final int likes;
  final int comments;
  final List<String> tags;
}
