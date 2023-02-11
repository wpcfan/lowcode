import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_repository/page_repository.dart';

class PageSearchResultDataSource extends DataTableSource {
  PageSearchResultDataSource(this.pageSearchResult);

  final PageWrapper<PageSearchResultItem> pageSearchResult;

  @override
  DataRow getRow(int index) {
    final item = pageSearchResult.items[index];

    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(item.title)),
        DataCell(Text(item.platform.value)),
        DataCell(Text(item.status.value)),
        DataCell(Text(item.pageType.value)),
        DataCell(Text(item.startTime?.formatted ?? '')),
        DataCell(Text(item.endTime?.formatted ?? '')),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => pageSearchResult.items.length;

  @override
  int get selectedRowCount => 0;
}
