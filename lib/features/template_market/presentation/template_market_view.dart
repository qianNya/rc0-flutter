import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/template_market/presentation/providers/template_market_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_search_bar.dart';
import 'package:rc0_flutter/shared/widgets/app_section_title.dart';
import 'package:rc0_flutter/shared/widgets/app_status_bar_fill.dart';
import 'package:rc0_flutter/shared/widgets/template_card.dart';

class TemplateMarketView extends ConsumerStatefulWidget {
  const TemplateMarketView({super.key});

  @override
  ConsumerState<TemplateMarketView> createState() => _TemplateMarketViewState();
}

class _TemplateMarketViewState extends ConsumerState<TemplateMarketView> {
  final _bannerController = PageController();
  int _bannerIndex = 0;

  @override
  void dispose() {
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(templateMarketProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: AppStatusBarFill(
        color: AppColors.surface,
        child: state.isLoading && state.templates.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () => ref.read(templateMarketProvider.notifier).load(),
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
                              icon: const Icon(Icons.tune),
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (state.banners.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 160,
                                child: PageView.builder(
                                  controller: _bannerController,
                                  onPageChanged: (index) =>
                                      setState(() => _bannerIndex = index),
                                  itemCount: state.banners.length,
                                  itemBuilder: (context, index) {
                                    final banner = state.banners[index];
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        AppRadius.lg,
                                      ),
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
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
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
                                  state.banners.length,
                                  (index) => Container(
                                    width: index == _bannerIndex ? 16 : 6,
                                    height: 6,
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: index == _bannerIndex
                                          ? AppColors.primary
                                          : AppColors.border,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    SliverToBoxAdapter(child: AppSectionTitle(title: '热门模板')),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      sliver: SliverGrid.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: AppSpacing.md,
                          crossAxisSpacing: AppSpacing.md,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: state.templates.length,
                        itemBuilder: (context, index) {
                          final item = state.templates[index];
                          return TemplateCard(
                            item: item,
                            onTap: () => context.push(
                              AppRoutes.templateDetailPath(item.id),
                            ),
                          );
                        },
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
