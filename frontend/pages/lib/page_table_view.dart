import 'package:common/common.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';
import 'package:repositories/repositories.dart';

import 'blocs/blocs.dart';
import 'popups/popups.dart';
import 'widgets/widgets.dart';

class PageTableView extends StatelessWidget {
  const PageTableView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Dio>(
          create: (context) => AdminClient.getInstance(),
        ),
        RepositoryProvider<PageAdminRepository>(
          create: (context) => PageAdminRepository(client: context.read<Dio>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<PageBloc>(
            create: (context) => PageBloc(
              context.read<PageAdminRepository>(),
            )..add(PageEventClearAll()),
          ),
        ],
        child: BlocConsumer<PageBloc, PageState>(
          listenWhen: (previous, current) =>
              previous.loading != current.loading,
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
              context.read<PageBloc>().add(PageEventClearError());
            }
          },
          builder: (context, state) {
            final bloc = context.read<PageBloc>();
            switch (state.status) {
              case FetchStatus.initial:
                return const Text('initial').center();
              case FetchStatus.loading:
                return const CircularProgressIndicator().center();
              default:
                return _buildPageTable(state, bloc, context);
            }
          },
        ),
      ),
    );
  }

  PageTableWidget _buildPageTable(
      PageState state, PageBloc bloc, BuildContext context) {
    return PageTableWidget(
      query: state.query,
      items: state.items,
      page: state.page,
      pageSize: state.pageSize,
      total: state.total,
      onPageChanged: (int? value) => bloc.add(PageEventPageChanged(value)),
      onTitleChanged: (String? value) => bloc.add(PageEventTitleChanged(value)),
      onPlatformChanged: (Platform? value) =>
          bloc.add(PageEventPlatformChanged(value)),
      onStatusChanged: (PageStatus? value) =>
          bloc.add(PageEventPageStatusChanged(value)),
      onPageTypeChanged: (PageType? value) =>
          bloc.add(PageEventPageTypeChanged(value)),
      onStartDateChanged: (DateTimeRange? value) =>
          bloc.add(PageEventStartDateChanged(value?.start, value?.end)),
      onEndDateChanged: (DateTimeRange? value) =>
          bloc.add(PageEventEndDateChanged(value?.start, value?.end)),
      onClearAll: () => bloc.add(PageEventClearAll()),
      onAdd: () => showDialog(
          context: context,
          builder: (context) {
            return CreateOrUpdatePageDialog(
              title: '创建页面',
              onCreate: (layout) => bloc.add(PageEventCreate(layout)),
            );
          }),
      onUpdate: (PageLayout layout) => showDialog(
          context: context,
          builder: (context) {
            return CreateOrUpdatePageDialog(
              title: '更新页面',
              layout: layout,
              onUpdate: (layout) =>
                  bloc.add(PageEventUpdate(layout.id!, layout)),
            );
          }),
      onDelete: (int id) => _showDeleteDialog(context, bloc, id),
      onPublish: (int id) => _showPublishDialog(context, bloc, id),
      onDraft: (int id) => _showDraftDialog(context, bloc, id),
      onSelect: (int id) => context.go('/$id'),
    );
  }

  Future<void> _showDeleteDialog(
      BuildContext context, PageBloc bloc, int id) async {
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
      bloc.add(PageEventDelete(id));
    }
  }

  Future<void> _showPublishDialog(
      BuildContext context, PageBloc bloc, int id) async {
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
      bloc.add(PageEventPublish(id, result.start, result.end));
    }
  }

  Future<void> _showDraftDialog(
      BuildContext context, PageBloc bloc, int id) async {
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
      bloc.add(PageEventDraft(id));
    }
  }
}
