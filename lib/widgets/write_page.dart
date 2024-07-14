import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:voclearner/models/word.dart';

class WritePage extends StatefulWidget {
  final List<Word> words;
  const WritePage({super.key, required this.words});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  late Word actualWord;
  late List<Word> wordsToLearn;
  TextEditingController answerController = TextEditingController();
  bool displayGoodAnswerText = false;
  bool wrongAnswer = false;
  String goodAnswerText = "Good answer ! D;";
  String userAnswer = "";
  final String defaultInputLabelText = "Type the term";
  String inputLabelText = "";
  final int waitTimeAfterCorrectAnswer = 2;
  int actualWordIndex = 0;
  List<Word> incorrectWords = [];

  @override
  void initState() {
    List<Word> wordsToLearn = widget.words..shuffle();

    nextWord();
    super.initState();
  }

  void nextWord() {
    if (actualWordIndex < wordsToLearn.length) {
      actualWordIndex++;
      setState(() {
        inputLabelText = defaultInputLabelText;
        displayGoodAnswerText = false;
        wrongAnswer = false;
        actualWord = wordsToLearn[actualWordIndex];
        answerController.clear();
      });
    } else {}
  }

  Future<void> onTrue() async {
    print("good answer");
    setState(() {
      wrongAnswer = false;
      displayGoodAnswerText = true;
    });
    answerController.clear();

    await Future.delayed(Duration(seconds: waitTimeAfterCorrectAnswer));
    nextWord();
  }

  void onWrong() {
    print("bad answer");
    wordsToLearn.add(actualWord);
    incorrectWords.add(actualWord);

    setState(() {
      wrongAnswer = true;
      answerController.clear();
      inputLabelText = "Write the correct answer";
    });
  }

  void onSubmit() {
    setState(() {
      userAnswer = answerController.text;
    });
    if (actualWord.definition == userAnswer) {
      onTrue();
    } else {
      onWrong();
    }
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
            const Spacer(),
            Visibility(
              visible: wrongAnswer,
              child: Column(children: [
                Text(
                  "Correct answer: '${actualWord.definition}'",
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text("Your answer: '$userAnswer'",
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ]),
            ),
            Visibility(
                visible: displayGoodAnswerText,
                child: Text(
                  goodAnswerText,
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                )),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: answerController,
                    autofocus: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: inputLabelText,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                    onPressed: () => onSubmit(), icon: const Icon(Icons.send))
              ],
            )
          ],
        ),
      ),
    );
  }
}
