import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class PageTableDataSource extends DataTableSource {
  PageTableDataSource({
    required this.items,
    required this.onUpdate,
    required this.onDelete,
    required this.onPublish,
    required this.onDraft,
    required this.onSelect,
  });

  final List<PageLayout> items;
  final void Function(int) onUpdate;
  final void Function(int) onDelete;
  final void Function(int) onPublish;
  final void Function(int) onDraft;
  final void Function(int) onSelect;

  @override
  DataRow getRow(int index) {
    final item = items[index];
    final statusIcon = item.status == PageStatus.published
        ? const Icon(Icons.published_with_changes, color: Colors.green)
        : item.status == PageStatus.draft
            ? const Icon(Icons.drafts, color: Colors.yellow)
            : const Icon(Icons.archive, color: Colors.grey);
    final config = item.config;
    return DataRow.byIndex(
      index: index,
      cells: [
        DataCell(Text(
          item.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: const TextStyle(decoration: TextDecoration.underline),
        ).ripple().inkWell(onTap: () {
          onSelect.call(index);
        })),
        DataCell(Text(item.platform.value)),
        DataCell(Row(
          children: [statusIcon, Text(item.status.value)],
        )),
        DataCell(Text(item.pageType.value)),
        DataCell(Text(item.startTime?.formatted ?? '')),
        DataCell(Text(item.endTime?.formatted ?? '')),
        DataCell(Tooltip(
          message: '''
水平内边距: ${config.horizontalPadding ?? 0}
垂直内边距: ${config.verticalPadding ?? 0}
基准屏幕宽度: ${config.baselineScreenWidth ?? ''}''',
          child: const Icon(Icons.code),
        )),
        DataCell(
          Row(
            children: [
              if (item.isDraft)
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    onUpdate.call(index);
                  },
                  tooltip: '编辑',
                ),
              if (item.isDraft)
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    onDelete.call(index);
                  },
                  tooltip: '删除',
                ),
              if (item.isDraft)
                IconButton(
                  onPressed: () {
                    onPublish.call(index);
                  },
                  icon: const Icon(Icons.publish),
                  tooltip: '发布',
                ),
              if (item.isPublished)
                IconButton(
                  onPressed: () {
                    onDraft.call(index);
                  },
                  icon: const Icon(Icons.drafts),
                  tooltip: '下架',
                ),
            ],
          ),
        )
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}
