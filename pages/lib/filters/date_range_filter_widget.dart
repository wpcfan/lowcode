import 'package:common/common.dart';
import 'package:flutter/material.dart';

class DateRangeFilterWidget extends StatelessWidget {
  const DateRangeFilterWidget({
    super.key,
    required this.label,
    required this.onFilter,
    required this.helpText,
    this.iconData = Icons.filter_alt,
    this.altIconData = Icons.filter_alt_off,
    this.clearIconData = Icons.clear,
    this.cancelText = '取消',
    this.confirmText = '确定',
    this.saveText = '保存',
    this.errorFormatText,
    this.errorInvalidText,
    this.firstDateBeforeTodayInDays = 30,
    this.lastDateAfterTodayInDays = 365 * 100,
    this.value,
    this.fieldStartHintText = '开始日期',
    this.fieldEndHintText = '结束日期',
    this.fieldStartLabelText = '开始日期',
    this.fieldEndLabelText = '结束日期',
  });

  final String label;
  final IconData iconData;
  final IconData altIconData;
  final IconData clearIconData;
  final String helpText;
  final String fieldStartHintText;
  final String fieldEndHintText;
  final String fieldStartLabelText;
  final String fieldEndLabelText;
  final String cancelText;
  final String confirmText;
  final String saveText;
  final String? errorFormatText;
  final String? errorInvalidText;
  final int firstDateBeforeTodayInDays;
  final int lastDateAfterTodayInDays;
  final void Function(DateTimeRange?) onFilter;
  final DateTimeRange? value;

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final firstDate = now.subtract(Duration(days: firstDateBeforeTodayInDays));
    final lastDate = firstDate.add(Duration(days: lastDateAfterTodayInDays));
    final icon = IconButton(
      onPressed: () async {
        final result = await showDateRangePicker(
          context: context,
          firstDate: firstDate,
          lastDate: lastDate,
          helpText: helpText,
          cancelText: cancelText,
          confirmText: confirmText,
          saveText: saveText,
          errorFormatText: errorFormatText,
          errorInvalidText: errorInvalidText,
          fieldStartHintText: fieldStartHintText,
          fieldEndHintText: fieldEndHintText,
          fieldStartLabelText: fieldStartLabelText,
          fieldEndLabelText: fieldEndLabelText,
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDateRange: DateTimeRange(
            start: value?.start ?? now,
            end: value?.end ?? now,
          ),
        );
        onFilter(result);
      },
      icon: Icon(value == null ? iconData : altIconData),
    );
    final clear = IconButton(
      onPressed: () {
        onFilter(null);
      },
      icon: Icon(clearIconData),
    );
    final arr =
        value == null ? [Text(label), icon] : [Text(label), icon, clear];
    return arr.toRow();
  }
}
