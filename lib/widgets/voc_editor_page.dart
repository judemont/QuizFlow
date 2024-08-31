import 'dart:convert';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:quizflow/models/voc.dart';
import 'package:quizflow/models/word.dart';
import 'package:quizflow/pages_layout.dart';
import 'package:quizflow/utilities/database.dart';
import 'package:quizflow/widgets/home_page.dart';
import 'package:quizflow/widgets/word_editor_card.dart';

class VocEditorPage extends StatefulWidget {
  final List<Word>? initialWords;
  final Voc? initialVoc;
  const VocEditorPage({super.key, this.initialWords, this.initialVoc});

  @override
  State<VocEditorPage> createState() => _VocEditorPageState();
}

class _VocEditorPageState extends State<VocEditorPage> {
  final newVocFormKey = GlobalKey<FormState>();
  String title = "";
  String description = "";
  List<Widget> wordsCards = [];
  List<List<TextEditingController>> wordsControllers = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  void newCard({Word? initialWord}) {
    setState(() {
      TextEditingController questionController =
          TextEditingController(text: initialWord?.word ?? "");
      TextEditingController answerController =
          TextEditingController(text: initialWord?.answer ?? "");

      int wordIndex = wordsControllers.length + 1;

      wordsCards.add(Dismissible(
        direction: DismissDirection.endToStart,
        onDismissed: (DismissDirection direction) {
          print('Dismissed with direction $direction');
          print(answerController.text);
          wordsControllers.removeAt(wordIndex);
        },
        // confirmDismiss:
        //     (DismissDirection direction) async {
        //   return false;
        // },
        background: const ColoredBox(
          color: Colors.red,
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
          ),
        ),
        key: UniqueKey(),
        child: WordEditorCard(
          questionController: questionController,
          answerController: answerController,
        ),
      ));

      wordsControllers.add([questionController, answerController]);
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
    for (int i = 0; i < wordsControllers.length; i++) {
      if (wordsControllers[i][0].text.isNotEmpty &&
          wordsControllers[i][1].text.isNotEmpty) {
        await DatabaseService.createWord(Word(
            vocId: vocId,
            word: wordsControllers[i][0].text,
            answer: wordsControllers[i][1].text));
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
        newCard(initialWord: word);
      }
    } else {
      for (var i = 0; i < 3; i++) {
        newCard();
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
        newCard(initialWord: Word.fromMap(word));
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
                      Column(
                        children: wordsCards,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            newCard();
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
