import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rc0_flutter/core/theme/theme_preferences.dart';

final themePreferencesProvider = Provider<ThemePreferences>(
  (ref) => ThemePreferences(),
);

class ThemeModeNotifier extends AsyncNotifier<ThemeMode> {
  @override
  Future<ThemeMode> build() async {
    return ref.read(themePreferencesProvider).loadThemeMode();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = AsyncData(mode);
    await ref.read(themePreferencesProvider).saveThemeMode(mode);
  }
}

final themeModeProvider =
    AsyncNotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

Brightness resolveThemeBrightness({
  required ThemeMode themeMode,
  required Brightness platformBrightness,
}) {
  return switch (themeMode) {
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
    ThemeMode.system => platformBrightness,
  };
}
