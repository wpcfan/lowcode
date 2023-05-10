import 'package:common/common.dart';
import 'package:flutter/material.dart';

import 'models/models.dart';

/// 左侧面板组件
/// [widgets] 组件列表
class LeftPane extends StatelessWidget {
  const LeftPane({super.key, required this.widgets});
  final List<WidgetData> widgets;

  @override
  Widget build(BuildContext context) {
    return widgets
        .map((e) => _buildDraggableWidget(e))
        .toList()
        .toColumn()
        .scrollable();
  }

  Widget _buildDraggableWidget(WidgetData data) {
    final listTile = ListTile(
      leading: Icon(
        data.icon,
        color: Colors.white54,
      ),
      title: Text(
        data.label,
        style: const TextStyle(color: Colors.white54),
      ),
    );
    return Draggable(
      data: data,

      /// 拖拽时的组件展现，这里使用了透明度和宽度限制
      feedback: listTile.card().opacity(0.5).constrained(
            width: 400,
            height: 80,
          ),
      child: listTile.card().constrained(
            height: 80,
          ),
    );
  }
}
