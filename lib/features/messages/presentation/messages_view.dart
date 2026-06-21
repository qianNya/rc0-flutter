import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/messages/domain/entities/notification_item.dart';
import 'package:rc0_flutter/features/messages/presentation/providers/messages_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_status_bar_fill.dart';

class MessagesView extends ConsumerStatefulWidget {
  const MessagesView({super.key});

  @override
  ConsumerState<MessagesView> createState() => _MessagesViewState();
}

class _MessagesViewState extends ConsumerState<MessagesView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  static const _tabs = ['评论', '点赞', '收藏'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(messagesProvider.notifier).selectTab(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(messagesProvider);

    return Scaffold(
      body: AppStatusBarFill(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Row(
                children: [
                  Text(
                    '消息',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () =>
                        ref.read(messagesProvider.notifier).markAllRead(),
                    child: const Text('全部已读'),
                  ),
                ],
              ),
            ),
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.darkTextSecondary,
              indicatorColor: AppColors.primary,
              tabs: _tabs.map((t) => Tab(text: t)).toList(),
            ),
            Expanded(
              child: state.isLoading && state.notifications.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : state.notifications.isEmpty
                  ? Center(
                      child: Text(
                        '暂无通知',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.darkTextSecondary,
                        ),
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => ref.read(messagesProvider.notifier).load(),
                      child: ListView.separated(
                        padding: const EdgeInsets.only(bottom: 100),
                        itemCount: state.notifications.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          return _NotificationTile(item: state.notifications[index]);
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({required this.item});

  final NotificationItem item;

  @override
  Widget build(BuildContext context) {
    final icon = switch (item.type) {
      NotificationType.comment => Icons.chat_bubble_outline,
      NotificationType.like => Icons.favorite_border,
      NotificationType.favorite => Icons.bookmark_border,
    };

    return ListTile(
      leading: Stack(
        children: [
          CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(item.actorAvatarUrl),
          ),
          if (!item.isRead)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      title: Row(
        children: [
          Text(
            item.actorName,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(icon, size: 14, color: AppColors.darkTextSecondary),
        ],
      ),
      subtitle: Text(item.summary),
      trailing: Text(
        item.timeAgo,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.darkTextHint,
        ),
      ),
    );
  }
}
