import 'package:flutter/material.dart';

class WordEditorCard extends StatefulWidget {
  final TextEditingController questionController;
  final TextEditingController answerController;

  const WordEditorCard(
      {super.key,
      required this.questionController,
      required this.answerController});

  @override
  State<WordEditorCard> createState() => _WordEditorCardState();
}

class _WordEditorCardState extends State<WordEditorCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: widget.questionController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Question',
              ),
            ),
            TextField(
              controller: widget.answerController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Answer',
              ),
            )
          ],
        ),
      ),
    );
  }
}
