import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:rc0_flutter/features/profile/domain/entities/user_profile.dart';
import 'package:rc0_flutter/features/profile/presentation/providers/profile_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_primary_button.dart';
import 'package:rc0_flutter/shared/widgets/app_status_bar_fill.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProfileView extends ConsumerWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.status == AuthStatus.loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authState.status == AuthStatus.guest) {
      return Scaffold(
        body: AppStatusBarFill(
          child: ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              const _GuestLoginCard(),
              const SizedBox(height: AppSpacing.lg),
              _MenuSection(
                items: [
                  _MenuItem(Icons.settings_outlined, '设置', AppRoutes.settings),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final state = ref.watch(profileProvider);

    if (state.isLoading && state.profile == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final profile = state.profile;
    if (profile == null) {
      return Scaffold(body: Center(child: Text(state.error ?? '加载失败')));
    }

    return Scaffold(
      body: AppStatusBarFill(
        child: RefreshIndicator(
          onRefresh: () => ref.read(profileProvider.notifier).load(),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              _ProfileHeader(profile: profile),
              const SizedBox(height: AppSpacing.lg),
              _ProBanner(),
              const SizedBox(height: AppSpacing.lg),
              _MenuSection(
                items: [
                  _MenuItem(Icons.description_outlined, '我的剧本', AppRoutes.scripts),
                  _MenuItem(Icons.tune, '我的预设', AppRoutes.presets),
                  _MenuItem(Icons.bookmark_border, '我的收藏', null),
                  _MenuItem(Icons.history, '浏览历史', null),
                  _MenuItem(Icons.download_outlined, '下载管理', null),
                  _MenuItem(Icons.settings_outlined, '设置', AppRoutes.settings),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GuestLoginCard extends StatelessWidget {
  const _GuestLoginCard();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          children: [
            Icon(
              Icons.person_outline,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              '登录解锁完整功能',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '登录后可同步剧本、预设与收藏',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.darkTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            AppPrimaryButton(
              label: '登录 / 注册',
              onPressed: () => context.push(AppRoutes.login),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.profile});

  final UserProfile profile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundImage: CachedNetworkImageProvider(profile.avatarUrl),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile.name,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'ID: ${profile.id}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.darkTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: const Text('编辑'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem('作品', profile.worksCount),
                _StatItem('获赞', profile.likesCount),
                _StatItem('关注', profile.followingCount),
                _StatItem('收藏', profile.followersCount),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem(this.label, this.value);

  final String label;
  final int value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$value',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }
}

class _ProBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
          ),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Row(
          children: [
            const Icon(Icons.workspace_premium, color: Colors.white, size: 32),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'RCO Pro',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '解锁高级创作工具与无限导出',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem(this.icon, this.label, this.route);

  final IconData icon;
  final String label;
  final String? route;
}

class _MenuSection extends StatelessWidget {
  const _MenuSection({required this.items});

  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          children: items.map((item) {
            return ListTile(
              leading: Icon(item.icon, color: AppColors.darkTextSecondary),
              title: Text(item.label),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: item.route != null ? () => context.push(item.route!) : null,
            );
          }).toList(),
        ),
      ),
    );
  }
}
