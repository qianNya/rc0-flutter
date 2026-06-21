import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/app/router/app_router.dart';
import 'package:rc0_flutter/core/providers/app_bootstrap_provider.dart';
import 'package:rc0_flutter/core/system/app_system_ui.dart';
import 'package:rc0_flutter/core/theme/app_theme.dart';
import 'package:rc0_flutter/core/theme/theme_mode_provider.dart';
import 'package:rc0_flutter/shared/widgets/app_system_ui_scope.dart';

class RcoApp extends ConsumerWidget {
  const RcoApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bootstrap = ref.watch(appBootstrapProvider);
    final router = ref.watch(routerProvider);
    final themeModeAsync = ref.watch(themeModeProvider);
    final themeMode = themeModeAsync.value ?? ThemeMode.dark;
    final platformBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    final resolvedBrightness = resolveThemeBrightness(
      themeMode: themeMode,
      platformBrightness: platformBrightness,
    );
    final overlayStyle = resolvedBrightness == Brightness.dark
        ? AppSystemUi.darkOverlayStyle
        : AppSystemUi.lightOverlayStyle;

    if (bootstrap.isLoading) {
      return AppSystemUiScope(
        style: overlayStyle,
        child: MaterialApp(
          title: 'rco',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: themeMode,
          home: const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    return AppSystemUiScope(
      style: overlayStyle,
      child: MaterialApp.router(
        title: 'rco',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: themeMode,
        routerConfig: router,
      ),
    );
  }
}
