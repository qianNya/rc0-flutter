enum NotificationType { comment, like, favorite }

class NotificationItem {
  const NotificationItem({
    required this.id,
    required this.type,
    required this.actorName,
    required this.actorAvatarUrl,
    required this.summary,
    required this.timeAgo,
    this.isRead = false,
  });

  final String id;
  final NotificationType type;
  final String actorName;
  final String actorAvatarUrl;
  final String summary;
  final String timeAgo;
  final bool isRead;
}
