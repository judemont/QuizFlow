import 'package:flutter/material.dart';
import 'package:voclearner/models/word.dart';

class ResultPage extends StatefulWidget {
  final List<Word> correctWords;
  final List<Word> incorrectWords;
  const ResultPage({
    super.key,
    required this.correctWords,
    required this.incorrectWords,
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
      body: Container(
        child: Column(
          children: [
            Text(
              "$correctPercentage %",
              style: const TextStyle(fontSize: 20),
            )
          ],
        ),
      ),
    );
  }
}
