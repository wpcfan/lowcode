import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

class ColorPickerDialog extends StatefulWidget {
  const ColorPickerDialog({super.key});

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  Color _selectedColor = Colors.blue;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('选择颜色'),
      content: SingleChildScrollView(
        child: ColorPicker(
          width: 44,
          height: 44,
          borderRadius: 22,
          color: _selectedColor,
          onColorChanged: (color) {
            setState(() {
              _selectedColor = color;
            });
          },
          heading: Text(
            '选择色系',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          subheading: Text(
            '选择颜色深浅',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(_selectedColor);
          },
          child: const Text('确定'),
        ),
      ],
    );
  }
}
