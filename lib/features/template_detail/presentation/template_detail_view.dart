import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/template_detail/domain/entities/template_detail.dart';
import 'package:rc0_flutter/features/template_detail/presentation/providers/template_detail_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_bottom_inset.dart';
import 'package:rc0_flutter/shared/widgets/app_immersive_header.dart';
import 'package:rc0_flutter/shared/widgets/app_primary_button.dart';
import 'package:rc0_flutter/shared/widgets/app_underline_tab_bar.dart';

class TemplateDetailView extends ConsumerWidget {
  const TemplateDetailView({super.key, required this.templateId});

  final String templateId;

  static const _tabs = ['结构预览', '参数预设', '相关模板'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(templateDetailProvider(templateId));

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
                  child: AppImmersiveScope(
                    child: _CoverSection(detail: detail),
                  ),
                ),
                SliverToBoxAdapter(child: _InfoSection(detail: detail)),
                SliverToBoxAdapter(
                  child: AppUnderlineTabBar(
                    tabs: _tabs,
                    selectedIndex: state.selectedTab,
                    onSelected: (index) {
                      if (index == 1) {
                        context.push(AppRoutes.cinePresetPath(templateId));
                        return;
                      }
                      ref
                          .read(templateDetailProvider(templateId).notifier)
                          .selectTab(index);
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: _TabContent(
                    templateId: templateId,
                    selectedIndex: state.selectedTab,
                    detail: detail,
                  ),
                ),
              ],
            ),
          ),
          _BottomBar(),
        ],
      ),
    );
  }
}

class _CoverSection extends StatelessWidget {
  const _CoverSection({required this.detail});

  final TemplateDetail detail;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;

    return Stack(
      children: [
        SizedBox(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 16 / 10,
            child: CachedNetworkImage(
              imageUrl: detail.coverUrl,
              fit: BoxFit.cover,
            ),
          ),
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
        const Positioned.fill(
          child: Center(
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.black45,
              child: Icon(Icons.play_arrow, color: Colors.white, size: 32),
            ),
          ),
        ),
      ],
    );
  }
}

class _InfoSection extends StatelessWidget {
  const _InfoSection({required this.detail});

  final TemplateDetail detail;

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
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(detail.authorAvatarUrl),
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
              OutlinedButton(onPressed: () {}, child: const Text('关注')),
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
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(value, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({
    required this.templateId,
    required this.selectedIndex,
    required this.detail,
  });

  final String templateId;
  final int selectedIndex;
  final TemplateDetail detail;

  @override
  Widget build(BuildContext context) {
    return switch (selectedIndex) {
      0 => _StructureTab(templateId: templateId, acts: detail.acts),
      _ => Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Center(
            child: Text(
              '即将上线',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ),
    };
  }
}

class _StructureTab extends StatelessWidget {
  const _StructureTab({required this.templateId, required this.acts});

  final String templateId;
  final List<ActItem> acts;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: acts.asMap().entries.map((entry) {
          final actIndex = entry.key;
          final act = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: ExpansionTile(
              leading: CircleAvatar(
                radius: 14,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  '${actIndex + 1}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
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
              children: act.scenes.asMap().entries.map((sceneEntry) {
                final scene = sceneEntry.value;
                return ListTile(
                  onTap: () => context.push(
                    AppRoutes.frameViewerPath(templateId, sceneEntry.key),
                  ),
                  leading: scene.thumbnailUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                          child: CachedNetworkImage(
                            imageUrl: scene.thumbnailUrl!,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                          ),
                        )
                      : const Icon(Icons.movie_outlined),
                  title: Text(scene.title),
                  subtitle: Text('${scene.frameCount} 帧'),
                  trailing: const Icon(Icons.chevron_right, size: 20),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBottomInset(
      color: AppColors.surface,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: const AppPrimaryButton(label: 'Fork 此模板'),
    );
  }
}
