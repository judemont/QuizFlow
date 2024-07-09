import 'package:flutter/material.dart';
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
  List<Widget> wordsCards = [const WordEditorCard()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Voc"),
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
                  SizedBox(height: 40),
                  Column(
                    children: wordsCards,
                  )
                ],
              ),
            )),
      ),
    );
  }
}
