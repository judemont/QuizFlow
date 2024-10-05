import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:quizflow/models/subset.dart';
import 'package:quizflow/models/voc.dart';
import 'package:quizflow/models/word.dart';
import 'package:quizflow/pages_layout.dart';
import 'package:quizflow/utilities/database.dart';
import 'package:quizflow/widgets/dismissible_card.dart';
import 'package:quizflow/widgets/home_page.dart';
import 'package:quizflow/widgets/subset_editor_card.dart';
import 'package:quizflow/widgets/word_editor_card.dart';

class VocEditorPage extends StatefulWidget {
  final List<Subset>? initialSubsets;
  final List<Word>? initialWords;
  final Voc? initialVoc;
  const VocEditorPage(
      {super.key, this.initialWords, this.initialVoc, this.initialSubsets});

  @override
  State<VocEditorPage> createState() => _VocEditorPageState();
}

class _VocEditorPageState extends State<VocEditorPage> {
  final newVocFormKey = GlobalKey<FormState>();
  String title = "";
  String description = "";
  ValueNotifier<List<DismissibleCard>> wordsCards = ValueNotifier([]);
  ValueNotifier<List<DismissibleCard>> subsetsCards = ValueNotifier([]);
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void newWordCard({Word? initialWord}) {
    setState(() {
      TextEditingController questionController =
          TextEditingController(text: initialWord?.word ?? "");
      TextEditingController answerController =
          TextEditingController(text: initialWord?.answer ?? "");

      wordsCards.value.add(DismissibleCard(
        editorCards: wordsCards,
        onItemRemoved: () {
          setState(() {});
        },
        child: WordEditorCard(
          questionController: questionController,
          answerController: answerController,
        ),
      ));
    });
  }

  void newSubsetCard({Subset? initialSubset}) {
    setState(() {
      int from = initialSubset?.from ?? -1;
      int to = initialSubset?.to ?? -1;

      subsetsCards.value.add(DismissibleCard(
        editorCards: subsetsCards,
        onItemRemoved: () {
          setState(() {});
        },
        child: SubsetEditorCard(
          wordEditorCardsNotifier: wordsCards,
          from: from,
          to: to,
        ),
      ));
    });
  }

  Future<void> save() async {
    print(title);

    int vocId;
    if (widget.initialVoc == null) {
      vocId = await DatabaseService.createVoc(
          Voc(title: title, description: description));
    } else {
      print("update voc");
      vocId = widget.initialVoc!.id!;
      DatabaseService.updateVoc(
          Voc(title: title, description: description, id: vocId));
    }

    if (widget.initialWords != null) {
      // TO BE FIXED !;
      print("updates words");
      await DatabaseService.removeWordsFromVoc(vocId);
    }
    for (int i = 0; i < wordsCards.value.length; i++) {
      if (wordsCards.value[i].child is WordEditorCard &&
          (wordsCards.value[i].child as WordEditorCard)
              .questionController
              .text
              .isNotEmpty &&
          (wordsCards.value[i].child as WordEditorCard)
              .answerController
              .text
              .isNotEmpty) {
        await DatabaseService.createWord(Word(
            vocId: vocId,
            word: (wordsCards.value[i].child as WordEditorCard)
                .questionController
                .text,
            answer: (wordsCards.value[i].child as WordEditorCard)
                .answerController
                .text));
      }
    }
    if (widget.initialSubsets != null) {
      // TO BE FIXED !;
      print("updates subsets");
      await DatabaseService.removeSubsetsFromVoc(vocId);
    }
    for (int i = 0; i < subsetsCards.value.length; i++) {
      if (subsetsCards.value[i].child is SubsetEditorCard &&
          (subsetsCards.value[i].child as SubsetEditorCard).from != -1 &&
          (subsetsCards.value[i].child as SubsetEditorCard).to != -1) {
        await DatabaseService.createSubset(Subset(
            vocId: vocId,
            from: (subsetsCards.value[i].child as SubsetEditorCard).from,
            to: (subsetsCards.value[i].child as SubsetEditorCard).to));
      }
    }
    return;
  }

  @override
  void initState() {
    if (widget.initialVoc != null) {
      titleController.text = widget.initialVoc!.title!;
      descriptionController.text = widget.initialVoc!.description!;
    }

    if (widget.initialWords != null) {
      print("BBBAA");
      for (Word word in widget.initialWords!) {
        newWordCard(initialWord: word);
      }
    } else {
      for (var i = 0; i < 3; i++) {
        newWordCard();
      }
    }

    if (widget.initialSubsets != null) {
      print("BBBAA");
      for (Subset subset in widget.initialSubsets!) {
        newSubsetCard(initialSubset: subset);
      }
    } else {
      for (var i = 0; i < 1; i++) {
        newSubsetCard();
      }
    }
    super.initState();
  }

  Future<void> userImportVoc() async {
    const XTypeGroup typeGroup = XTypeGroup(
      label: 'QuizFlow list export',
      extensions: <String>['json'],
    );
    final XFile? file =
        await openFile(acceptedTypeGroups: <XTypeGroup>[typeGroup]);

    if (file != null) {
      var fileBytes = await file.readAsBytes();
      String backupContent = utf8.decode(fileBytes);
      Map<String, dynamic> data = jsonDecode(backupContent);

      for (var word in data["words"]) {
        newWordCard(initialWord: Word.fromMap(word));
      }
      for (var subset in data["subsets"]) {
        newSubsetCard(initialSubset: Subset.fromMap(subset));
      }
      titleController.text = data["title"];
      descriptionController.text = data["description"];
    }
  }

  void handleImportMenuClick(String value) {
    if (value == "Import from file") {
      userImportVoc();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialVoc == null ? "New List" : "Edit List"),
        actions: [
          PopupMenuButton(
              icon: const Icon(Icons.download),
              onSelected: handleImportMenuClick,
              itemBuilder: (BuildContext context) {
                return {'Import from file'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              }),
          IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                if (newVocFormKey.currentState!.validate()) {
                  newVocFormKey.currentState!.save();

                  save().then((v) => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const PagesLayout(
                                  currentSection: 0,
                                  child: HomePage(),
                                )),
                        (Route<dynamic> route) => false,
                      ));
                }
              }),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
            key: newVocFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 56),
              child: Column(
                children: [
                  TextFormField(
                    // initialValue: widget.initialVoc?.title ?? "",
                    controller: titleController,
                    onSaved: (value) {
                      title = value!;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Title',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    onSaved: (value) {
                      description = value!;
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Description',
                    ),
                  ),
                  const SizedBox(height: 40),
                  Column(
                    children: [
                      const Text(
                        "Subsets:",
                        style: TextStyle(fontSize: 20),
                      ),
                      Column(
                        children: subsetsCards.value,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            newSubsetCard();
                          },
                          child: const Text("New")),
                      const SizedBox(
                        height: 40,
                      ),
                      const Text(
                        "Words:",
                        style: TextStyle(fontSize: 20),
                      ),
                      Column(
                        children: wordsCards.value,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            newWordCard();
                          },
                          child: const Text("New"))
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
