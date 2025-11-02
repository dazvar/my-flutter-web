import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:namer_app/main.dart';
import 'package:namer_app/repository/person_repository.dart';
import 'package:namer_app/view_models/github_view_model.dart';
import 'package:namer_app/view_models/theme_view_model.dart';

void main() {
  testWidgets('App builds HomePage and shows AppBar with actions', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});

    final personRepo = PersonRepository();
    await personRepo.loadFromStorage();
    // Remove default persons to avoid loading asset images during tests
    await personRepo.deletePerson('1');
    await personRepo.deletePerson('2');
    final themeVM = ThemeViewModel();
    await themeVM.loadTheme();

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => GitHubViewModel()),
          ChangeNotifierProvider<ThemeViewModel>.value(value: themeVM),
          Provider<PersonRepository>.value(value: personRepo),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.text('Лабораторна 5'), findsOneWidget);
    // Check AppBar add action by tooltip to avoid other '+' icons in body
    expect(find.byTooltip('Додати нове резюме'), findsOneWidget);
    // Theme toggle exists (either dark or light icon)
    expect(find.byIcon(Icons.dark_mode).evaluate().isNotEmpty ||
        find.byIcon(Icons.light_mode).evaluate().isNotEmpty, true);
  });
}
