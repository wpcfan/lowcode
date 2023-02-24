import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class PageSearchResultDataSource extends DataTableSource {
  PageSearchResultDataSource(
      {required this.items, required this.onUpdate, required this.onDelete});

  final List<PageLayout> items;
  final void Function(int) onUpdate;
  final void Function(int) onDelete;

  @override
  DataRow getRow(int index) {
    final item = items[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(item.title)),
        DataCell(Text(item.platform.value)),
        DataCell(Text(item.status.value)),
        DataCell(Text(item.pageType.value)),
        DataCell(Text(item.startTime?.formatted ?? '')),
        DataCell(Text(item.endTime?.formatted ?? '')),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  onUpdate.call(index);
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  onDelete.call(index);
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}
