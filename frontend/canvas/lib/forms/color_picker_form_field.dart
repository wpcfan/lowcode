import 'package:common/common.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';

/// 自定义表单字段，用于选择颜色
/// Flutter 中的表单字段是一个抽象类，它的子类必须实现 [FormField] 类。
/// 我们在这里实现了一个自定义的表单字段，用于选择颜色。
/// 该表单字段的初始值是一个 [Color] 对象，它的值是用户选择的颜色。
/// 该表单字段的验证器是一个 [FormFieldValidator<Color>] 函数，它的参数是用户选择的颜色。
/// 该表单字段的保存器是一个 [FormFieldSetter<Color>] 函数，它的参数是用户选择的颜色。
/// 该表单字段的构建器是一个 [FormFieldBuilder<Color>] 函数，它的参数是一个 [FormFieldState<Color>] 对象。
class ColorPickerFormField extends FormField<Color> {
  final String label;

  /// Stateful widgets 的初始值变化时是不会重绘的，所以我们需要一个 [ValueNotifier] 来通知表单字段重绘。
  /// 这里我们使用了一个 [ValueNotifier]，它的值是用户选择的颜色或初始值。
  /// 值变化后，我们通过 [ValueListenableBuilder] 来重绘表单字段。
  final ValueNotifier<Color> colorNotifier;
  ColorPickerFormField({
    super.key,
    required this.label,
    required this.colorNotifier,
    required FormFieldSetter<Color> onSaved,
    required FormFieldValidator<Color> validator,
  }) : super(
          initialValue: colorNotifier.value,
          onSaved: onSaved,
          validator: validator,
          builder: (FormFieldState<Color> state) {
            return ValueListenableBuilder(
              valueListenable: colorNotifier,
              builder: (BuildContext context, Color value, Widget? child) {
                final item = [
                  Text(label),
                  const SizedBox(width: 8),
                  const SizedBox(
                    width: 50,
                    height: 50,
                  ).decorated(
                    color: value,
                    border: Border.all(
                      color: state.hasError ? Colors.red : Colors.grey,
                      width: 1,
                    ),
                  ),
                ].toRow().gestures(onTap: () async {
                  Color? newColor = await showDialog<Color>(
                    context: state.context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: ColorPicker(
                          color: state.value!,
                          onColorChanged: (Color color) {
                            Navigator.of(context).pop(color);
                          },
                        ),
                      );
                    },
                  );

                  if (newColor != null) {
                    state.didChange(newColor);
                    colorNotifier.value = newColor;
                  }
                });
                return item;
              },
            );
          },
        );
}
