import 'package:flutter/material.dart';
import 'package:quizflow/widgets/voc_editor_page.dart';
import 'package:quizflow/widgets/settings_page.dart';
import 'package:quizflow/widgets/home_page.dart';

class PagesLayout extends StatefulWidget {
  final Widget child;
  final bool displayNavBar;
  final int? currentSection;

  const PagesLayout({
    super.key,
    required this.child,
    this.displayNavBar = true,
    this.currentSection,
  });

  @override
  State<PagesLayout> createState() => _PagesLayoutState();
}

class _PagesLayoutState extends State<PagesLayout> {
  late int currentPageIndex;
  late Widget currentChild;
  List<Widget> pages = [
    const HomePage(),
    const VocEditorPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    currentPageIndex = widget.currentSection ?? 0;
    currentChild = widget.child;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: currentChild,
        bottomNavigationBar: widget.displayNavBar
            ? NavigationBar(
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                selectedIndex: currentPageIndex,
                onDestinationSelected: (index) => setState(() {
                  currentPageIndex = index;
                  currentChild = pages[currentPageIndex];
                }),
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: "Home"),
                  NavigationDestination(
                      icon: Icon(Icons.add_circle), label: "New List"),
                  NavigationDestination(
                      icon: Icon(Icons.settings), label: "Settings")
                ],
              )
            : null);
  }
}
