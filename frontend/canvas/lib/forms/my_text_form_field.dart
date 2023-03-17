import 'package:flutter/material.dart';

import 'validators.dart';

class MyTextFormField extends StatelessWidget {
  final TextInputType? keyboardType;
  final String? initialValue;
  final String? label;
  final String? hint;
  final List<Validator> validators;
  final void Function(String?)? onChanged;
  const MyTextFormField({
    super.key,
    this.keyboardType = TextInputType.text,
    this.initialValue,
    this.label,
    this.hint,
    required this.validators,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: TextEditingController(text: initialValue),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
      ),
      keyboardType: keyboardType,
      validator: (value) {
        for (var validator in validators) {
          var error = validator(value);
          if (error != null) {
            return error;
          }
        }
        return null;
      },
      onSaved: onChanged,
    );
  }
}
