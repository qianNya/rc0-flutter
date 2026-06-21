import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/explore/presentation/providers/explore_provider.dart';
import 'package:rc0_flutter/shared/widgets/feed_card.dart';

class FollowTab extends ConsumerWidget {
  const FollowTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreProvider);
    final items = state.feedItems.take(4).toList();

    if (state.isLoading && items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (items.isEmpty) {
      return const Center(child: Text('关注作者的内容将显示在这里'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(exploreProvider.notifier).load(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.md,
          AppSpacing.lg,
          100,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return FeedCard(
            item: item,
            onTap: () => context.push(AppRoutes.screenplayDetailPath(item.id)),
          );
        },
      ),
    );
  }
}
