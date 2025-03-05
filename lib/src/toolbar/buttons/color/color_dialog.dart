import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' as color_picker
    show ColorPicker, colorToHex;

import '../../../document/style.dart';
import '../../../editor_toolbar_shared/color.dart';
import '../../../l10n/extensions/localizations_ext.dart';

enum _PickerType {
  color,
}

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({
    required this.isBackground,
    required this.onRequestChangeColor,
    required this.isToggledColor,
    required this.selectionStyle,
    super.key,
  });

  final bool isBackground;

  final bool isToggledColor;
  final Function(BuildContext context, Color? color) onRequestChangeColor;
  final Style selectionStyle;

  @override
  State<ColorPickerDialog> createState() => ColorPickerDialogState();
}

class ColorPickerDialogState extends State<ColorPickerDialog> {
  var pickerType = _PickerType.color;
  var selectedColor = Colors.black;

  late final TextEditingController hexController;
  late void Function(void Function()) colorBoxSetState;

  @override
  void initState() {
    super.initState();
    if (widget.isToggledColor) {
      selectedColor = widget.isBackground
          ? hexToColor(widget.selectionStyle.attributes['background']?.value)
          : hexToColor(widget.selectionStyle.attributes['color']?.value);
    }
    hexController =
        TextEditingController(text: color_picker.colorToHex(selectedColor));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(context.loc.selectColor),
      actions: [
        TextButton(
            onPressed: () {
              widget.onRequestChangeColor(context, selectedColor);
              Navigator.of(context).pop();
            },
            child: Text(context.loc.ok)),
      ],
      backgroundColor: Theme.of(context).canvasColor,
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      pickerType = _PickerType.color;
                    });
                  },
                  child: Text(context.loc.color),
                ),
                TextButton(
                  onPressed: () {
                    widget.onRequestChangeColor(context, null);
                    Navigator.of(context).pop();
                  },
                  child: Text(context.loc.clear),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Column(
              children: [
                if (pickerType == _PickerType.color)
                  color_picker.ColorPicker(
                    enableAlpha: false,
                    hexInputBar: false,
                    pickerColor: selectedColor,
                    onColorChanged: (color) {
                      widget.onRequestChangeColor(context, color);
                      hexController.text = colorToHex(color);
                      selectedColor = color;
                    },
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
