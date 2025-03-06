import 'package:flutter/material.dart';
import 'package:quizflow/models/word.dart';
import 'package:quizflow/pages_layout.dart';
import 'package:quizflow/utilities/tts.dart';
import 'package:quizflow/widgets/result_page.dart';

class WritePage extends StatefulWidget {
  final List<Word> words;
  const WritePage({super.key, required this.words});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  late Word actualWord;
  List<Word> wordsToLearn = [];
  TextEditingController answerController = TextEditingController();
  bool displayGoodAnswerText = false;
  bool wrongAnswer = false;
  String goodAnswerText = "Good answer ! 😊👏";
  String userAnswer = "";
  final String defaultInputLabelText = "Type the question";
  String inputLabelText = "";
  final int waitTimeAfterCorrectAnswer = 2;
  List<Word> incorrectWords = [];

  @override
  void initState() {
    wordsToLearn.addAll(widget.words..shuffle());
    nextWord();
    super.initState();
  }

  void nextWord() {
    print(wordsToLearn.map((e) => e.word).toList());
    print(widget.words);
    if (wordsToLearn.isNotEmpty) {
      setState(() {
        inputLabelText = defaultInputLabelText;
        displayGoodAnswerText = false;
        wrongAnswer = false;
        actualWord = wordsToLearn[0];
        answerController.clear();
      });
    } else {
      print(widget.words);
      List<Word> completedWords = widget.words;
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
                    child: WritePage(
                      words: incorrectWords,
                    ))),
          ),
        ),
      );
    }
  }

  Future<void> onTrue() async {
    print("good answer");
    wordsToLearn.removeAt(0);
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
    if (!incorrectWords.contains(actualWord)) {
      wordsToLearn.add(actualWord);
      incorrectWords.add(actualWord);
    }

    setState(() {
      wrongAnswer = true;
      answerController.clear();
      inputLabelText = "Write the correct answer";
    });
  }

  String? normalizeString(String? str) {
    List<String> specialChars = ["?", "!", ".", ",", ";", ":"];

    for (var element in specialChars) {
      str = str?.replaceAll(element, "");
    }

    return str?.toLowerCase().trim();
  }

  void onSubmit() {
    setState(() {
      userAnswer = normalizeString(answerController.text)!;
    });
    if (normalizeString(actualWord.answer) == userAnswer) {
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
        margin: const EdgeInsets.only(left: 10, right: 10, top: 50, bottom: 20),
        child: Column(
          children: [
            Wrap(
              children: [
                Text(
                  actualWord.word ?? "",
                  style: const TextStyle(fontSize: 30),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () => TTS().speech(actualWord.word ?? ""),
                ),
              ],
            ),
            const Spacer(),
            Visibility(
              visible: wrongAnswer,
              child: Column(children: [
                Text(
                  "Correct answer: \"${actualWord.answer}\"",
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text("Your answer: \"$userAnswer\" 🫣😳",
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
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
                    child: Form(
                  child: TextFormField(
                    onFieldSubmitted: (v) => onSubmit(),
                    controller: answerController,
                    autofocus: true,
                    autocorrect: false,
                    decoration: InputDecoration(
                      labelText: inputLabelText,
                    ),
                  ),
                )),
                Visibility(
                    visible: wrongAnswer,
                    child: IconButton(
                        onPressed: onTrue, icon: const Icon(Icons.skip_next))),
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
