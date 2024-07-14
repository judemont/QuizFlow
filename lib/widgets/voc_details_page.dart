import 'package:flutter/material.dart';
import 'package:voclearner/models/voc.dart';
import 'package:voclearner/models/word.dart';
import 'package:voclearner/pages_layout.dart';
import 'package:voclearner/services/database.dart';
import 'package:voclearner/widgets/word_card.dart';
import 'package:voclearner/widgets/write_page.dart';

class VocDetailsPage extends StatefulWidget {
  final Voc voc;
  const VocDetailsPage({super.key, required this.voc});

  @override
  State<VocDetailsPage> createState() => _VocDetailsPageState();
}

class _VocDetailsPageState extends State<VocDetailsPage> {
  List<Word> words = [];

  Future<void> loadWords() async {
    DatabaseService.getWordsFromVoc(widget.voc.id!).then((value) {
      setState(() {
        words = value;
      });
    });
  }

  @override
  void initState() {
    loadWords();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VocLearner"),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {},
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
                  onPressed: () {},
                  label: const Text("Flashcards"),
                  icon: const Icon(Icons.dynamic_feed),
                ),
              ),
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
