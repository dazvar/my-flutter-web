import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'view_models/github_view_model.dart';
import 'view_models/theme_view_model.dart';
import 'repository/person_repository.dart';
import 'screens/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final personRepository = PersonRepository();
  await personRepository.loadFromStorage();
  final themeViewModel = ThemeViewModel();
  await themeViewModel.loadTheme();
  if (!kIsWeb) {
    await MobileAds.instance.initialize();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GitHubViewModel()),
        ChangeNotifierProvider<ThemeViewModel>.value(value: themeViewModel),
        Provider<PersonRepository>.value(value: personRepository),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeVM = Provider.of<ThemeViewModel>(context);
    return MaterialApp(
      title: 'Resume + GitHub Stats',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: themeVM.mode,
      home: const HomePage(),
    );
  }
}