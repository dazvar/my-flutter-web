import 'package:flutter_test/flutter_test.dart';
import 'package:namer_app/view_models/theme_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

void main() {
  group('ThemeViewModel', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('default is light and persists toggle to dark', () async {
      final vm = ThemeViewModel();
      await vm.loadTheme();
      expect(vm.mode, ThemeMode.light);

      await vm.toggleTheme();
      expect(vm.mode, ThemeMode.dark);

      // New instance should read dark from storage
      final vm2 = ThemeViewModel();
      await vm2.loadTheme();
      expect(vm2.mode, ThemeMode.dark);
    });

    test('setTheme(light/dark) stores correctly', () async {
      final vm = ThemeViewModel();
      await vm.setTheme(ThemeMode.dark);
      expect(vm.mode, ThemeMode.dark);

      final vm2 = ThemeViewModel();
      await vm2.loadTheme();
      expect(vm2.mode, ThemeMode.dark);

      await vm2.setTheme(ThemeMode.light);
      final vm3 = ThemeViewModel();
      await vm3.loadTheme();
      expect(vm3.mode, ThemeMode.light);
    });
  });
}
