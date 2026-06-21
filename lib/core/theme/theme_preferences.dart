import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemePreferences {
  ThemePreferences({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;

  static const _key = 'theme_mode';

  Future<SharedPreferences> get _instance async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  Future<ThemeMode> loadThemeMode() async {
    final prefs = await _instance;
    final value = prefs.getString(_key);
    return switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      'system' => ThemeMode.system,
      _ => ThemeMode.dark,
    };
  }

  Future<void> saveThemeMode(ThemeMode mode) async {
    final prefs = await _instance;
    final value = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      ThemeMode.system => 'system',
    };
    await prefs.setString(_key, value);
  }
}
