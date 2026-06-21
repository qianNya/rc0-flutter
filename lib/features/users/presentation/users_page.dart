import 'package:flutter/material.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';
import 'package:rc0_flutter/shared/widgets/app_search_bar.dart';
import 'package:rc0_flutter/shared/widgets/app_status_bar_fill.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  static final _users = List.generate(10, (index) {
    return (
      'user_$index',
      switch (index % 4) {
        0 => '光影捕手',
        1 => '镜头旅人',
        2 => '帧间故事',
        _ => '视觉诗人',
      },
      '',
    );
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('用户')),
      body: AppStatusBarFill(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(AppSpacing.lg),
              child: AppSearchBar(hintText: '搜索用户…'),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: _users.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final user = _users[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppColors.darkSurface,
                      child: Text(
                        user.$2.isNotEmpty ? user.$2[0] : '?',
                        style: const TextStyle(color: AppColors.darkTextSecondary),
                      ),
                    ),
                    title: Text(user.$2),
                    subtitle: Text('ID: ${user.$1}'),
                    trailing: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      child: const Text('关注'),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
