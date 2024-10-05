import 'package:flutter/material.dart';
import 'package:quizflow/models/word.dart';
import 'package:quizflow/pages_layout.dart';
import 'package:quizflow/widgets/flashcards_page.dart';
import 'package:quizflow/widgets/write_page.dart';

class SubsetCard extends StatelessWidget {
  final List<Word> words;

  const SubsetCard({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              children: [
                Text(words.first.word ?? "",
                    style: const TextStyle(fontSize: 20)),
                const Text(
                  "to",
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                Text(words.last.word ?? "",
                    style: const TextStyle(fontSize: 20))
              ],
            ),
            const Spacer(),
            Column(
              children: [
                IconButton(
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
                    icon: const Icon(Icons.edit_note)),
                IconButton(
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
                    icon: const Icon(Icons.dynamic_feed))
              ],
            )
          ],
        ),
      ),
    );
  }
}
