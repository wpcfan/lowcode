import 'package:admin/components/drawer_list_tile.dart';
import 'package:flutter/material.dart';

class CanvasPage extends StatelessWidget {
  const CanvasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DragTarget(builder: (context, candidateData, rejectedData) {
      return Container(
        color: Colors.blue,
        child: const Center(
          child: Text('Drag Here'),
        ),
      );
    }, onWillAccept: (data) {
      return true;
    }, onAccept: (data) {
      if (data is DragData) {
        print(data.name);
      }
    });
  }
}
