import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:quizflow/models/word.dart';

class FlashCard extends StatefulWidget {
  final Word word;
  final void Function(Word) onSwipeLeft;
  final void Function(Word) onSwipeRight;
  final void Function(DismissUpdateDetails)? onDismissibleUpdate;

  const FlashCard(
      {super.key,
      required this.word,
      required this.onSwipeLeft,
      required this.onSwipeRight,
      this.onDismissibleUpdate});

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard> {
  bool flashCardFace = false;
  Color bgColor = Colors.transparent;
  @override
  Widget build(BuildContext context) {
    return Dismissible(
        onUpdate: widget.onDismissibleUpdate,
        onDismissed: (direction) {
          direction == DismissDirection.endToStart
              ? widget.onSwipeLeft(widget.word)
              : widget.onSwipeRight(widget.word);
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
                front: FlashcardCard(
                  cardContent: widget.word.word ?? "",
                ),
                back: FlashcardCard(
                  cardContent: widget.word.definition ?? "",
                ))));
  }
}

class FlashcardCard extends StatelessWidget {
  final String cardContent;
  const FlashcardCard({super.key, required this.cardContent});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: Container(
          height: 400, width: 300, child: Center(child: Text(cardContent))),
    );
  }
}
