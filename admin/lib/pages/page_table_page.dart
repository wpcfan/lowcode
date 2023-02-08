import 'package:admin/blocs/page_bloc.dart';
import 'package:admin/blocs/page_state.dart';
import 'package:admin/repositories/page_repository.dart';
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
    return SingleChildScrollView(
      child: Theme(
        data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            cardColor: Theme.of(context).cardColor,
            textTheme: Typography.whiteCupertino),
        child: PaginatedDataTable(
          header: const Text('Pages'),
          rowsPerPage: pageSearchResult.size,
          showFirstLastButtons: true,
          onRowsPerPageChanged: onPageChanged,
          columns: const [
            DataColumn(label: Text('Title')),
            DataColumn(label: Text('Platform')),
            DataColumn(label: Text('Type')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Start Date')),
            DataColumn(label: Text('End Date')),
          ],
          source: PageSearchResultDataSource(pageSearchResult),
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
    return Container();
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
