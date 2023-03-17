import 'package:common/common.dart';
import 'package:flutter/material.dart';

class FormModel {
  final String? title;
  final List<FormItemModel> formItems;
  final double spacing;
  final TextStyle titleStyle;

  FormModel({
    this.title,
    required this.formItems,
    this.spacing = 8.0,
    this.titleStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 18.0,
    ),
  });

  Widget build(BuildContext context) {
    return [
      if (title != null)
        Text(
          title!,
          style: titleStyle,
        ).padding(bottom: spacing),
      formItems.map((formItem) => formItem.build()).toList().toColumn(),
    ].toColumn();
  }
}

class FormItemModel {
  final Widget formField;
  final Widget? label;

  FormItemModel({
    required this.formField,
    this.label,
  });

  Widget build() {
    return [
      if (label != null) label!,
      formField,
    ].toColumn();
  }
}

abstract class BaseFormFieldModel {
  final String? label;
  final String? hint;
  final List<String? Function(String?)> validators;
  final void Function(String?)? onChanged;

  BaseFormFieldModel({
    this.label,
    this.hint,
    this.validators = const [],
    this.onChanged,
  });

  Widget build(BuildContext context);
}

class FormTextInput extends BaseFormFieldModel {
  final IconData? icon;
  final TextInputType? keyboardType;

  FormTextInput({
    String? label,
    String? hint,
    List<String? Function(String?)> validators = const [],
    void Function(String?)? onChanged,
    this.icon,
    this.keyboardType = TextInputType.text,
  }) : super(
          label: label,
          hint: hint,
          validators: validators,
          onChanged: onChanged,
        );

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon != null ? Icon(icon) : null,
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
      onChanged: onChanged,
    );
  }
}
