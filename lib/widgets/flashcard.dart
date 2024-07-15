import 'package:flutter/material.dart';

class FlashCard extends StatelessWidget {
  final String word;
  const FlashCard({super.key, required this.word});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: const EdgeInsets.all(8.0), child: Text(word)),
    );
  }
}
