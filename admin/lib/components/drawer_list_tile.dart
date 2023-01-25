import 'package:flutter/material.dart';

class DragData {
  String id;
  String name;
  DragData({required this.id, required this.name});
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String title;
  final VoidCallback press;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Draggable(
      data: DragData(id: '1', name: title),
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          height: 80,
          width: 200,
          color: Colors.red,
          child: Center(
            child: Text(
              title,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      child: ListTile(
        onTap: press,
        horizontalTitleGap: 0.0,
        leading: Icon(
          icon,
          color: Colors.white54,
        ),
        title: Text(
          title,
          style: const TextStyle(color: Colors.white54),
        ),
      ),
    );
  }
}
