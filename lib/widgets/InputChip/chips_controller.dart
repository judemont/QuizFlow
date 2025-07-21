import 'package:flutter/material.dart';
import 'package:quizflow/models/answer.dart';

class ChipsController extends ChangeNotifier {
  final Set<String?> _chips = <String>{};

  Set<String?> get chips => _chips;

  ChipsController([List<Answer> initialChips = const []]) {
    addAllChips(initialChips);
  }

  void addChip(String chip) {
    _chips.add(chip);
    notifyListeners();
  }

  void removeChip(String? chip) {
    _chips.remove(chip);
    notifyListeners();
  }

  void addAllChips(List<Answer> chips) {
    for (Answer answer in chips) {
      _chips.add(answer.answer);
    }
    notifyListeners();
  }
}
