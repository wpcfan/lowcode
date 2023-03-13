import 'package:admin/views/page/create_or_update_image_data_dialog.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';

import '../../blocs/canvas_bloc.dart';
import '../../blocs/canvas_event.dart';

class ImageDataForm extends StatelessWidget {
  const ImageDataForm({
    super.key,
    required this.data,
  });
  final List<BlockData<ImageData>> data;

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<CanvasBloc>();

    /// 表格列头：图片、链接类型、链接地址、操作
    const dataColumns = [
      DataColumn(label: Text('图片')),
      DataColumn(label: Text('链接类型')),
      DataColumn(label: Text('链接地址')),
      DataColumn(label: Text('操作')),
    ];

    /// 表格行：图片、链接类型、链接地址、删除按钮
    final dataRows = data.map(
      (e) {
        final item = e.content;
        return DataRow(
          cells: [
            DataCell(Image.network(item.image)),
            DataCell(Text(item.link?.type.value ?? '')),
            DataCell(Text(item.link?.value ?? '')),
            DataCell(
              IconButton(
                onPressed: () {
                  bloc.add(CanvasEventDeleteBlockData(e.id!));
                },
                icon: const Icon(Icons.delete),
              ),
            ),
          ],
        );
      },
    ).toList();

    /// 表头：添加图片按钮
    final header = [
      IconButton(
        onPressed: () async {
          await showDialog<CreateOrUpdateImageDataDialog>(
            context: context,
            builder: (context) => CreateOrUpdateImageDataDialog(
              title: '添加图片',
              onCreate: (data) {
                bloc.add(CanvasEventAddBlockData(data));
              },
            ),
          );
        },
        icon: const Icon(Icons.add),
        tooltip: '添加图片数据',
      ),
    ]
        .toRow(mainAxisAlignment: MainAxisAlignment.end)
        .backgroundColor(Colors.grey[600]!);

    /// 表格
    final table = DataTable(
      columns: dataColumns,
      rows: dataRows,
    );

    /// 最终组件
    final widget = [
      header,
      table,
    ].toColumn().scrollable();
    return widget;
  }
}
