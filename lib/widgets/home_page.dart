import 'package:flutter/material.dart';
import 'package:quizflow/models/voc.dart';
import 'package:quizflow/pages_layout.dart';
import 'package:quizflow/utilities/database.dart';
import 'package:quizflow/widgets/voc_card.dart';
import 'package:quizflow/widgets/voc_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Voc> vocs = [];

  void loadVocs() {
    DatabaseService.getVocs().then((value) {
      setState(() {
        vocs = value;
      });
    });
  }

  @override
  void initState() {
    loadVocs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QuizFlow"),
      ),
      body: GridView.count(
        padding: const EdgeInsets.only(top: 50),
        childAspectRatio: (2),
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        children: vocs
            .map((voc) => VocCard(
                  title: voc.title ?? "",
                  description: voc.description,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PagesLayout(
                          displayNavBar: false,
                          child: VocDetailsPage(
                            voc: voc,
                          ),
                        ),
                      ),
                    );
                  },
                ))
            .toList(),
      ),
    );
  }
}
