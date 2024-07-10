import 'package:flutter/material.dart';
import 'package:voclearner/models/voc.dart';
import 'package:voclearner/models/word.dart';
import 'package:voclearner/pages_layout.dart';
import 'package:voclearner/services/database.dart';
import 'package:voclearner/widgets/home_page.dart';
import 'package:voclearner/widgets/word_editor_card.dart';

class NewVocPage extends StatefulWidget {
  const NewVocPage({super.key});

  @override
  State<NewVocPage> createState() => _NewVocPageState();
}

class _NewVocPageState extends State<NewVocPage> {
  final newVocFormKey = GlobalKey<FormState>();
  String title = "";
  String description = "";
  List<Widget> wordsCards = [];
  List<List<TextEditingController>> wordsControllers = [];

  Future<void> save() async {
    print(title);
    int vocId = await DatabaseService.createVoc(
        Voc(title: title, description: description));

    for (int i = 0; i < wordsControllers.length; i++) {
      await DatabaseService.createWord(Word(
          vocId: vocId,
          word: wordsControllers[i][0].text,
          definition: wordsControllers[i][1].text));
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Voc"),
        actions: [
          IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                if (newVocFormKey.currentState!.validate()) {
                  newVocFormKey.currentState!.save();

                  save().then((v) => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const PagesLayout(
                                  currentSection: 0,
                                  child: HomePage(),
                                )),
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
                            setState(() {
                              TextEditingController termController =
                                  TextEditingController();
                              TextEditingController definitionController =
                                  TextEditingController();

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
                                      child: Icon(Icons.delete,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                key: UniqueKey(),
                                child: WordEditorCard(
                                  termController: termController,
                                  definitionController: definitionController,
                                ),
                              ));

                              wordsControllers
                                  .add([termController, definitionController]);
                            });
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
