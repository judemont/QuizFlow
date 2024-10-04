import 'package:flutter/material.dart';

class VocCard extends StatelessWidget {
  final String title;
  final String? description;
  final void Function()? onTap;
  const VocCard({super.key, required this.title, this.description, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        borderRadius: BorderRadius.circular(10.0),
        splashColor: Theme.of(context).colorScheme.secondary,
        onTap: onTap,
        child: Card(
          semanticContainer: true,
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text(
                  description ?? "",
                ),
              ],
            ),
          ),
        ));
  }
}
