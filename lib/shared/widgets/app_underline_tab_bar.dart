import 'package:flutter/material.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/core/theme/app_spacing.dart';

class AppUnderlineTabBar extends StatelessWidget {
  const AppUnderlineTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = selectedIndex == index;
          return Expanded(
            child: GestureDetector(
              onTap: () => onSelected(index),
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selected ? AppColors.primary : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: selected ? AppColors.primary : AppColors.textSecondary,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
