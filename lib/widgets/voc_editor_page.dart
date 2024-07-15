import 'package:flutter/material.dart';
import 'package:voclearner/models/voc.dart';
import 'package:voclearner/models/word.dart';
import 'package:voclearner/pages_layout.dart';
import 'package:voclearner/services/database.dart';
import 'package:voclearner/widgets/home_page.dart';
import 'package:voclearner/widgets/word_editor_card.dart';

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

  void newCard({Word? initialWord}) {
    setState(() {
      TextEditingController termController =
          TextEditingController(text: initialWord?.word ?? "");
      TextEditingController definitionController =
          TextEditingController(text: initialWord?.definition ?? "");

      int wordIndex = wordsControllers.length + 1;

      wordsCards.add(Dismissible(
        direction: DismissDirection.endToStart,
        onDismissed: (DismissDirection direction) {
          print('Dismissed with direction $direction');
          print(definitionController.text);
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
          termController: termController,
          definitionController: definitionController,
        ),
      ));

      wordsControllers.add([termController, definitionController]);
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
      await DatabaseService.createWord(Word(
          vocId: vocId,
          word: wordsControllers[i][0].text,
          definition: wordsControllers[i][1].text));
    }
    return;
  }

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.initialVoc == null ? "New Voc" : "Edit Voc"),
        actions: [
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
              })
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
                    initialValue: widget.initialVoc?.title ?? "",
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
                    initialValue: widget.initialVoc?.description ?? "",
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
