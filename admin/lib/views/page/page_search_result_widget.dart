import 'package:admin/views/page/date_range_filter_widget.dart';
import 'package:admin/views/page/selection_filter_widget.dart';
import 'package:admin/views/page/text_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_repository/page_repository.dart';

import 'custom_paginated_table.dart';
import 'page_search_result_data_source.dart';

class PageSearchResultWidget extends StatelessWidget {
  const PageSearchResultWidget({
    super.key,
    required this.pageSearchResult,
    this.onPageChanged,
    required this.onTitleChanged,
    required this.onPlatformChanged,
    required this.onStatusChanged,
    required this.onPageTypeChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.onClearAll,
    required this.query,
  });

  final PageWrapper<PageLayout> pageSearchResult;
  final void Function(int?)? onPageChanged;
  final void Function(String?) onTitleChanged;
  final void Function(Platform?) onPlatformChanged;
  final void Function(PageStatus?) onStatusChanged;
  final void Function(PageType?) onPageTypeChanged;
  final void Function(DateTimeRange?) onStartDateChanged;
  final void Function(DateTimeRange?) onEndDateChanged;
  final void Function() onClearAll;
  final PageQuery query;

  @override
  Widget build(BuildContext context) {
    final title = TextFilterWidget(
      label: '标题',
      onFilter: onTitleChanged,
      popupTitle: '页面标题',
      popupHintText: '请输入页面标题包含的内容',
      value: query.title,
    );

    final platform = SelectionFilterWidget(
      label: '平台',
      onFilter: onPlatformChanged,
      items: [
        SelectionItem(value: Platform.app, label: Platform.app.value),
        SelectionItem(value: Platform.web, label: Platform.web.value),
      ],
      value: query.platform,
    );

    final pageType = SelectionFilterWidget(
      label: '页面类型',
      onFilter: onPageTypeChanged,
      items: [
        SelectionItem(value: PageType.home, label: PageType.home.value),
        SelectionItem(value: PageType.category, label: PageType.category.value),
        SelectionItem(value: PageType.about, label: PageType.about.value),
      ],
      value: query.pageType,
    );

    final status = SelectionFilterWidget(
      label: '状态',
      onFilter: onStatusChanged,
      items: [
        SelectionItem(value: PageStatus.draft, label: PageStatus.draft.value),
        SelectionItem(
            value: PageStatus.published, label: PageStatus.published.value),
        SelectionItem(
            value: PageStatus.archived, label: PageStatus.archived.value),
      ],
      value: query.status,
    );

    final startDate = DateRangeFilterWidget(
        label: '开始日期',
        helpText: '选择开始日期的范围',
        onFilter: onStartDateChanged,
        value: query.startDateFrom != null && query.startDateTo != null
            ? DateTimeRange(
                start: DateTime.parse(query.startDateFrom!),
                end: DateTime.parse(query.startDateTo!),
              )
            : null);

    final endDate = DateRangeFilterWidget(
        label: '结束日期',
        helpText: '选择结束日期的范围',
        onFilter: onEndDateChanged,
        value: query.endDateFrom != null && query.endDateTo != null
            ? DateTimeRange(
                start: DateTime.parse(query.endDateFrom!),
                end: DateTime.parse(query.endDateTo!),
              )
            : null);

    final dataColumns = [
      title,
      platform,
      status,
      pageType,
      startDate,
      endDate,
    ].map((e) => DataColumn(label: e)).toList();

    return CustomPaginatedTable(
      rowPerPage: pageSearchResult.size,
      dataColumns: dataColumns,
      showActions: true,
      actions: [
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.filter_list_off_outlined),
          onPressed: onClearAll,
        ),
      ],
      header: const Text('Page Search Result'),
      sortColumnIndex: 0,
      sortColumnAsc: true,
      onPageChanged: onPageChanged,
      dataTableSource: PageSearchResultDataSource(pageSearchResult),
    );
  }
}
