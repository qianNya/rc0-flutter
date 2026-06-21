import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/explore/presentation/providers/explore_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_category_pills.dart';
import 'package:rc0_flutter/shared/widgets/feed_card.dart';

class DiscoverTab extends ConsumerWidget {
  const DiscoverTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreProvider);
    final categories = ref.watch(exploreCategoriesProvider);
    final selectedIndex = categories.indexOf(state.selectedCategory).clamp(
      0,
      categories.length - 1,
    );

    if (state.isLoading && state.feedItems.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(exploreProvider.notifier).load(),
      child: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          AppCategoryPills(
            categories: categories,
            selectedIndex: selectedIndex,
            onSelected: (index) => ref
                .read(exploreProvider.notifier)
                .selectCategory(categories[index]),
          ),
          const SizedBox(height: AppSpacing.md),
          ...state.feedItems.map(
            (item) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: FeedCard(
                item: item,
                onTap: () => context.push(AppRoutes.screenplayDetailPath(item.id)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
