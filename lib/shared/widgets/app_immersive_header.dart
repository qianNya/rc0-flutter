import 'package:flutter/material.dart';
import 'package:rc0_flutter/core/system/app_system_ui.dart';
import 'package:rc0_flutter/shared/widgets/app_system_ui_scope.dart';

/// 沉浸式顶栏：内容延伸至状态栏，自动切换浅色状态栏图标。
class AppImmersiveHeader extends StatelessWidget {
  const AppImmersiveHeader({
    super.key,
    required this.header,
    required this.body,
    this.backgroundColor,
  });

  final Widget header;
  final Widget body;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return AppSystemUiScope(
      style: AppSystemUi.immersiveOverlayStyle,
      child: ColoredBox(
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            header,
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

/// 仅包裹需要沉浸式状态栏图标的区域（如全屏预览）。
class AppImmersiveScope extends StatelessWidget {
  const AppImmersiveScope({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AppSystemUiScope(
      style: AppSystemUi.immersiveOverlayStyle,
      child: child,
    );
  }
}
