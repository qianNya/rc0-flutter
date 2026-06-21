import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rc0_flutter/core/theme/app_colors.dart';

abstract final class AppSystemUi {
  static const SystemUiOverlayStyle darkOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
    systemStatusBarContrastEnforced: false,
    systemNavigationBarColor: AppColors.darkSurfaceElevated,
    systemNavigationBarIconBrightness: Brightness.light,
    systemNavigationBarContrastEnforced: false,
  );

  static const SystemUiOverlayStyle lightOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
    systemStatusBarContrastEnforced: false,
    systemNavigationBarColor: AppColors.surface,
    systemNavigationBarIconBrightness: Brightness.dark,
    systemNavigationBarContrastEnforced: false,
  );

  static const SystemUiOverlayStyle overlayStyle = darkOverlayStyle;

  /// Light status-bar icons for content under dark/gradient headers.
  static const SystemUiOverlayStyle immersiveOverlayStyle = darkOverlayStyle;

  static Future<void> configure() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(darkOverlayStyle);
  }
}
