import 'package:flutter/material.dart';

class WordEditorCard extends StatefulWidget {
  final TextEditingController termController;
  final TextEditingController definitionController;

  const WordEditorCard(
      {super.key,
      required this.termController,
      required this.definitionController});

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
              controller: widget.termController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Term',
              ),
            ),
            TextField(
              controller: widget.definitionController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Definition',
              ),
            )
          ],
        ),
      ),
    );
  }
}
