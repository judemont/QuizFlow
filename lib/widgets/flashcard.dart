import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:voclearner/models/word.dart';

class FlashCard extends StatefulWidget {
  final Word word;
  final Function onSwipeLeft;
  final Function onSwipeRight;

  const FlashCard(
      {super.key,
      required this.word,
      required this.onSwipeLeft,
      required this.onSwipeRight});

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  bool flashCardFace = false;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        onDismissed: (direction) {
          direction == DismissDirection.endToStart
              ? widget.onSwipeLeft()
              : widget.onSwipeRight();
        },
        key: UniqueKey(),
        child: GestureDetector(
            onTap: () {
              setState(() {
                flashCardFace = !flashCardFace;
              });
            },
            child: FlipCard(
                direction: FlipDirection.HORIZONTAL,
                front: FlashcardCard(cardContent: widget.word.word ?? ""),
                back:
                    FlashcardCard(cardContent: widget.word.definition ?? ""))));
  }
}

class FlashcardCard extends StatelessWidget {
  final String cardContent;
  const FlashcardCard({super.key, required this.cardContent});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 80),
          child: Text(cardContent)),
    );
  }
}
