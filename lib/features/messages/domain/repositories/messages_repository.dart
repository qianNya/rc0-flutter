import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/messages/domain/entities/notification_item.dart';

abstract class MessagesRepository {
  Future<Result<List<NotificationItem>>> getNotifications({NotificationType? type});
  Future<Result<void>> markAllRead();
}
