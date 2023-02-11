import 'package:admin/repositories/page_repository.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

class CustomPaginatedTableHeader extends StatefulWidget {
  const CustomPaginatedTableHeader({super.key});

  @override
  State<CustomPaginatedTableHeader> createState() =>
      _CustomPaginatedTableHeaderState();
}

class _CustomPaginatedTableHeaderState
    extends State<CustomPaginatedTableHeader> {
  PageQuery _query = const PageQuery();

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
          _query = const PageQuery();
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
