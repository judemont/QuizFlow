import 'package:flutter/material.dart';

class WordEditorCard extends StatefulWidget {
  const WordEditorCard({super.key});

  @override
  State<WordEditorCard> createState() => _WordEditorCardState();
}

class _WordEditorCardState extends State<WordEditorCard> {
  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                border: UnderlineInputBorder(),
                labelText: 'Term',
              ),
            ),
            TextField(
              decoration: InputDecoration(
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
