import 'package:flutter/material.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_radius.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';

class AppSearchBar extends StatelessWidget {
  const AppSearchBar({
    super.key,
    this.hintText = '搜索剧本、模板…',
    this.onTap,
  });

  final String hintText;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? AppColors.darkSearchBarFill : AppColors.searchBarFill;
    final hintColor = isDark ? AppColors.darkTextHint : AppColors.textHint;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        decoration: BoxDecoration(
          color: fillColor,
          borderRadius: BorderRadius.circular(AppRadius.full),
        ),
        child: Row(
          children: [
            Icon(Icons.search, size: 20, color: hintColor),
            const SizedBox(width: AppSpacing.sm),
            Text(
              hintText,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: hintColor),
            ),
          ],
        ),
      ),
    );
  }
}
