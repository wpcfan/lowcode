import 'package:common/common.dart';
import 'package:flutter/material.dart';

/// 一个带有过滤功能的文本控件，点击后会弹出一个对话框，输入关键字后点击确定，会调用 [onFilter] 方法
class TextFilterWidget extends StatelessWidget {
  const TextFilterWidget({
    super.key,
    required this.label,
    required this.onFilter,
    required this.popupTitle,
    required this.popupHintText,
    this.iconData = Icons.filter_alt,
    this.altIconData = Icons.filter_alt_off,
    this.clearIconData = Icons.clear,
    this.cancelText = '清除',
    this.confirmText = '确定',
    this.value,
  });

  final String label;
  final IconData iconData;
  final IconData altIconData;
  final IconData clearIconData;
  final String popupTitle;
  final String popupHintText;
  final String cancelText;
  final String confirmText;
  final String? value;
  final void Function(String?) onFilter;

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController(text: value);
    final icon = PopupMenuButton(
        itemBuilder: (context) {
          return [
            PopupMenuItem(
              child: Text(label),
            ),
            PopupMenuItem(
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: popupHintText,
                  border: InputBorder.none,
                ),
                onFieldSubmitted: (value) {
                  onFilter(value);
                  Navigator.of(context).pop();
                },
              ),
            ),
            PopupMenuItem(
              child: Row(
                children: [
                  TextButton(
                    onPressed: () {
                      controller.text = '';
                      onFilter(controller.text);
                      Navigator.of(context).pop();
                    },
                    child: Text(cancelText),
                  ),
                  TextButton(
                    onPressed: () {
                      onFilter(controller.text);
                      Navigator.of(context).pop();
                    },
                    child: Text(confirmText),
                  ),
                ],
              ),
            ),
          ];
        },
        child: Icon(value == null || value!.isEmpty
            ? Icons.filter_alt
            : Icons.filter_alt_off));
    final clear = IconButton(
      icon: Icon(clearIconData),
      onPressed: () {
        controller.text = '';
        onFilter(controller.text);
      },
    );
    final arr = value == null || value!.isEmpty
        ? [Text(label), icon]
        : [Text(label), icon, clear];
    return arr.toRow();
  }
}
