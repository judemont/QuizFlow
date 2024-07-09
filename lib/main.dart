import 'package:flutter/material.dart';
import 'package:voclearner/pages_layout.dart';
import 'package:voclearner/widgets/vocs_list_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        home: PagesLayout(
      child: VocsListPage(),
    ));
  }
}
