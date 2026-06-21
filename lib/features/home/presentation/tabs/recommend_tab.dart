import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/explore/presentation/providers/explore_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_section_title.dart';
import 'package:rc0_flutter/shared/widgets/feed_card.dart';

class RecommendTab extends ConsumerWidget {
  const RecommendTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreProvider);

    if (state.isLoading && state.feedItems.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(exploreProvider.notifier).load(),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          ...state.feedItems.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: FeedCard(
                item: item,
                onTap: () => context.push(AppRoutes.screenplayDetailPath(item.id)),
              ),
            ),
          ),
          AppSectionTitle(title: '猜你喜欢'),
          SizedBox(
            height: 140,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              itemCount: state.recommendations.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.md),
              itemBuilder: (context, index) {
                final item = state.recommendations[index];
                return GestureDetector(
                  onTap: () => context.push(AppRoutes.templateDetailPath(item.id)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: CachedNetworkImage(
                        imageUrl: item.coverUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
