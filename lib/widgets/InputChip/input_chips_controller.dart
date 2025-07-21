import 'package:flutter/material.dart';
import 'package:quizflow/models/answer.dart';
import 'package:quizflow/widgets/InputChip/chips_controller.dart';

class InputChipsController extends ChipsController {
  final TextEditingController textController = TextEditingController();

  InputChipsController([super.initialChips]);

  String get text => textController.text;

  void updateText(String? text) {
    textController.text = text!;
  }

  @override
  void addAllChips(List<Answer> chips) {
    super.addAllChips(chips);
    if (chips.length > 1) {
      textController.text = chips.last.answer!;
    } else if (chips.length == 1) {
      textController.text = chips.first.answer!;
    }
  }
}
