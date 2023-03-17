import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

Color _selectedColor = Colors.white;

FormField<Color> colorPickerFormField(BuildContext context) {
  return FormField<Color>(
    initialValue: _selectedColor,
    builder: (FormFieldState<Color> state) {
      return InkWell(
        onTap: () async {
          final Color color = await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Select a color'),
                content: SingleChildScrollView(
                  child: ColorPicker(
                    color: state.value!,
                    onColorChanged: (Color color) => state.didChange(color),
                    pickersEnabled: const <ColorPickerType, bool>{
                      ColorPickerType.accent: false,
                      ColorPickerType.bw: false,
                      ColorPickerType.wheel: true,
                      ColorPickerType.primary: true,
                    },
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, _selectedColor),
                    child: const Text('CANCEL'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, state.value),
                    child: const Text('OK'),
                  ),
                ],
              );
            },
          );
          _selectedColor = color;
          state.didChange(color);
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: 'Color',
            border: const OutlineInputBorder(),
            errorText: state.hasError ? state.errorText : null,
          ),
          child: SizedBox(
            height: 50,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: state.value,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: state.value!,
                        width: 2,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
