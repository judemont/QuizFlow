import 'package:flutter/material.dart';
import 'package:quizflow/widgets/dismissible_card.dart';
import 'package:quizflow/widgets/word_editor_card.dart';

// ignore: must_be_immutable
class SubsetEditorCard extends StatefulWidget {
  final ValueNotifier<List<DismissibleCard>> wordEditorCardsNotifier;
  int from;
  int to;

  SubsetEditorCard(
      {super.key,
      required this.wordEditorCardsNotifier,
      required this.from,
      required this.to});

  @override
  State<SubsetEditorCard> createState() => _SubsetEditorCardState();
}

class _SubsetEditorCardState extends State<SubsetEditorCard> {
  bool isFromSelected = false;
  bool isToSelected = false;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<DismissibleCard>>(
        valueListenable: widget.wordEditorCardsNotifier,
        builder: (context, wordEditorCards, child) {
          return Card(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Autocomplete<String>(
                        optionsBuilder:
                            (TextEditingValue textEditingValue) async {
                          if (widget.wordEditorCardsNotifier.value.isEmpty) {
                            return const Iterable<String>.empty();
                          }

                          if (textEditingValue.text.isEmpty) {
                            return widget.wordEditorCardsNotifier.value
                                .map((e) {
                              if (e.child is WordEditorCard &&
                                  (e.child as WordEditorCard)
                                      .questionController
                                      .text
                                      .isNotEmpty &&
                                  (e.child as WordEditorCard)
                                      .answerController
                                      .text
                                      .isNotEmpty) {
                                return (e.child as WordEditorCard)
                                    .questionController
                                    .text;
                              }
                            }).where((String? option) {
                              return option != null &&
                                  option.isNotEmpty &&
                                  (widget.to == -1 ||
                                      widget.wordEditorCardsNotifier.value
                                              .indexWhere((element) {
                                            if (element.child
                                                is WordEditorCard) {
                                              return (element.child
                                                          as WordEditorCard)
                                                      .questionController
                                                      .text
                                                      .toLowerCase() ==
                                                  option.toLowerCase();
                                            } else {
                                              return false;
                                            }
                                          }) <
                                          widget.to);
                            }).cast<String>();
                          }

                          return widget.wordEditorCardsNotifier.value.map((e) {
                            if (e.child is WordEditorCard &&
                                (e.child as WordEditorCard)
                                    .questionController
                                    .text
                                    .isNotEmpty &&
                                (e.child as WordEditorCard)
                                    .answerController
                                    .text
                                    .isNotEmpty) {
                              return (e.child as WordEditorCard)
                                  .questionController
                                  .text;
                            }
                          }).where((String? option) {
                            return option != null &&
                                option.isNotEmpty &&
                                (widget.to == -1 ||
                                    widget.wordEditorCardsNotifier.value
                                            .indexWhere((element) {
                                          if (element.child is WordEditorCard) {
                                            return (element.child
                                                        as WordEditorCard)
                                                    .questionController
                                                    .text
                                                    .toLowerCase() ==
                                                option.toLowerCase();
                                          } else {
                                            return false;
                                          }
                                        }) <
                                        widget.to) &&
                                option.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase());
                          }).cast<String>();
                        },
                        onSelected: (String selection) {
                          setState(() {
                            widget.from = widget.wordEditorCardsNotifier.value
                                .indexWhere((element) {
                              if (element.child is WordEditorCard) {
                                return (element.child as WordEditorCard)
                                        .questionController
                                        .text ==
                                    selection;
                              } else {
                                return false;
                              }
                            });
                            isFromSelected = true;
                          });
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          if (widget.from != -1 &&
                              widget.wordEditorCardsNotifier.value[widget.from]
                                  .child is WordEditorCard) {
                            if (textEditingController.text != "" &&
                                (widget
                                            .wordEditorCardsNotifier
                                            .value[widget.from]
                                            .child as WordEditorCard)
                                        .questionController
                                        .text !=
                                    textEditingController.text) {
                              widget.from = -1;
                              widget.to -= 1;
                              textEditingController.clear();
                            } else {
                              textEditingController.text = (widget
                                      .wordEditorCardsNotifier
                                      .value[widget.from]
                                      .child as WordEditorCard)
                                  .questionController
                                  .text;
                            }
                          }

                          focusNode.addListener(() {
                            if (!focusNode.hasFocus) {
                              if (!isFromSelected) {
                                if (widget.from != -1 &&
                                    widget
                                        .wordEditorCardsNotifier
                                        .value[widget.from]
                                        .child is WordEditorCard) {
                                  if (textEditingController.text != "") {
                                    textEditingController.text = (widget
                                            .wordEditorCardsNotifier
                                            .value[widget.from]
                                            .child as WordEditorCard)
                                        .questionController
                                        .text;
                                  } else {
                                    widget.from = -1;
                                  }
                                } else {
                                  textEditingController.clear();
                                }
                              }
                              isFromSelected = false;
                            }
                          });

                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'From',
                            ),
                          );
                        },
                      ),
                      Autocomplete<String>(
                        optionsBuilder:
                            (TextEditingValue textEditingValue) async {
                          if (textEditingValue.text.isEmpty) {
                            return widget.wordEditorCardsNotifier.value
                                .map((e) {
                              if (e.child is WordEditorCard &&
                                  (e.child as WordEditorCard)
                                      .questionController
                                      .text
                                      .isNotEmpty &&
                                  (e.child as WordEditorCard)
                                      .answerController
                                      .text
                                      .isNotEmpty) {
                                return (e.child as WordEditorCard)
                                    .questionController
                                    .text;
                              }
                            }).where((String? option) {
                              return option != null &&
                                  option.isNotEmpty &&
                                  widget.wordEditorCardsNotifier.value
                                          .indexWhere((element) {
                                        if (element.child is WordEditorCard) {
                                          return (element.child
                                                      as WordEditorCard)
                                                  .questionController
                                                  .text
                                                  .toLowerCase() ==
                                              option.toLowerCase();
                                        } else {
                                          return false;
                                        }
                                      }) >
                                      widget.from;
                            }).cast<String>();
                          }

                          return widget.wordEditorCardsNotifier.value.map((e) {
                            if (e.child is WordEditorCard &&
                                (e.child as WordEditorCard)
                                    .questionController
                                    .text
                                    .isNotEmpty &&
                                (e.child as WordEditorCard)
                                    .answerController
                                    .text
                                    .isNotEmpty) {
                              return (e.child as WordEditorCard)
                                  .questionController
                                  .text;
                            }
                          }).where((String? option) {
                            return option != null &&
                                option.isNotEmpty &&
                                widget.wordEditorCardsNotifier.value
                                        .indexWhere((element) {
                                      if (element.child is WordEditorCard) {
                                        return (element.child as WordEditorCard)
                                                .questionController
                                                .text
                                                .toLowerCase() ==
                                            option.toLowerCase();
                                      } else {
                                        return false;
                                      }
                                    }) >
                                    widget.from &&
                                option.toLowerCase().contains(
                                    textEditingValue.text.toLowerCase());
                          }).cast<String>();
                        },
                        onSelected: (String selection) {
                          setState(() {
                            widget.to = widget.wordEditorCardsNotifier.value
                                .indexWhere((element) {
                              if (element.child is WordEditorCard) {
                                return (element.child as WordEditorCard)
                                        .questionController
                                        .text ==
                                    selection;
                              } else {
                                return false;
                              }
                            });
                            isToSelected = true;
                          });
                        },
                        fieldViewBuilder: (BuildContext context,
                            TextEditingController textEditingController,
                            FocusNode focusNode,
                            VoidCallback onFieldSubmitted) {
                          if (widget.to != -1 &&
                              widget.to <
                                  widget.wordEditorCardsNotifier.value.length &&
                              widget.wordEditorCardsNotifier.value[widget.to]
                                  .child is WordEditorCard) {
                            if (textEditingController.text != "" &&
                                (widget.wordEditorCardsNotifier.value[widget.to]
                                            .child as WordEditorCard)
                                        .questionController
                                        .text !=
                                    textEditingController.text) {
                              widget.to = -1;
                              textEditingController.clear();
                            } else {
                              textEditingController.text = (widget
                                      .wordEditorCardsNotifier
                                      .value[widget.to]
                                      .child as WordEditorCard)
                                  .questionController
                                  .text;
                            }
                          } else {
                            widget.to = -1;
                            textEditingController.clear();
                          }

                          focusNode.addListener(() {
                            if (!focusNode.hasFocus) {
                              if (!isToSelected) {
                                if (widget.to != -1 &&
                                    widget
                                        .wordEditorCardsNotifier
                                        .value[widget.to]
                                        .child is WordEditorCard) {
                                  if (textEditingController.text != "") {
                                    textEditingController.text = (widget
                                            .wordEditorCardsNotifier
                                            .value[widget.to]
                                            .child as WordEditorCard)
                                        .questionController
                                        .text;
                                  } else {
                                    widget.to = -1;
                                  }
                                } else {
                                  textEditingController.clear();
                                }
                              }
                              isToSelected = false;
                            }
                          });

                          return TextField(
                            controller: textEditingController,
                            focusNode: focusNode,
                            decoration: const InputDecoration(
                              border: UnderlineInputBorder(),
                              labelText: 'To',
                            ),
                          );
                        },
                      ),
                    ],
                  )));
        });
  }
}
