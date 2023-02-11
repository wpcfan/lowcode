import 'package:admin/blocs/page_bloc.dart';
import 'package:admin/blocs/page_state.dart';
import 'package:admin/repositories/page_repository.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'page_search_error_widget.dart';
import 'page_search_init_widget.dart';
import 'page_search_loading_widget.dart';
import 'page_search_result_widget.dart';

class PageTableView extends StatefulWidget {
  final PageRepository api;
  const PageTableView({super.key, required this.api});

  @override
  State<PageTableView> createState() => _PageTableViewState();
}

class _PageTableViewState extends State<PageTableView> {
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
    } else if (state is PageSearchLoading) {
      return const PageSearchLoadingWidget();
    } else if (state is PageSearchError) {
      return const PageSearchErrorWidget();
    } else if (state is PageSearchPopulated) {
      return PageSearchResultWidget(
        query: state.query,
        pageSearchResult: state.result,
        onPageChanged: (int? value) {
          if (value != null) {
            bloc.onPageSizeChanged.add(value);
          }
        },
        onTitleChanged: (String? value) {
          bloc.onTitleChanged.add(value);
        },
        onPlatformChanged: (Platform? value) {
          bloc.onPlatformChanged.add(value);
        },
        onStatusChanged: (PageStatus? value) {
          bloc.onPageStatusChanged.add(value);
        },
        onPageTypeChanged: (PageType? value) {
          bloc.onPageTypeChanged.add(value);
        },
        onStartDateChanged: (DateTimeRange? value) {
          bloc.onStartDateFromChanged.add(value?.start);
          bloc.onStartDateToChanged.add(value?.end);
        },
        onEndDateChanged: (DateTimeRange? value) {
          bloc.onEndDateFromChanged.add(value?.start);
          bloc.onEndDateToChanged.add(value?.end);
        },
        onClearAll: () {
          bloc.onClearAll.add(const PageQuery());
        },
      );
    }

    throw Exception('${state.runtimeType} is not supported');
  }
}
