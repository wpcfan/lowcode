import 'package:admin/blocs/layout_bloc.dart';
import 'package:admin/blocs/layout_event.dart';
import 'package:admin/blocs/layout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import 'page_search_result_widget.dart';

class PageTableView extends StatelessWidget {
  const PageTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LayoutBloc, LayoutState>(
      builder: (context, state) {
        switch (state.status) {
          case FetchStatus.initial:
            return const Center(child: Text('initial'));
          case FetchStatus.loading:
            return const Center(child: CircularProgressIndicator());
          case FetchStatus.error:
            return const Center(child: Text('error'));
          case FetchStatus.populated:
            return PageSearchResultWidget(
              query: state.query,
              items: state.items,
              page: state.page,
              pageSize: state.pageSize,
              total: state.total,
              onPageChanged: (int? value) {
                context.read<LayoutBloc>().add(LayoutEventPageChanged(value));
              },
              onTitleChanged: (String? value) {
                context.read<LayoutBloc>().add(LayoutEventTitleChanged(value));
              },
              onPlatformChanged: (Platform? value) {
                context
                    .read<LayoutBloc>()
                    .add(LayoutEventPlatformChanged(value));
              },
              onStatusChanged: (PageStatus? value) {
                context
                    .read<LayoutBloc>()
                    .add(LayoutEventPageStatusChanged(value));
              },
              onPageTypeChanged: (PageType? value) {
                context
                    .read<LayoutBloc>()
                    .add(LayoutEventPageTypeChanged(value));
              },
              onStartDateChanged: (DateTimeRange? value) {
                context
                    .read<LayoutBloc>()
                    .add(LayoutEventStartDateChanged(value?.start, value?.end));
              },
              onEndDateChanged: (DateTimeRange? value) {
                context
                    .read<LayoutBloc>()
                    .add(LayoutEventEndDateChanged(value?.start, value?.end));
              },
              onClearAll: () {
                context.read<LayoutBloc>().add(LayoutEventClearAll());
              },
            );
        }
      },
    );
  }
}
