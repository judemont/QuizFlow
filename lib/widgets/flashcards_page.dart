import 'package:flutter/material.dart';
import 'package:voclearner/models/word.dart';
import 'package:voclearner/widgets/flashcard.dart';

class FlashcardsPage extends StatefulWidget {
  final List<Word> words;
  const FlashcardsPage({super.key, required this.words});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  late Word actualWord;
  List<Word> wordsToLearn = [];

  @override
  void initState() {
    wordsToLearn.addAll(widget.words..shuffle());
    nextCard();
    super.initState();
  }

  void nextCard() {
    setState(() {
      actualWord = wordsToLearn[0];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: Container(
        child: Column(
          children: [
            FlashCard(
              onSwipeLeft: () {},
              onSwipeRight: () {},
              word: actualWord,
            ),
          ],
        ),
      ),
    );
  }
}
