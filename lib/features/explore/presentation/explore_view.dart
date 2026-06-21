import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/explore/presentation/providers/explore_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_category_pills.dart';
import 'package:rc0_flutter/shared/widgets/app_search_bar.dart';
import 'package:rc0_flutter/shared/widgets/app_section_title.dart';
import 'package:rc0_flutter/shared/widgets/app_status_bar_fill.dart';
import 'package:rc0_flutter/shared/widgets/feed_card.dart';

class ExploreView extends ConsumerWidget {
  const ExploreView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(exploreProvider);
    final categories = ref.watch(exploreCategoriesProvider);
    final selectedIndex = categories.indexOf(state.selectedCategory).clamp(
      0,
      categories.length - 1,
    );

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: AppStatusBarFill(
        color: AppColors.surface,
        child: state.isLoading && state.feedItems.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => ref.read(exploreProvider.notifier).load(),
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.lg,
                          AppSpacing.md,
                          AppSpacing.lg,
                          AppSpacing.sm,
                        ),
                        child: Row(
                          children: [
                            const Expanded(child: AppSearchBar()),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.notifications_outlined),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: AppCategoryPills(
                        categories: categories,
                        selectedIndex: selectedIndex,
                        onSelected: (index) => ref
                            .read(exploreProvider.notifier)
                            .selectCategory(categories[index]),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      sliver: SliverList.builder(
                        itemCount: state.feedItems.length,
                        itemBuilder: (context, index) {
                          final item = state.feedItems[index];
                          return FeedCard(
                            item: item,
                            onTap: () => context.push(
                              AppRoutes.screenplayDetailPath(item.id),
                            ),
                          );
                        },
                      ),
                    ),
                    SliverToBoxAdapter(child: AppSectionTitle(title: '猜你喜欢')),
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 140,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          itemCount: state.recommendations.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(width: AppSpacing.md),
                          itemBuilder: (context, index) {
                            final item = state.recommendations[index];
                            return GestureDetector(
                              onTap: () => context.push(
                                AppRoutes.templateDetailPath(item.id),
                              ),
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
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 100)),
                  ],
                ),
              ),
      ),
    );
  }
}
