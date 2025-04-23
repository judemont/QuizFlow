import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:quizflow/models/word.dart';
import 'package:quizflow/utilities/tts.dart';

class FlashCard extends StatefulWidget {
  final Word word;
  final void Function(Word) onSwipeLeft;
  final void Function(Word) onSwipeRight;
  final void Function(DismissUpdateDetails)? onDismissibleUpdate;
  final void Function()? onFlip;

  const FlashCard(
      {super.key,
      required this.word,
      required this.onSwipeLeft,
      required this.onSwipeRight,
      this.onFlip,
      this.onDismissibleUpdate});

  @override
  FlashCardState createState() => FlashCardState();
}

class FlashCardState extends State<FlashCard> {
  bool flashCardFace = false;
  Color bgColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
  }

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
                onFlip: widget.onFlip,
                direction: FlipDirection.HORIZONTAL,
                front: FlashcardCard(
                  cardContent: widget.word.word ?? "",
                  onTapSpeech: () => TTS().speech(widget.word.word ?? ""),
                ),
                back: FlashcardCard(
                  cardContent: widget.word.answer ?? "",
                  onTapSpeech: () => TTS().speech(widget.word.answer ?? ""),
                ))));
  }
}

class FlashcardCard extends StatelessWidget {
  final String cardContent;
  final void Function() onTapSpeech;
  const FlashcardCard(
      {super.key, required this.cardContent, required this.onTapSpeech});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: Stack(
        children: [
          SizedBox(
            height: 400,
            width: 300,
            child: Center(
              child: Text(
                cardContent,
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.volume_up),
              onPressed: onTapSpeech,
            ),
          ),
        ],
      ),
    );
  }
}
