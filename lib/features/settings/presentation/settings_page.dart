import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:rc0_flutter/app/router/routes.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/core/theme/theme_mode_provider.dart';
import 'package:rc0_flutter/features/auth/presentation/providers/auth_provider.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final themeModeAsync = ref.watch(themeModeProvider);
    final themeMode = themeModeAsync.value ?? ThemeMode.dark;
    final isAuthenticated = authState.status == AuthStatus.authenticated;

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        children: [
          const _SectionHeader('账户'),
          if (isAuthenticated)
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: Text(authState.displayName ?? '已登录用户'),
              subtitle: authState.email != null ? Text(authState.email!) : null,
            )
          else
            ListTile(
              leading: const Icon(Icons.login),
              title: const Text('登录 / 注册'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.push(AppRoutes.login),
            ),
          ListTile(
            title: const Text('账户与安全'),
            trailing: const Icon(Icons.chevron_right),
            onTap: isAuthenticated ? () {} : () => context.push(AppRoutes.login),
          ),
          ListTile(
            title: const Text('隐私设置'),
            trailing: const Icon(Icons.chevron_right),
          ),
          const _SectionHeader('外观'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: SegmentedButton<ThemeMode>(
              segments: const [
                ButtonSegment(
                  value: ThemeMode.system,
                  label: Text('跟随系统'),
                  icon: Icon(Icons.brightness_auto),
                ),
                ButtonSegment(
                  value: ThemeMode.light,
                  label: Text('浅色'),
                  icon: Icon(Icons.light_mode),
                ),
                ButtonSegment(
                  value: ThemeMode.dark,
                  label: Text('深色'),
                  icon: Icon(Icons.dark_mode),
                ),
              ],
              selected: {themeMode},
              onSelectionChanged: (selection) {
                ref
                    .read(themeModeProvider.notifier)
                    .setThemeMode(selection.first);
              },
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          const _SectionHeader('通知'),
          const ListTile(
            title: Text('推送通知'),
            trailing: Switch(value: true, onChanged: null),
          ),
          const _SectionHeader('存储'),
          const ListTile(
            title: Text('清除缓存'),
            subtitle: Text('128 MB'),
            trailing: Icon(Icons.chevron_right),
          ),
          SizedBox(height: AppSpacing.xl),
          if (isAuthenticated)
            Center(
              child: TextButton(
                onPressed: () async {
                  await ref.read(authProvider.notifier).logout();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('已退出登录')),
                    );
                  }
                },
                child: Text(
                  '退出登录',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            ),
          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.sm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}
