import 'package:flutter/material.dart';
import 'package:voclearner/models/voc.dart';

class VocDetailsPage extends StatefulWidget {
  final Voc voc;
  const VocDetailsPage({super.key, required this.voc});

  @override
  State<VocDetailsPage> createState() => _VocDetailsPageState();
}

class _VocDetailsPageState extends State<VocDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("VocLearner"),
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 10, right: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Text(
                  widget.voc.title ?? "",
                  style: const TextStyle(fontSize: 25),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(widget.voc.description ?? ""),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text("Write"),
                  icon: const Icon(Icons.edit_note),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text("Flashcards"),
                  icon: const Icon(Icons.edit_note),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
