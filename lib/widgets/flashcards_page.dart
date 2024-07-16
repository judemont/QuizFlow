import 'package:flutter/material.dart';
import 'package:quizflow/models/word.dart';
import 'package:quizflow/widgets/flashcard.dart';

class FlashcardsPage extends StatefulWidget {
  final List<Word> words;
  const FlashcardsPage({super.key, required this.words});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  List<Widget> wordsCards = [];
  String? topMessage = '';

  @override
  void initState() {
    for (var word in widget.words..shuffle()) {
      wordsCards.add(Center(
          child: FlashCard(
        onSwipeLeft: () {},
        onSwipeRight: () {},
        word: word,
        onDismissibleUpdate: (detail) {
          setState(() {
            if (detail.direction == DismissDirection.startToEnd) {
              topMessage = "I know it ! 😊👏";
            } else if (detail.direction == DismissDirection.endToStart) {
              topMessage = "I still need to train it 🫣💩";
            } else {
              topMessage = null;
            }
          });
        },
      )));
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flashcards')),
      body: Column(children: [
        const SizedBox(
          height: 20,
        ),
        SizedBox(
            height: 60,
            child: Visibility(
              visible: topMessage != null,
              child: Text(
                topMessage ?? "",
                style: const TextStyle(fontSize: 20),
              ),
            )),
        Stack(
          children: wordsCards,
        ),
      ]),
    );
  }
}
