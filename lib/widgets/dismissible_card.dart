import 'package:flutter/material.dart';

class DismissibleCard extends StatefulWidget {
  final ValueNotifier<List<DismissibleCard>> editorCards;
  final Widget child;
  final VoidCallback onItemRemoved;

  const DismissibleCard({
    super.key,
    required this.editorCards,
    required this.child,
    required this.onItemRemoved,
  });

  @override
  State<DismissibleCard> createState() => _DismissibleCardState();
}

class _DismissibleCardState extends State<DismissibleCard> {
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      onDismissed: (DismissDirection direction) {
        print('Dismissed with direction $direction');

        setState(() {
          widget.editorCards.value = List.from(widget.editorCards.value)
            ..remove(widget);
          widget.onItemRemoved();
        });
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
      child: widget.child,
    );
  }
}
