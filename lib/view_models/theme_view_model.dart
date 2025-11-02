import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeViewModel extends ChangeNotifier {
  static const String _key = 'theme_mode_v1';

  ThemeMode _mode = ThemeMode.light;
  ThemeMode get mode => _mode;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final value = prefs.getString(_key);
    switch (value) {
      case 'dark':
        _mode = ThemeMode.dark;
        break;
      case 'light':
      default:
        _mode = ThemeMode.light;
    }
    notifyListeners();
  }

  Future<void> setTheme(ThemeMode mode) async {
    _mode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<void> toggleTheme() async {
    await setTheme(_mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark);
  }
}
