import 'package:flutter/material.dart';
import 'package:quizflow/models/word.dart';
import 'package:quizflow/pages_layout.dart';
import 'package:quizflow/widgets/flashcard.dart';
import 'package:quizflow/widgets/result_page.dart';

class FlashcardsPage extends StatefulWidget {
  final List<Word> words;
  const FlashcardsPage({super.key, required this.words});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  List<Widget> wordsCards = [];
  String? topMessage = '';
  List<Word> incorrectWords = [];
  int cardIndex = 0;

  void endOfGame() {
    List<Word> completedWords = [];
    completedWords.addAll(widget.words);
    print(completedWords);
    print("AA");

    completedWords.removeWhere((e) => incorrectWords.contains(e));

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => ResultPage(
          correctWords: completedWords,
          incorrectWords: incorrectWords,
          tryAgainWithIncorrectPage: MaterialPageRoute(
              builder: (context) => PagesLayout(
                  displayNavBar: false,
                  child: FlashcardsPage(
                    words: incorrectWords,
                  ))),
        ),
      ),
    );
  }

  void newCard(Word word) {
    setState(() {
      wordsCards.add(Center(
          child: FlashCard(
        onSwipeLeft: (word) {
          cardIndex++;
          print("swipeLeft");
          if (!incorrectWords.contains(word)) {
            incorrectWords.add(word);
          }

          if (cardIndex >= widget.words.length) {
            endOfGame();
          }
        },
        onSwipeRight: (word) {
          cardIndex++;
          print("right");
          if (cardIndex >= widget.words.length) {
            endOfGame();
          }
        },
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
    });
  }

  @override
  void initState() {
    for (var word in widget.words..shuffle()) {
      newCard(word);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FlashCards')),
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
