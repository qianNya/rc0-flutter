import 'package:flutter/material.dart';
import 'package:rc0_flutter/core/theme/app_theme.dart';

/// 浅色创作流程页面外壳。
class AppLightScaffold extends StatelessWidget {
  const AppLightScaffold({
    super.key,
    required this.body,
    this.appBar,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.light,
      child: Scaffold(
        appBar: appBar,
        backgroundColor: AppTheme.light.scaffoldBackgroundColor,
        body: body,
      ),
    );
  }
}
