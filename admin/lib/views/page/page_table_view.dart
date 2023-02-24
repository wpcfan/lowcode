import 'package:admin/blocs/layout_bloc.dart';
import 'package:admin/blocs/layout_event.dart';
import 'package:admin/blocs/layout_state.dart';
import 'package:admin/views/page/page_update_dialog.dart';
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
        final bloc = context.read<LayoutBloc>();
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
                bloc.add(LayoutEventPageChanged(value));
              },
              onTitleChanged: (String? value) {
                bloc.add(LayoutEventTitleChanged(value));
              },
              onPlatformChanged: (Platform? value) {
                bloc.add(LayoutEventPlatformChanged(value));
              },
              onStatusChanged: (PageStatus? value) {
                bloc.add(LayoutEventPageStatusChanged(value));
              },
              onPageTypeChanged: (PageType? value) {
                bloc.add(LayoutEventPageTypeChanged(value));
              },
              onStartDateChanged: (DateTimeRange? value) {
                bloc.add(LayoutEventStartDateChanged(value?.start, value?.end));
              },
              onEndDateChanged: (DateTimeRange? value) {
                bloc.add(LayoutEventEndDateChanged(value?.start, value?.end));
              },
              onClearAll: () {
                bloc.add(LayoutEventClearAll());
              },
              onUpdate: (PageLayout layout) async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return PageUpdateDialog(
                        bloc: bloc,
                        layout: layout,
                      );
                    });
              },
              onDelete: (int id) {
                bloc.add(LayoutEventDelete(id));
              },
              onPublish: (int id) async {
                final now = DateTime.now();
                final result = await showDateRangePicker(
                  context: context,
                  firstDate: now,
                  lastDate: now.add(const Duration(days: 30)),
                  builder: (context, child) =>
                      BlocListener<LayoutBloc, LayoutState>(
                    bloc: bloc,
                    listener: (context, state) {
                      if (state.loading) {
                        return;
                      }
                      if (state.error != null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(state.error ?? '未知错误'),
                          ),
                        );
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                    child: child,
                  ),
                );
                if (result != null) {
                  bloc.add(LayoutEventPublish(id, result.start, result.end));
                }
              },
              onDraft: (int id) async {
                final result = await showDialog(
                    context: context,
                    builder: (context) {
                      return BlocListener<LayoutBloc, LayoutState>(
                        bloc: bloc,
                        listener: (context, state) {
                          if (state.loading) {
                            return;
                          }
                          if (state.error != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error ?? '未知错误'),
                              ),
                            );
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                        child: AlertDialog(
                          title: const Text('下架'),
                          content: const Text('确定下架吗？'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: const Text('取消'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: const Text('确定'),
                            ),
                          ],
                        ),
                      );
                    });
                if (result) {
                  bloc.add(LayoutEventDraft(id));
                }
              },
            );
        }
      },
    );
  }
}
