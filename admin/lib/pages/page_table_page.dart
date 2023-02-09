import 'package:admin/blocs/page_bloc.dart';
import 'package:admin/blocs/page_state.dart';
import 'package:admin/repositories/page_repository.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';

class PageTablePage extends StatefulWidget {
  final PageRepository api;
  const PageTablePage({super.key, required this.api});

  @override
  State<PageTablePage> createState() => _PageTablePageState();
}

class _PageTablePageState extends State<PageTablePage> {
  late final PageSearchBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = PageSearchBloc(widget.api);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<PageSearchState>(
        stream: bloc.state,
        initialData: PageSearchInitial(),
        builder:
            (BuildContext context, AsyncSnapshot<PageSearchState> snapshot) {
          final state = snapshot.requireData;
          return _buildChild(state);
        });
  }

  Widget _buildChild(PageSearchState state) {
    if (state is PageSearchInitial) {
      return const PageSearchInitWidget();
    } else if (state is PageSearchEmpty) {
      return const PageSearchEmptyWidget();
    } else if (state is PageSearchLoading) {
      return const PageSearchLoadingWidget();
    } else if (state is PageSearchError) {
      return const PageSearchErrorWidget();
    } else if (state is PageSearchPopulated) {
      return PageSearchResultWidget(
        pageSearchResult: state.result,
        onPageChanged: (int? value) {
          if (value != null) {
            bloc.onPageSizeChanged.add(value);
          }
        },
      );
    }

    throw Exception('${state.runtimeType} is not supported');
  }
}

class PageSearchResultWidget extends StatelessWidget {
  const PageSearchResultWidget(
      {super.key, required this.pageSearchResult, this.onPageChanged});

  final PageWrapper<PageSearchResultItem> pageSearchResult;
  final void Function(int?)? onPageChanged;

  @override
  Widget build(BuildContext context) {
    return CustomPaginatedTable(
      rowPerPage: pageSearchResult.size,
      dataColumns: const [
        DataColumn(label: Text('Title')),
        DataColumn(label: Text('Platform')),
        DataColumn(label: Text('Type')),
        DataColumn(label: Text('Status')),
        DataColumn(label: Text('Start Date')),
        DataColumn(label: Text('End Date')),
      ],
      showActions: false,
      actions: const [],
      sortColumnIndex: 0,
      sortColumnAsc: true,
      onPageChanged: onPageChanged,
      dataTableSource: PageSearchResultDataSource(pageSearchResult),
    );
  }
}

class CustomPaginatedTableHeader extends StatefulWidget {
  const CustomPaginatedTableHeader({super.key});

  @override
  State<CustomPaginatedTableHeader> createState() =>
      _CustomPaginatedTableHeaderState();
}

