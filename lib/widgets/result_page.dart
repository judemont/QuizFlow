import 'package:flutter/material.dart';
import 'package:quizflow/models/word.dart';
import 'package:quizflow/pages_layout.dart';
import 'package:quizflow/widgets/word_card.dart';

import 'write_page.dart';

class ResultPage extends StatefulWidget {
  final List<Word> correctWords;
  final List<Word> incorrectWords;
  final MaterialPageRoute<dynamic> tryAgainPage;
  const ResultPage({
    super.key,
    required this.correctWords,
    required this.incorrectWords,
    required this.tryAgainPage,
  });

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  @override
  Widget build(BuildContext context) {
    // print(widget.correctWords);
    // print(widget.incorrectWords);
    int correctPercentage =
        (widget.correctWords.length + widget.incorrectWords.length) != 0
            ? (widget.correctWords.length /
                    (widget.correctWords.length +
                        widget.incorrectWords.length) *
                    100)
                .round()
            : 0;

    return Scaffold(
        appBar: AppBar(title: const Text("Result")),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Center(
                  child: Text(
                    "$correctPercentage%",
                    style: const TextStyle(fontSize: 40),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "${widget.correctWords.length} Correct Words 😊👏:",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.correctWords.length,
                    itemBuilder: (context, index) {
                      return WordCard(word: widget.correctWords[index]);
                    }),
                const SizedBox(
                  height: 30,
                ),
                Text(
                  "${widget.incorrectWords.length} Incorrect Words 🫣💩:",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.incorrectWords.length,
                    itemBuilder: (context, index) {
                      return WordCard(word: widget.incorrectWords[index]);
                    }),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(widget.tryAgainPage
                        // MaterialPageRoute(
                        //     builder: (context) => PagesLayout(
                        //         displayNavBar: false,
                        //         child: widget.tryAgainPage(
                        //           words: [
                        //             ...widget.correctWords,
                        //             ...widget.incorrectWords
                        //           ],
                        //         ))),
                        );
                  },
                  label: const Text("Try Again"),
                  icon: const Icon(Icons.restart_alt),
                ),
              ],
            ),
          ),
        ));
  }
}
