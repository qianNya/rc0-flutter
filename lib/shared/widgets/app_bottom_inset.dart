import 'package:flutter/material.dart';

/// 将背景色延伸至系统手势条区域，避免底部出现色差条。
class AppBottomInset extends StatelessWidget {
  const AppBottomInset({
    super.key,
    required this.color,
    required this.child,
    this.padding = EdgeInsets.zero,
  });

  final Color color;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return ColoredBox(
      color: color,
      child: Padding(
        padding: padding.copyWith(bottom: padding.bottom + bottomInset),
        child: child,
      ),
    );
  }
}
