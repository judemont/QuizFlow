import 'package:flutter/material.dart';
import 'package:quizflow/models/answer.dart';
import 'package:quizflow/widgets/InputChip/flutter_chips.dart';
import 'package:quizflow/widgets/InputChip/input_chips_controller.dart';

///
/// [FlutterInputChips] is a Flutter widget that builds the input field with input chips options
///
class FlutterInputChips extends StatefulWidget {
  final List<Answer> initialValue;

  /// returns a list of string on inout field submitted
  final ValueChanged<Set<String?>> onChanged;

  /// number of maximum chips
  final int? maxChips;

  /// callback when the maximum number of chips is reached
  final VoidCallback? onMaxChipsReached;

  /// enables the input field and chip delete ability
  final bool enabled;

  /// inout field action
  final TextInputAction inputAction;

  /// keyboard appearance
  final Brightness keyboardAppearance;

  /// autofocus the inout field
  final bool autofocus;

  /// text capitalization type for the input field keyboard
  final TextCapitalization textCapitalization;

  /// text input decoration
  final InputDecoration inputDecoration;

  /// text overflow behavior
  final TextOverflow textOverflow;

  /// keyboard input type
  final TextInputType inputType;

  /// parent container padding
  final EdgeInsets padding;
  // padding container decoration
  final BoxDecoration? decoration;

  /// spacing between chips
  final double chipSpacing;

  /// style for chip text/label
  final TextStyle? chipTextStyle;

  /// background color of the chip
  final Color? chipBackgroundColor;

  /// custom delete icon
  final Widget? chipDeleteIcon;

  /// if true, displays a delete icon in the chip
  final bool chipCanDelete;

  /// Color for delete icon in the chip
  final Color? chipDeleteIconColor;

  /// controller for the input field
  final InputChipsController? controller;

  final String? automaticChipValue;

  const FlutterInputChips({
    super.key,
    required this.onChanged,
    this.initialValue = const [],
    this.enabled = true,
    this.inputAction = TextInputAction.done,
    this.keyboardAppearance = Brightness.light,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.inputDecoration = const InputDecoration(),
    this.textOverflow = TextOverflow.clip,
    this.inputType = TextInputType.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    this.chipCanDelete = true,
    this.chipSpacing = 5,
    this.automaticChipValue,
    this.maxChips,
    this.decoration,
    this.chipTextStyle,
    this.chipBackgroundColor,
    this.chipDeleteIcon,
    this.chipDeleteIconColor,
    this.controller,
    this.onMaxChipsReached,
  }) : assert(maxChips == null || initialValue.length <= maxChips);

  @override
  State<FlutterInputChips> createState() => FlutterInputChipsState();
}

class FlutterInputChipsState extends State<FlutterInputChips> {
  /// controller for the input field
  late final InputChipsController controller;

  bool moreThanOneChip = true;

  /// checks whether the chips has reached the maximum number of chips allowed
  bool get _hasReachedMaxChips =>
      widget.maxChips != null && controller.chips.length >= widget.maxChips!;

  @override
  void initState() {
    controller = widget.controller ?? InputChipsController(widget.initialValue);
    moreThanOneChip = controller.chips.length > 1;
    super.initState();
  }

  /// adds the chip to the list, clear the text field and calls [widget.onChanged]
  void addChip(String value) {
    if (value.isEmpty || _hasReachedMaxChips) {
      controller.textController.clear();
      widget.onMaxChipsReached?.call();
      return;
    }
    setState(() {
      controller.addChip(value.trim());
    });
    controller.textController.clear();
    moreThanOneChip = true;
    widget.onChanged(controller.chips);
  }

  void deleteChip(String? value) {
    if (widget.enabled) {
      setState(() => controller.removeChip(value));
      if (controller.chips.length == 1) {
        controller.updateText(controller.chips.first);
        moreThanOneChip = false;
      }
      if (value! == controller.text) {
        controller.textController.clear();
      }
      widget.onChanged(controller.chips);
    }
  }

  /// sets the selected chip's value to the text field
  void onChipSelected(String? value) {
    controller.updateText(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: widget.padding,
      decoration: widget.decoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          moreThanOneChip
              ? FlutterChips(
                  key: ValueKey(controller.chips.length),
                  controller: controller,
                  onChanged: widget.onChanged,
                  enabled: widget.enabled,
                  chipCanDelete: widget.chipCanDelete,
                  chipSpacing: widget.chipSpacing,
                  textOverflow: widget.textOverflow,
                  chipDeleteIcon: widget.chipDeleteIcon,
                  chipBackgroundColor: widget.chipBackgroundColor,
                  chipDeleteIconColor: widget.chipDeleteIconColor,
                  chipTextStyle: widget.chipTextStyle,
                  onChipSelected: onChipSelected,
                  onChipDelete: deleteChip,
                )
              : const SizedBox.shrink(),
          TextField(
            controller: controller.textController,
            onSubmitted: (value) {
              addChip(value);
            },
            onChanged: (value) {
              if (widget.automaticChipValue != null &&
                  value.contains(widget.automaticChipValue!)) {
                addChip(value.replaceAll(widget.automaticChipValue!, ""));
              }
            },
            onEditingComplete: () {}, // this prevents keyboard from closing
            decoration: widget.inputDecoration,
            textInputAction: widget.inputAction,
            keyboardType: widget.inputType,
            keyboardAppearance: widget.keyboardAppearance,
            textCapitalization: widget.textCapitalization,
            enabled: widget.enabled,
            autofocus: widget.autofocus,
          ),
        ],
      ),
    );
  }
}
