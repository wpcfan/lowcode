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
      /// 需要注意，如果设置 initialValue，那么这个 widget 在切换的时候不会更新
      /// 因为在 widget 树中，这个 widget 的位置没有变化，所以不会重新 build
      /// 所以需要使用 controller 来控制
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
