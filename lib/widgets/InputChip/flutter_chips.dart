import 'package:flutter/material.dart';
import 'package:quizflow/widgets/InputChip/chips_controller.dart';

class FlutterChips extends StatefulWidget {
  final ChipsController controller;

  /// enables the input field and chip delete ability
  final bool enabled;

  /// returns a list of string on inout field submitted
  final ValueChanged<Set<String?>> onChanged;

  /// custom delete icon
  final Widget? chipDeleteIcon;

  /// if true, displays a delete icon in the chip
  final bool chipCanDelete;

  /// spacing between chips
  final double chipSpacing;

  final double maxScrollViewHeight;

  /// text overflow behavior
  final TextOverflow textOverflow;

  /// style for chip text/label
  final TextStyle? chipTextStyle;

  /// background color of the chip
  final Color? chipBackgroundColor;

  /// Color for delete icon in the chip
  final Color? chipDeleteIconColor;

  final ValueChanged<String?>? onChipSelected;

  final ValueChanged<String?>? onChipDelete;

  const FlutterChips({
    super.key,
    this.enabled = true,
    this.chipCanDelete = false,
    this.chipSpacing = 5.0,
    this.maxScrollViewHeight = 75,
    this.textOverflow = TextOverflow.clip,
    required this.controller,
    required this.onChanged,
    this.chipDeleteIcon,
    this.chipBackgroundColor,
    this.chipDeleteIconColor,
    this.chipTextStyle,
    this.onChipSelected,
    this.onChipDelete,
  });
  @override
  State<FlutterChips> createState() => FlutterChipsState();
}

class FlutterChipsState extends State<FlutterChips> {
  /// remove the chip from the list and calls [widget.onChanged]
  void deleteChip(String? value) {
    if (widget.onChipDelete != null) {
      widget.onChipDelete!(value);
      return;
    } else {
      if (widget.enabled) {
        setState(() => widget.controller.removeChip(value));
        widget.onChanged(widget.controller.chips);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.maxScrollViewHeight, // adjust for chip rows
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          spacing: widget.chipSpacing,
          runSpacing: widget.chipSpacing,
          children: widget.controller.chips
              .map(
                (e) => GestureDetector(
                  onTap: () => widget.onChipSelected?.call(e),
                  child: Chip(
                    label: Text(e!, overflow: widget.textOverflow),
                    onDeleted: widget.chipCanDelete
                        ? () => deleteChip(e)
                        : null,
                    deleteIcon: widget.chipDeleteIcon,
                    backgroundColor: widget.chipBackgroundColor,
                    labelStyle: widget.chipTextStyle,
                    deleteIconColor: widget.chipDeleteIconColor,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
