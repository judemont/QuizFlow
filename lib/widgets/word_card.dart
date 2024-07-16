import 'package:flutter/material.dart';
import 'package:quizflow/models/word.dart';

class WordCard extends StatelessWidget {
  final Word word;
  const WordCard({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(word.word ?? ""),
            const SizedBox(
              height: 20,
            ),
            Text(word.definition ?? "")
          ],
        ),
      ),
    );
  }
}
