import 'package:flutter/material.dart';

/// 透明状态栏下，将背景色铺满系统状态栏区域。
class AppStatusBarFill extends StatelessWidget {
  const AppStatusBarFill({
    super.key,
    required this.child,
    this.color,
  });

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.paddingOf(context).top;
    final fillColor = color ?? Theme.of(context).scaffoldBackgroundColor;

    return ColoredBox(
      color: fillColor,
      child: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: child,
      ),
    );
  }
}
