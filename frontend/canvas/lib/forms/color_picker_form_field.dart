import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class ColorPickerFormField extends StatefulWidget {
  final Color initialColor;
  final void Function(Color)? onChanged;

  const ColorPickerFormField({
    super.key,
    required this.initialColor,
    this.onChanged,
  });

  @override
  State<ColorPickerFormField> createState() => _ColorPickerFormFieldState();
}

class _ColorPickerFormFieldState extends State<ColorPickerFormField> {
  late Color _selectedColor;

  @override
  void initState() {
    super.initState();
    _selectedColor = widget.initialColor;
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              color: _selectedColor,
              onColorChanged: (Color color) {
                setState(() => _selectedColor = color);
                widget.onChanged?.call(color);
              },
              pickersEnabled: const <ColorPickerType, bool>{
                ColorPickerType.both: false,
                ColorPickerType.primary: true,
                ColorPickerType.accent: true,
                ColorPickerType.bw: true,
                ColorPickerType.custom: true,
                ColorPickerType.wheel: true,
              },
              enableShadesSelection: false,
              enableOpacity: false,
              showColorCode: true,
              colorCodeHasColor: true,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Got it'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openColorPicker,
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _selectedColor,
              border: Border.all(width: 1, color: Colors.black),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '#${_selectedColor.value.toRadixString(16).toUpperCase()}',
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}
