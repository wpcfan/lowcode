import 'package:common/common.dart';
import 'package:flutter/material.dart';

class SelectionItem<T> {
  const SelectionItem({required this.value, required this.label});

  final T? value;
  final String label;
}

class SelectionFilterWidget<T> extends StatelessWidget {
  const SelectionFilterWidget({
    super.key,
    required this.label,
    required this.onFilter,
    this.iconData = Icons.filter_alt,
    this.altIconData = Icons.filter_alt_off,
    this.clearIconData = Icons.clear,
    this.items = const [],
    this.value,
    this.cancelText = '清除',
  });

  final String label;
  final IconData iconData;
  final IconData altIconData;
  final IconData clearIconData;
  final List<SelectionItem<T>> items;
  final T? value;
  final void Function(T?) onFilter;
  final String cancelText;

  @override
  Widget build(BuildContext context) {
    final icon = PopupMenuButton<T?>(
      initialValue: value,
      itemBuilder: (context) {
        return [
          ...items.map((item) {
            return PopupMenuItem(
              value: item.value,
              child: Text(item.label),
            );
          }),
          PopupMenuItem(
            onTap: () => onFilter(null),
            enabled: value != null,
            child: Text(
              cancelText,
              style: TextStyle(
                color: value == null ? Colors.grey : Colors.white,
              ),
            ),
          ),
        ];
      },
      onSelected: onFilter,
      child: Icon(value == null ? Icons.filter_alt : Icons.filter_alt_off),
    );

    final clear = IconButton(
      icon: Icon(clearIconData),
      onPressed: () => onFilter(null),
    );

    final arr =
        value == null ? [Text(label), icon] : [Text(label), icon, clear];
    return arr.toRow();
  }
}
