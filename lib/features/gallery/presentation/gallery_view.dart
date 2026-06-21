import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/gallery/domain/entities/gallery_image.dart';
import 'package:rc0_flutter/features/gallery/presentation/providers/gallery_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_category_pills.dart';
import 'package:rc0_flutter/shared/widgets/app_search_bar.dart';
import 'package:rc0_flutter/shared/widgets/app_status_bar_fill.dart';

class GalleryView extends ConsumerStatefulWidget {
  const GalleryView({super.key});

  @override
  ConsumerState<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends ConsumerState<GalleryView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  static const _tabs = ['图片', '作品', '标签'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(galleryProvider.notifier).selectTab(_tabController.index);
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
    final state = ref.watch(galleryProvider);
    final filters = ref.watch(galleryFiltersProvider);
    final filterIndex = filters.indexOf(state.selectedFilter).clamp(
      0,
      filters.length - 1,
    );

    return Scaffold(
      body: AppStatusBarFill(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    '图库',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  const Expanded(child: AppSearchBar(hintText: '搜索图片、作品…')),
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
            if (state.selectedTab == 0)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                child: AppCategoryPills(
                  categories: filters,
                  selectedIndex: filterIndex,
                  onSelected: (index) => ref
                      .read(galleryProvider.notifier)
                      .selectFilter(filters[index]),
                ),
              ),
            Expanded(
              child: state.isLoading && state.images.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: () => ref.read(galleryProvider.notifier).load(),
                      child: _buildContent(state),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(GalleryState state) {
    return switch (state.selectedTab) {
      0 => _MasonryGrid(items: state.images),
      1 => _MasonryGrid(items: state.works),
      _ => _TagsGrid(tags: state.tags),
    };
  }
}

class _MasonryGrid extends StatelessWidget {
  const _MasonryGrid({required this.items});

  final List<GalleryImage> items;

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        100,
      ),
      cacheExtent: 500,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: item.imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, _) => const ColoredBox(
                  color: AppColors.darkBorder,
                  child: SizedBox(height: 160),
                ),
              ),
              if (item.resolution != null)
                Positioned(
                  right: AppSpacing.xs,
                  bottom: AppSpacing.xs,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.xs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Text(
                      item.resolution!,
                      style: const TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TagsGrid extends StatelessWidget {
  const _TagsGrid({required this.tags});

  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.lg,
        100,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 2.2,
      ),
      itemCount: tags.length,
      itemBuilder: (context, index) {
        return Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.darkSurface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.darkBorder),
          ),
          child: Text(
            '#${tags[index]}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
    );
  }
}
