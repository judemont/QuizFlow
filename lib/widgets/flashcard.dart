import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:quizflow/models/answer.dart';
import 'package:quizflow/models/word.dart';
import 'package:quizflow/utilities/database.dart';
import 'package:quizflow/utilities/tts.dart';
import 'package:quizflow/widgets/InputChip/chips_controller.dart';
import 'package:quizflow/widgets/InputChip/flutter_chips.dart';

class FlashCard extends StatefulWidget {
  final Word word;
  final void Function(Word) onSwipeLeft;
  final void Function(Word) onSwipeRight;
  final void Function(DismissUpdateDetails)? onDismissibleUpdate;
  final void Function(bool)? onFlip;

  const FlashCard({
    super.key,
    required this.word,
    required this.onSwipeLeft,
    required this.onSwipeRight,
    this.onFlip,
    this.onDismissibleUpdate,
  });

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

  Future<Widget> getFlipCard() async {
    List<Answer> answers = await DatabaseService.getAnswersFromWord(
      widget.word.id!,
    );
    late Widget cardContent;

    if (answers.length == 1) {
      cardContent = Text(
        answers.first.answer ?? "",
        style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
      );
    } else {
      ChipsController controller = ChipsController(answers);
      cardContent = FlutterChips(
        controller: controller,
        onChanged: (v) {},
        onChipSelected: (value) {
          TTS().speech(value ?? "");
        },
        maxScrollViewHeight: 320,
      );
    }

    return FlipCard(
      onFlipDone: (isFront) => widget.onFlip,
      direction: FlipDirection.HORIZONTAL,
      front: FlashcardCard(
        cardContent: Text(
          widget.word.word ?? "",
          style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        ),
        onTapSpeech: () => TTS().speech(widget.word.word ?? ""),
      ),
      back: FlashcardCard(cardContent: cardContent),
    );
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
        child: FutureBuilder<Widget>(
          future: getFlipCard(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return snapshot.data!;
            }
          },
        ),
      ),
    );
  }
}

class FlashcardCard extends StatelessWidget {
  final Widget cardContent;
  final void Function()? onTapSpeech;
  const FlashcardCard({super.key, required this.cardContent, this.onTapSpeech});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      child: Stack(
        children: [
          SizedBox(height: 400, width: 300, child: Center(child: cardContent)),
          onTapSpeech != null
              ? Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton(
                    icon: const Icon(Icons.volume_up),
                    onPressed: onTapSpeech,
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
