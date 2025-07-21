import 'package:flutter/material.dart';
import 'package:quizflow/widgets/InputChip/flutter_input_chips.dart';
import 'package:quizflow/widgets/InputChip/input_chips_controller.dart';

class WordEditorCard extends StatefulWidget {
  final TextEditingController questionController;
  final InputChipsController answerController;

  const WordEditorCard({
    super.key,
    required this.questionController,
    required this.answerController,
  });

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
            FlutterInputChips(
              controller: widget.answerController,
              onChanged: (v) {},
              padding: const EdgeInsets.all(0),
              inputDecoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Answer',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
