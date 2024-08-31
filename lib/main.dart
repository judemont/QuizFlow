import 'package:flutter/material.dart';
import 'package:quizflow/pages_layout.dart';
import 'package:quizflow/widgets/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  _MainAppState createState() => _MainAppState();

  static _MainAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MainAppState>();
}

class _MainAppState extends State<MainApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    updateTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      home: const PagesLayout(
        child: HomePage(),
      ),
    );
  }

  Future<void> updateTheme() async {
    final prefs = await SharedPreferences.getInstance();
    String dataThemeMode = prefs.getString('theme') ?? "system";
    print(dataThemeMode);
    setState(() {
      switch (dataThemeMode) {
        case "dark":
          _themeMode = ThemeMode.dark;
        case "light":
          _themeMode = ThemeMode.light;
        case "system":
          _themeMode = ThemeMode.system;
      }
    });
    print(_themeMode);
  }
}
