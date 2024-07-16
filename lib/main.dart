import 'package:flutter/material.dart';
import 'package:quizflow/pages_layout.dart';
import 'package:quizflow/widgets/home_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: PagesLayout(
      child: HomePage(),
    ));
  }
}