class _CustomPaginatedTableHeaderState
    extends State<CustomPaginatedTableHeader> {
  PageQuery _query = PageQuery();

  @override
  Widget build(BuildContext context) {
    final titleField = TextFormField(
      decoration: const InputDecoration(
        hintText: '标题',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        setState(() {
          _query = _query.copyWith(title: value);
        });
      },
    ).expanded();

    final platformDropdown = DropdownButtonFormField<Platform>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: '平台',
      ),
      items: [
        DropdownMenuItem(
          value: Platform.app,
          child: Text(Platform.app.value),
        ),
        DropdownMenuItem(
          value: Platform.web,
          child: Text(Platform.web.value),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _query = _query.copyWith(platform: value);
        });
      },
    ).expanded();

    final typeDropdown = DropdownButtonFormField<PageType>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: '类型',
      ),
      items: [
        DropdownMenuItem(
          value: PageType.home,
          child: Text(PageType.home.value),
        ),
        DropdownMenuItem(
          value: PageType.category,
          child: Text(PageType.category.value),
        ),
        DropdownMenuItem(
          value: PageType.about,
          child: Text(PageType.about.value),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _query = _query.copyWith(pageType: value);
        });
      },
    ).expanded();

    final statusDropdown = DropdownButtonFormField<PageStatus>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        hintText: '状态',
      ),
      items: [
        DropdownMenuItem(
          value: PageStatus.draft,
          child: Text(PageStatus.draft.value),
        ),
        DropdownMenuItem(
          value: PageStatus.published,
          child: Text(PageStatus.published.value),
        ),
        DropdownMenuItem(
          value: PageStatus.archived,
          child: Text(PageStatus.archived.value),
        ),
      ],
      onChanged: (value) {
        setState(() {
          _query = _query.copyWith(status: value);
        });
      },
    ).expanded();

    final startTimeFromField = TextFormField(
      enabled: false,
      decoration: const InputDecoration(
        hintText: '起始日期从',
        border: OutlineInputBorder(),
      ),
    ).inkWell(onTap: () async {
      final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (date != null) {
        setState(() {
          _query = _query.copyWith(startDateFrom: date.formattedYYYYMMDD);
        });
      }
    }).expanded();

    final startTimeToField = TextFormField(
      enabled: false,
      decoration: const InputDecoration(
        hintText: '起始日期至',
        border: OutlineInputBorder(),
      ),
    ).inkWell(onTap: () async {
      final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (date != null) {
        setState(() {
          _query = _query.copyWith(startDateTo: date.formattedYYYYMMDD);
        });
      }
    }).expanded();

    final endTimeFromField = TextFormField(
      enabled: false,
      decoration: const InputDecoration(
        hintText: '结束日期从',
        border: OutlineInputBorder(),
      ),
    ).inkWell(onTap: () async {
      final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (date != null) {
        setState(() {
          _query = _query.copyWith(endDateFrom: date.formattedYYYYMMDD);
        });
      }
    }).expanded();

    final endTimeToField = TextFormField(
      enabled: false,
      decoration: const InputDecoration(
        hintText: '结束日期至',
        border: OutlineInputBorder(),
      ),
    ).inkWell(onTap: () async {
      final date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (date != null) {
        setState(() {
          _query = _query.copyWith(endDateTo: date.formattedYYYYMMDD);
        });
      }
    }).expanded();

    final clearButton = TextButton(
      onPressed: () {
        setState(() {
          _query = PageQuery();
        });
      },
      child: const Text('清除'),
    ).constrained(height: 50).expanded();

    final searchButton = ElevatedButton(
      onPressed: () {
        setState(() {
          _query = _query.copyWith(page: 0);
          debugPrint(_query.toJsonString());
        });
      },
      child: const Text('搜索'),
    ).constrained(height: 50).expanded();

    final filterRow = [
      titleField,
      const SizedBox(width: 8),
      platformDropdown,
      const SizedBox(width: 8),
      typeDropdown,
      const SizedBox(width: 8),
      statusDropdown,
      const SizedBox(width: 8),
      startTimeFromField,
      const SizedBox(width: 8),
      startTimeToField,
      const SizedBox(width: 8),
      endTimeFromField,
      const SizedBox(width: 8),
      endTimeToField,
      const SizedBox(width: 8),
      clearButton,
      const SizedBox(width: 8),
      searchButton,
    ].toRow();
    const pageHeader = Text('Pages');
    final headersColumn = [
      pageHeader,
      const Divider(),
      filterRow,
    ].toColumn();
    return headersColumn;
  }
}

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
        DataCell(Text(item.pageType.value)),
        DataCell(Text(item.status.value)),
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

class PageSearchInitWidget extends StatelessWidget {
  const PageSearchInitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PageSearchEmptyWidget extends StatelessWidget {
  const PageSearchEmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomPaginatedTableHeader();
  }
}

class PageSearchLoadingWidget extends StatelessWidget {
  const PageSearchLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PageSearchErrorWidget extends StatelessWidget {
  const PageSearchErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

extension MapWithIndex<T> on List<T> {
  List<R> mapWithIndex<R>(R Function(T, int i) callback) {
    List<R> result = [];

    for (int i = 0; i < length; i++) {
      R item = callback(this[i], i);
      result.add(item);
    }
    return result;
  }

  Iterable<R> mapWithIndexIterable<R>(R Function(T, int i) callback) {
    return asMap().keys.toList().map((index) => callback(this[index], index));
  }
}
