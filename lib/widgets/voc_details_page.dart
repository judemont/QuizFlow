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
    return const Scaffold();
  }
}
