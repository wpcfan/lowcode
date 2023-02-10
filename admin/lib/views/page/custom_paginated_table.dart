import 'package:flutter/material.dart';

class CustomPaginatedTable extends StatelessWidget {
  const CustomPaginatedTable({
    super.key,
    required this.rowPerPage,
    required this.dataColumns,
    this.header,
    required this.showActions,
    required this.actions,
    required this.sortColumnIndex,
    required this.sortColumnAsc,
    this.onPageChanged,
    required this.dataTableSource,
  });
  final int rowPerPage;
  final List<DataColumn> dataColumns;
  final Widget? header;
  final bool showActions;
  final List<Widget> actions;
  final int sortColumnIndex;
  final bool sortColumnAsc;
  final void Function(int?)? onPageChanged;
  final DataTableSource dataTableSource;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Theme(
        data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            cardColor: Theme.of(context).cardColor,
            textTheme: Typography.whiteCupertino),
        child: PaginatedDataTable(
          header: header,
          rowsPerPage: rowPerPage,
          showFirstLastButtons: true,
          onRowsPerPageChanged: onPageChanged,
          actions: actions,
          sortColumnIndex: sortColumnIndex,
          sortAscending: sortColumnAsc,
          columns: dataColumns,
          source: dataTableSource,
        ),
      ),
    );
  }
}