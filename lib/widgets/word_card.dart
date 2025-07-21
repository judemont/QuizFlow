import 'package:flutter/material.dart';
import 'package:quizflow/models/answer.dart';
import 'package:quizflow/models/word.dart';
import 'package:quizflow/utilities/database.dart';
import 'package:quizflow/widgets/InputChip/chips_controller.dart';
import 'package:quizflow/widgets/InputChip/flutter_chips.dart';

class WordCard extends StatelessWidget {
  final Word word;
  const WordCard({super.key, required this.word});

  Future<Widget> getAnswers() async {
    List<Answer> answers = await DatabaseService.getAnswersFromWord(word.id!);

    if (answers.length == 1) {
      return Text(
        answers.first.answer ?? "",
        style: const TextStyle(fontSize: 20),
      );
    }

    ChipsController controller = ChipsController(answers);

    return FlutterChips(controller: controller, onChanged: (v) {});
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text(word.word ?? "", style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            FutureBuilder<Widget>(
              future: getAnswers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return snapshot.data!;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
