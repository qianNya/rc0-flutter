import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/result/result.dart';
import 'package:rc0_flutter/features/messages/data/datasources/messages_datasource.dart';
import 'package:rc0_flutter/features/messages/data/repositories/messages_repository_impl.dart';
import 'package:rc0_flutter/features/messages/domain/entities/notification_item.dart';
import 'package:rc0_flutter/features/messages/domain/repositories/messages_repository.dart';

final messagesDatasourceProvider = Provider<MessagesDatasource>(
  (ref) => EmptyMessagesDatasource(),
);

final messagesRepositoryProvider = Provider<MessagesRepository>((ref) {
  return MessagesRepositoryImpl(ref.watch(messagesDatasourceProvider));
});

class MessagesState {
  const MessagesState({
    this.notifications = const [],
    this.selectedTab = 0,
    this.isLoading = false,
    this.error,
  });

  final List<NotificationItem> notifications;
  final int selectedTab;
  final bool isLoading;
  final String? error;

  MessagesState copyWith({
    List<NotificationItem>? notifications,
    int? selectedTab,
    bool? isLoading,
    String? error,
  }) {
    return MessagesState(
      notifications: notifications ?? this.notifications,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class MessagesNotifier extends StateNotifier<MessagesState> {
  MessagesNotifier(this._repository) : super(const MessagesState()) {
    load();
  }

  final MessagesRepository _repository;

  static const _types = [
    NotificationType.comment,
    NotificationType.like,
    NotificationType.favorite,
  ];

  Future<void> load() async {
    state = state.copyWith(isLoading: true, error: null);
    final type = state.selectedTab < _types.length ? _types[state.selectedTab] : null;
    final result = await _repository.getNotifications(type: type);

    if (result is Failure<List<NotificationItem>>) {
      state = state.copyWith(
        isLoading: false,
        error: result.exception.toString(),
      );
      return;
    }

    state = state.copyWith(
      notifications: (result as Success<List<NotificationItem>>).data,
      isLoading: false,
    );
  }

  void selectTab(int index) {
    state = state.copyWith(selectedTab: index);
    load();
  }

  Future<void> markAllRead() async {
    await _repository.markAllRead();
    load();
  }
}

final messagesProvider = StateNotifierProvider<MessagesNotifier, MessagesState>((ref) {
  return MessagesNotifier(ref.watch(messagesRepositoryProvider));
});
