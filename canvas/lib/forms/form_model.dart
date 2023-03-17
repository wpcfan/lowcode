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

enum FormItemDisplayMode { column, row }

class FormItemModel {
  final Widget formField;
  final Widget? label;
  final String? placeholder;
  final FormItemDisplayMode displayMode;

  FormItemModel({
    required this.formField,
    this.label,
    this.placeholder,
    this.displayMode = FormItemDisplayMode.row,
  });

  Widget build() {
    if (displayMode == FormItemDisplayMode.column) {
      return [
        if (label != null) label!,
        formField,
      ].toColumn();
    } else {
      return [
        if (label != null) ...[
          label!,
          const SizedBox(width: 8),
        ] else ...[
          const SizedBox(width: 8),
          Text(
            placeholder ?? '',
            style: const TextStyle(
              color: Colors.grey,
            ),
          ).expanded(),
        ],
        formField.expanded(),
      ].toRow();
    }
  }
}
