import 'package:rc0_flutter/core/error/app_exception.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/messages/data/datasources/messages_datasource.dart';
import 'package:rc0_flutter/features/messages/domain/entities/notification_item.dart';
import 'package:rc0_flutter/features/messages/domain/repositories/messages_repository.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  MessagesRepositoryImpl(this._datasource);

  final MessagesDatasource _datasource;

  @override
  Future<Result<List<NotificationItem>>> getNotifications({
    NotificationType? type,
  }) async {
    try {
      return Success(await _datasource.getNotifications(type: type));
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }

  @override
  Future<Result<void>> markAllRead() async {
    try {
      await _datasource.markAllRead();
      return const Success(null);
    } catch (e) {
      return Failure(UnknownException(e.toString()));
    }
  }
}
