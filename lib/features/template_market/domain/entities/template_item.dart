enum TemplateBadge { hot, newItem }

class TemplateItem {
  const TemplateItem({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.authorName,
    this.badge,
    this.likes = 0,
    this.comments = 0,
  });

  final String id;
  final String title;
  final String coverUrl;
  final String authorName;
  final TemplateBadge? badge;
  final int likes;
  final int comments;
}
