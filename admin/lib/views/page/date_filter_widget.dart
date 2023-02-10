import 'package:flutter/material.dart';

class DateFilterRange {
  DateFilterRange({
    this.start,
    this.end,
  });

  final DateTime? start;
  final DateTime? end;
}

class DateFilterWidget extends StatefulWidget {
  const DateFilterWidget({
    super.key,
    required this.label,
    required this.onFilter,
    required this.popupTitle,
    this.startDateLabel = '开始日期',
    this.endDateLabel = '结束日期',
  });

  final String label;
  final void Function(DateFilterRange?) onFilter;
  final String popupTitle;
  final String startDateLabel;
  final String endDateLabel;

  @override
  State<DateFilterWidget> createState() => _DateFilterWidgetState();
}

class _DateFilterWidgetState extends State<DateFilterWidget> {
  DateTime? start;
  DateTime? end;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<DateFilterRange>(
      onSelected: widget.onFilter,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: Text(widget.popupTitle),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
            child: Text(widget.startDateLabel),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2015, 8),
                lastDate: DateTime(2101),
              ).then((value) {
                setState(() {
                  start = value;
                });
              });
            }),
        PopupMenuItem(
            child: Text(widget.endDateLabel),
            onTap: () {
              showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2015, 8),
                lastDate: DateTime(2101),
              ).then((value) {
                setState(() {
                  end = value;
                });
              });
            }),
        const PopupMenuDivider(),
        PopupMenuItem(
          child: TextButton(
            onPressed: () {
              widget.onFilter(DateFilterRange(
                start: start,
                end: end,
              ));
            },
            child: const Text('确定'),
          ),
        ),
      ],
      child: Row(
        children: [
          Text(widget.label),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
}
