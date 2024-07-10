import 'package:flutter/material.dart';
import 'package:voclearner/models/word.dart';

class WritePage extends StatefulWidget {
  final List<Word> words;

  const WritePage({super.key, required this.words});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  late Word actualWord;

  @override
  void initState() {
    actualWord = widget.words[0];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Write")),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              actualWord.word ?? "",
              style: const TextStyle(fontSize: 30),
            ),
            const Spacer(), // Adds space between the text and the TextField
            const TextField(
              autocorrect: false,
              decoration: InputDecoration(
                labelText: "Type the term",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
