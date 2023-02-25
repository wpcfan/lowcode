import 'package:admin/blocs/layout_bloc.dart';
import 'package:admin/blocs/layout_event.dart';
import 'package:admin/blocs/layout_state.dart';
import 'package:admin/views/page/create_or_update_page_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';

import 'page_search_result_widget.dart';

class PageTableView extends StatelessWidget {
  const PageTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LayoutBloc, LayoutState>(
      listenWhen: (previous, current) => previous.loading != current.loading,
      listener: (context, state) {
        if (state.loading) {
          return;
        }
        if (state.error.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
            ),
          );
        }
      },
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
              onAdd: () async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return CreateOrUpdatePageDialog(
                        title: '创建页面',
                        bloc: bloc,
                        onCreate: (layout) =>
                            bloc.add(LayoutEventCreate(layout)),
                      );
                    });
              },
              onUpdate: (PageLayout layout) async {
                await showDialog(
                    context: context,
                    builder: (context) {
                      return CreateOrUpdatePageDialog(
                        title: '更新页面',
                        bloc: bloc,
                        layout: layout,
                        onUpdate: (layout) =>
                            bloc.add(LayoutEventUpdate(layout.id!, layout)),
                      );
                    });
              },
              onDelete: (int id) async {
                await _showDeleteDialog(context, bloc, id);
              },
              onPublish: (int id) async {
                await _showPublishDialog(context, bloc, id);
              },
              onDraft: (int id) async {
                await _showDraftDialog(context, bloc, id);
              },
              onSelect: (int id) {
                context.go('/pages/$id');
              },
            );
        }
      },
    );
  }

  Future<void> _showDeleteDialog(
      BuildContext context, LayoutBloc bloc, int id) async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('删除'),
            content: const Text('确定删除吗？'),
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
          );
        });
    if (result) {
      bloc.add(LayoutEventDelete(id));
    }
  }

  Future<void> _showPublishDialog(
      BuildContext context, LayoutBloc bloc, int id) async {
    final now = DateTime.now();
    final result = await showDateRangePicker(
      initialEntryMode: DatePickerEntryMode.input,
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      saveText: '确定',
      cancelText: '取消',
      confirmText: '确定',
      fieldStartHintText: '开始时间',
      fieldEndHintText: '结束时间',
      fieldStartLabelText: '开始时间',
      fieldEndLabelText: '结束时间',
      errorFormatText: '格式错误',
      errorInvalidText: '无效时间',
      errorInvalidRangeText: '无效时间范围',
      helpText: '选择时间范围',
    );
    if (result != null) {
      bloc.add(LayoutEventPublish(id, result.start, result.end));
    }
  }

  Future<void> _showDraftDialog(
      BuildContext context, LayoutBloc bloc, int id) async {
    final result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
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
          );
        });
    if (result) {
      bloc.add(LayoutEventDraft(id));
    }
  }
}
