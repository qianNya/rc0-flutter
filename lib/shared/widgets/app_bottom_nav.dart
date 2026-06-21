import 'package:flutter/material.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';
import 'package:rc0_flutter/shared/widgets/app_bottom_inset.dart';

class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.home_outlined, Icons.home, '首页'),
    (Icons.photo_library_outlined, Icons.photo_library, '图库'),
    (Icons.add, Icons.add, ''),
    (Icons.chat_bubble_outline, Icons.chat_bubble, '消息'),
    (Icons.person_outline, Icons.person, '我的'),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final borderColor = Theme.of(context).dividerTheme.color ?? AppColors.darkBorder;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHighest,
        border: Border(top: BorderSide(color: borderColor)),
      ),
      child: AppBottomInset(
        color: scheme.surfaceContainerHighest,
        child: SizedBox(
          height: 64,
          child: Row(
            children: List.generate(_items.length, (index) {
              final item = _items[index];
              final selected = currentIndex == index;
              final isCreate = index == 2;

              if (isCreate) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(index),
                    child: Center(
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add, color: Colors.white),
                      ),
                    ),
                  ),
                );
              }

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        selected ? item.$2 : item.$1,
                        color: selected ? AppColors.primary : AppColors.darkTextHint,
                        size: 22,
                      ),
                      if (item.$3.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.$3,
                          style: TextStyle(
                            fontSize: 10,
                            color: selected ? AppColors.primary : AppColors.darkTextHint,
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
