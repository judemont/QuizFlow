import 'package:flutter/material.dart';
import 'package:quizflow/models/subset.dart';
import 'package:quizflow/models/voc.dart';
import 'package:quizflow/models/word.dart';
import 'package:quizflow/pages_layout.dart';
import 'package:quizflow/utilities/database.dart';
import 'package:quizflow/utilities/utils.dart';
import 'package:quizflow/widgets/flashcards_page.dart';
import 'package:quizflow/widgets/home_page.dart';
import 'package:quizflow/widgets/subset_card.dart';
import 'package:quizflow/widgets/voc_editor_page.dart';
import 'package:quizflow/widgets/word_card.dart';
import 'package:quizflow/widgets/write_page.dart';

class VocDetailsPage extends StatefulWidget {
  final Voc voc;
  const VocDetailsPage({super.key, required this.voc});

  @override
  State<VocDetailsPage> createState() => _VocDetailsPageState();
}

class _VocDetailsPageState extends State<VocDetailsPage> {
  List<Word> words = [];
  List<Subset> subsets = [];

  Future<void> loadWords() async {
    DatabaseService.getWordsFromVoc(widget.voc.id!).then((value) {
      setState(() {
        words = value;
      });
    });
  }

  Future<void> loadSubsets() async {
    DatabaseService.getSubsetsFromVoc(widget.voc.id!).then((value) {
      setState(() {
        subsets = value;
      });
    });
  }

  @override
  void initState() {
    loadWords();
    loadSubsets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QuizFlow"),
        actions: [
          IconButton(
            icon: const Icon(Icons.upload),
            onPressed: () {
              Utils.userExportVoc(widget.voc);
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext ctx) {
                    return AlertDialog(
                      title: const Text('Please Confirm'),
                      content: const Text('Are you sure ?'),
                      actions: [
                        // The "Yes" button
                        TextButton(
                            onPressed: () {
                              // Remove the box
                              DatabaseService.removeVoc(widget.voc.id!)
                                  .then((value) {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (context) => const PagesLayout(
                                      currentSection: 0,
                                      child: HomePage(),
                                    ),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              });
                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            child: const Text('Yes')),
                        TextButton(
                            onPressed: () {
                              // Close the dialog
                              Navigator.of(context).pop();
                            },
                            child: const Text('No'))
                      ],
                    );
                  });
            },
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VocEditorPage(
                          initialVoc: widget.voc,
                          initialSubsets: subsets,
                          initialWords: words,
                        )),
              );
            },
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                  child: Text(
                widget.voc.title ?? "",
                style: const TextStyle(fontSize: 25),
              )),
              const SizedBox(
                height: 20,
              ),
              Text(widget.voc.description ?? ""),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => PagesLayout(
                              displayNavBar: false,
                              child: WritePage(
                                words: words,
                              ))),
                    );
                  },
                  label: const Text("Write"),
                  icon: const Icon(Icons.edit_note),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => PagesLayout(
                              displayNavBar: false,
                              child: FlashcardsPage(
                                words: words,
                              ))),
                    );
                  },
                  label: const Text("Flashcards"),
                  icon: const Icon(Icons.dynamic_feed),
                ),
              ),
              Visibility(
                  visible: subsets.isNotEmpty,
                  child: const Column(
                    children: [
                      SizedBox(height: 30),
                      Text(
                        "Subsets:",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  )),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: subsets.length,
                  itemBuilder: (context, index) {
                    return SubsetCard(
                        words: words.sublist(subsets[index].from ?? 0,
                            (subsets[index].to ?? words.length - 1) + 1));
                  }),
              const SizedBox(height: 30),
              const Text(
                "Words:",
                style: TextStyle(fontSize: 20),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    return WordCard(word: words[index]);
                  })
            ],
          ),
        ),
      ),
    );
  }
}
