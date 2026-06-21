import 'package:flutter/material.dart';

abstract final class AppColors {
  static const Color primary = Color(0xFF7065F0);
  static const Color primaryLight = Color(0xFF8B7FF0);

  // Light theme
  static const Color background = Color(0xFFF7F8FA);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color searchBarFill = Color(0xFFF0F1F5);
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color border = Color(0xFFE5E7EB);
  static const Color pillUnselected = Color(0xFFF0F1F5);

  // Dark theme
  static const Color darkBackground = Color(0xFF0D0D12);
  static const Color darkSurface = Color(0xFF1A1A24);
  static const Color darkSurfaceElevated = Color(0xFF23232F);
  static const Color darkTextPrimary = Color(0xFFF5F5F7);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkTextHint = Color(0xFF6B7280);
  static const Color darkBorder = Color(0xFF2E2E3A);
  static const Color darkSearchBarFill = Color(0xFF23232F);
  static const Color darkPillUnselected = Color(0xFF2A2A36);

  static const Color badgeHot = Color(0xFFFF6B6B);
  static const Color badgeNew = Color(0xFF4ECDC4);
  static const Color profileGradientStart = Color(0xFF7065F0);
  static const Color profileGradientEnd = Color(0xFFE879F9);
}
