import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:quizflow/models/answer.dart';
import 'package:quizflow/models/word.dart';
import 'package:quizflow/pages_layout.dart';
import 'package:quizflow/utilities/database.dart';
import 'package:quizflow/utilities/tts.dart';
import 'package:quizflow/widgets/InputChip/chips_controller.dart';
import 'package:quizflow/widgets/InputChip/flutter_chips.dart';
import 'package:quizflow/widgets/result_page.dart';
import 'package:rapidfuzz/rapidfuzz.dart';
import 'package:rapidfuzz/ratios/simple.dart';

class WritePage extends StatefulWidget {
  final List<Word> words;
  const WritePage({super.key, required this.words});

  @override
  State<WritePage> createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  late Word actualWord;
  late List<Answer> actualAnswers;
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
  bool _expanded = false;

  @override
  void initState() {
    wordsToLearn.addAll(widget.words..shuffle());
    nextWord();
    super.initState();
  }

  void nextWord({List<Answer>? initialAnswers}) async {
    print(wordsToLearn.map((e) => e.word).toList());
    print(widget.words);
    if (wordsToLearn.isNotEmpty) {
      actualWord = wordsToLearn[0];
      actualAnswers =
          initialAnswers ??
          await DatabaseService.getAnswersFromWord(actualWord.id!);

      setState(() {
        inputLabelText = defaultInputLabelText;
        displayGoodAnswerText = false;
        wrongAnswer = false;
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
                child: WritePage(words: incorrectWords),
              ),
            ),
          ),
        ),
      );
    }
  }

  Future<void> onTrue({int? index}) async {
    print("good answer");

    _expanded = false;

    if (index != null) {
      actualAnswers.removeAt(index);
    }

    if (actualAnswers.isEmpty) {
      wordsToLearn.removeAt(0);
    }

    setState(() {
      wrongAnswer = false;
      displayGoodAnswerText = true;
    });
    answerController.clear();

    await Future.delayed(Duration(seconds: waitTimeAfterCorrectAnswer));

    nextWord(initialAnswers: (actualAnswers.isNotEmpty ? actualAnswers : null));
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

    final index = actualAnswers.indexWhere(
      (a) => normalizeString(a.answer) == userAnswer,
    );

    if (index != -1) {
      onTrue(index: index);
    } else {
      onWrong();
    }
  }

  Widget getExpandedAnswers() {
    ChipsController controller = ChipsController(actualAnswers);

    return Column(
      children: [
        const Text(
          "Correct answer:",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
        FlutterChips(
          controller: controller,
          onChanged: (v) {},
          maxScrollViewHeight: 70,
        ),
      ],
    );
  }

  Widget getCorrectAnswer() {
    if (_expanded) return getExpandedAnswers();

    if (actualAnswers.length == 1) {
      return Text(
        "Correct answer: \"${actualAnswers.first.answer}\"",
        style: const TextStyle(
          color: Colors.green,
          fontWeight: FontWeight.bold,
        ),
      );
    }

    final result = extractOne<Answer>(
      query: userAnswer,
      choices: actualAnswers,
      ratio: const SimpleRatio(),
      getter: (Answer a) => normalizeString(a.answer) ?? '',
    );

    // TODO: Tune Levenshtein ratio threshold
    if (result.score >= 80) {
      return RichText(
        text: TextSpan(
          children: [
            TextSpan(text: "Correct answer: \"${result.choice.answer}\" "),
            TextSpan(
              text: "Show all",
              style: const TextStyle(
                color: Colors.blue,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () => setState(() => _expanded = true),
            ),
          ],
          style: const TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    return getExpandedAnswers();
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
              child: Column(
                children: [
                  wrongAnswer
                      ? getCorrectAnswer()
                      : const Text(
                          "Correct answer: Placeholder",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  const SizedBox(height: 10),
                  Text(
                    "Your answer: \"$userAnswer\" 🫣😳",
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Visibility(
              visible: displayGoodAnswerText,
              child: Text(
                goodAnswerText,
                style: const TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
                      decoration: InputDecoration(labelText: inputLabelText),
                    ),
                  ),
                ),
                Visibility(
                  visible: wrongAnswer,
                  child: IconButton(
                    onPressed: onTrue,
                    icon: const Icon(Icons.skip_next),
                  ),
                ),
                IconButton(
                  onPressed: () => onSubmit(),
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
