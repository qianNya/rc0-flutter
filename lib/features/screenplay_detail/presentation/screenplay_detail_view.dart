import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/screenplay_detail/presentation/providers/screenplay_detail_provider.dart';
import 'package:rc0_flutter/features/screenplay_draft/domain/entities/display_tree.dart';
import 'package:rc0_flutter/shared/widgets/app_bottom_inset.dart';
import 'package:rc0_flutter/shared/widgets/app_immersive_header.dart';
import 'package:rc0_flutter/shared/widgets/app_primary_button.dart';
import 'package:rc0_flutter/shared/widgets/app_underline_tab_bar.dart';
import 'package:rc0_flutter/shared/widgets/draft_image.dart';

class ScreenplayDetailView extends ConsumerWidget {
  const ScreenplayDetailView({super.key, required this.screenplayId});

  final String screenplayId;

  static const _tabs = ['结构', '参数', '评论'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(screenplayDetailProvider(screenplayId));

    if (state.isLoading && state.detail == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final detail = state.detail;
    if (detail == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(state.error ?? '加载失败')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: AppImmersiveScope(child: _CoverSection(detail: detail)),
                ),
                SliverToBoxAdapter(child: _InfoSection(detail: detail)),
                SliverToBoxAdapter(
                  child: AppUnderlineTabBar(
                    tabs: _tabs,
                    selectedIndex: state.selectedTab,
                    onSelected: (index) => ref
                        .read(screenplayDetailProvider(screenplayId).notifier)
                        .selectTab(index),
                  ),
                ),
                SliverToBoxAdapter(
                  child: _TabContent(
                    screenplayId: screenplayId,
                    selectedIndex: state.selectedTab,
                    detail: detail,
                  ),
                ),
              ],
            ),
          ),
          _BottomBar(
            screenplayId: screenplayId,
            isForking: state.isForking,
          ),
        ],
      ),
    );
  }
}

class _CoverSection extends StatelessWidget {
  const _CoverSection({required this.detail});

  final DisplayTree detail;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 16 / 10,
          child: DraftImage(imageUrl: detail.coverUrl, fit: BoxFit.cover),
        ),
        Positioned(
          top: topInset + AppSpacing.sm,
          left: AppSpacing.sm,
          child: CircleAvatar(
            backgroundColor: Colors.black45,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
          ),
        ),
        Positioned(
          top: topInset + AppSpacing.sm,
          right: AppSpacing.sm,
          child: const CircleAvatar(
            backgroundColor: Colors.black45,
            child: Icon(Icons.more_horiz, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.detail});

  final DisplayTree detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            detail.title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          if (detail.subtitle.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              detail.subtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: detail.authorAvatarUrl.isNotEmpty
                    ? CachedNetworkImageProvider(detail.authorAvatarUrl)
                    : null,
                child: detail.authorAvatarUrl.isEmpty
                    ? const Icon(Icons.person)
                    : null,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detail.authorName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      'LV.${detail.authorLevel}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _Stat(Icons.favorite_border, '${detail.likes}'),
              const SizedBox(width: AppSpacing.lg),
              _Stat(Icons.chat_bubble_outline, '${detail.comments}'),
              const SizedBox(width: AppSpacing.lg),
              _Stat(Icons.visibility_outlined, '${detail.views}'),
            ],
          ),
          if (detail.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: detail.tags
                  .map(
                    (tag) => Chip(
                      label: Text(tag),
                      backgroundColor: AppColors.searchBarFill,
                      side: BorderSide.none,
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(this.icon, this.value);

  final IconData icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: AppSpacing.xs),
        Text(value, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.screenplayId,
    required this.selectedIndex,
    required this.detail,
  });

  final String screenplayId;
  final int selectedIndex;
  final DisplayTree detail;

  @override
  Widget build(BuildContext context) {
    return switch (selectedIndex) {
      0 => _StructureTab(screenplayId: screenplayId, detail: detail),
      1 => _ParamsTab(detail: detail),
      _ => _CommentsTab(),
    };
  }
}

class _StructureTab extends StatelessWidget {
  const _StructureTab({
    required this.screenplayId,
    required this.detail,
  });

  final String screenplayId;
  final DisplayTree detail;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: detail.acts.asMap().entries.map((entry) {
          final actIndex = entry.key;
          final act = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: ExpansionTile(
              initiallyExpanded: actIndex == 0,
              leading: Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: Text(
                  '${actIndex + 1}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              title: Text(
                act.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              subtitle: Text('${act.scenes.length} 场次'),
              children: act.scenes
                  .map((scene) => _SceneTile(
                        screenplayId: screenplayId,
                        scene: scene,
                      ))
                  .toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SceneTile extends StatelessWidget {
  const _SceneTile({
    required this.screenplayId,
    required this.scene,
  });

  final String screenplayId;
  final DisplayScene scene;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: scene.frames.isNotEmpty
              ? () => context.push(
                    AppRoutes.screenplayFrameViewerPath(
                      screenplayId,
                      scene.localId,
                      0,
                    ),
                  )
              : null,
          title: Text(scene.title),
          subtitle: Text('${scene.frameCount} 帧 · ${scene.totalDurationSec}s'),
          trailing: const Icon(Icons.chevron_right, size: 20),
        ),
        if (scene.frames.isNotEmpty)
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(
                left: AppSpacing.lg,
                right: AppSpacing.lg,
                bottom: AppSpacing.md,
              ),
              itemCount: scene.frames.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, index) {
                final frame = scene.frames[index];
                return GestureDetector(
                  onTap: () => context.push(
                    AppRoutes.screenplayFrameViewerPath(
                      screenplayId,
                      scene.localId,
                      index,
                    ),
                  ),
                  child: DraftImage(
                    imageUrl: frame.thumbnailUrl ?? frame.imageUrl,
                    width: 48,
                    height: 48,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _ParamsTab extends StatelessWidget {
  const _ParamsTab({required this.detail});

  final DisplayTree detail;

  @override
  Widget build(BuildContext context) {
    final params = <MapEntry<String, String>>[];
    for (final act in detail.acts) {
      for (final scene in act.scenes) {
        for (final frame in scene.frames) {
          params.add(MapEntry(
            '${scene.title} · ${frame.title}',
            '${frame.aspectRatio} · ${frame.shotType}'
                '${frame.cinePresetId != null ? ' · preset #${frame.cinePresetId}' : ''}',
          ));
        }
      }
    }

    if (params.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Center(
          child: Text(
            '暂无参数',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: params.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final item = params[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(item.key, style: Theme.of(context).textTheme.bodyMedium),
          subtitle: Text(item.value),
        );
      },
    );
  }
}

class _CommentsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Center(
        child: Text(
          '评论功能即将上线',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _BottomBar extends ConsumerWidget {
  const _BottomBar({
    required this.screenplayId,
    required this.isForking,
  });

  final String screenplayId;
  final bool isForking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppBottomInset(
      color: AppColors.surface,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          IconButton(
            onPressed: () =>
                ref.read(screenplayDetailProvider(screenplayId).notifier).favorite(),
            icon: const Icon(Icons.favorite_border),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: AppPrimaryButton(
              label: isForking ? 'Fork 中...' : 'Fork 剧本',
              onPressed: isForking
                  ? null
                  : () async {
                      final forkedId = await ref
                          .read(screenplayDetailProvider(screenplayId).notifier)
                          .fork();
                      if (forkedId != null && context.mounted) {
                        context.push(AppRoutes.screenplayDetailPath('$forkedId'));
                      }
                    },
            ),
          ),
        ],
      ),
    );
  }
}
