import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/home/presentation/providers/home_provider.dart';
import 'package:rc0_flutter/features/home/presentation/tabs/community_tab.dart';
import 'package:rc0_flutter/features/home/presentation/tabs/discover_tab.dart';
import 'package:rc0_flutter/features/home/presentation/tabs/follow_tab.dart';
import 'package:rc0_flutter/features/home/presentation/tabs/recommend_tab.dart';
import 'package:rc0_flutter/features/template_market/domain/repositories/template_market_repository.dart';
import 'package:rc0_flutter/features/template_market/presentation/providers/template_market_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_search_bar.dart';
import 'package:rc0_flutter/shared/widgets/app_status_bar_fill.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _bannerController = PageController();
  int _bannerIndex = 0;

  static const _tabs = ['发现', '关注', '推荐', '社区'];

  static const _quickEntries = [
    (Icons.image_outlined, '图片', AppRoutes.gallery),
    (Icons.description_outlined, '剧本', AppRoutes.scripts),
    (Icons.view_carousel_outlined, '分镜', AppRoutes.storyboards),
    (Icons.tune, '预设', AppRoutes.presets),
    (Icons.people_outline, '用户', AppRoutes.users),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        ref.read(homeTabIndexProvider.notifier).state = _tabController.index;
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final marketState = ref.watch(templateMarketProvider);
    final tabIndex = ref.watch(homeTabIndexProvider);

    if (_tabController.index != tabIndex) {
      _tabController.index = tabIndex;
    }

    return Scaffold(
      body: AppStatusBarFill(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
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
                      onPressed: () => context.push(AppRoutes.messages),
                      icon: const Icon(Icons.notifications_outlined),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: _buildTopTabBar()),
            if (marketState.banners.isNotEmpty)
              SliverToBoxAdapter(child: _buildHeroCarousel(marketState.banners)),
            SliverToBoxAdapter(child: _buildQuickEntries(context)),
          ],
          body: TabBarView(
            controller: _tabController,
            children: const [
              DiscoverTab(),
              FollowTab(),
              RecommendTab(),
              CommunityTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopTabBar() {
    return TabBar(
      controller: _tabController,
      isScrollable: true,
      tabAlignment: TabAlignment.start,
      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.darkTextSecondary,
      indicatorColor: AppColors.primary,
      indicatorSize: TabBarIndicatorSize.label,
      dividerColor: Colors.transparent,
      labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      unselectedLabelStyle: const TextStyle(fontSize: 16),
      tabs: _tabs.map((t) => Tab(text: t)).toList(),
    );
  }

  Widget _buildHeroCarousel(List<MarketBanner> banners) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _bannerController,
              onPageChanged: (index) => setState(() => _bannerIndex = index),
              itemCount: banners.length,
              itemBuilder: (context, index) {
                final banner = banners[index];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CachedNetworkImage(
                        imageUrl: banner.imageUrl,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.65),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        left: AppSpacing.lg,
                        bottom: AppSpacing.lg,
                        right: AppSpacing.lg,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              banner.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              banner.subtitle,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              banners.length,
              (index) => Container(
                width: index == _bannerIndex ? 16 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: index == _bannerIndex
                      ? AppColors.primary
                      : AppColors.darkBorder,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickEntries(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: _quickEntries.map((entry) {
          return GestureDetector(
            onTap: () {
              if (entry.$3 == AppRoutes.gallery) {
                context.go(AppRoutes.gallery);
              } else {
                context.push(entry.$3);
              }
            },
            child: Column(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                    border: Border.all(color: AppColors.darkBorder),
                  ),
                  child: Icon(entry.$1, color: AppColors.primary, size: 22),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  entry.$2,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
