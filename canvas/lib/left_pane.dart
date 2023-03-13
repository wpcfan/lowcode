import 'package:flutter/material.dart';

import '../../models/widget_data.dart';

class LeftPane extends StatelessWidget {
  const LeftPane({super.key, required this.widgets});
  final List<WidgetData> widgets;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: SingleChildScrollView(
        child: Column(
          children: [
            for (var i = 0; i < widgets.length; i++)
              _buildDraggableWidget(widgets[i], i),
          ],
        ),
      ),
    );
  }

  Widget _buildDraggableWidget(WidgetData data, int index) {
    return Draggable(
      data: data,
      feedback: SizedBox(
        width: 400,
        height: 50,
        child: Opacity(
          opacity: 0.5,
          child: Card(
            child: ListTile(
              leading: Icon(data.icon),
              title: Text(data.label),
            ),
          ),
        ),
      ),
      child: SizedBox(
        width: 400,
        height: 50,
        child: Card(
          child: ListTile(
            leading: Icon(data.icon),
            title: Text(data.label),
          ),
        ),
      ),
    );
  }
}
