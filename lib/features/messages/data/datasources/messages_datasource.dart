import 'package:rc0_flutter/features/messages/domain/entities/notification_item.dart';

abstract class MessagesDatasource {
  Future<List<NotificationItem>> getNotifications({NotificationType? type});
  Future<void> markAllRead();
}

/// Backend notification API is not available yet — always returns empty list.
class EmptyMessagesDatasource implements MessagesDatasource {
  @override
  Future<List<NotificationItem>> getNotifications({
    NotificationType? type,
  }) async {
    return [];
  }

  @override
  Future<void> markAllRead() async {}
}
