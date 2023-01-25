import 'package:admin/extensions/list_extensions.dart';
import 'package:flutter/material.dart';

class DragDropListPage extends StatefulWidget {
  const DragDropListPage({super.key});

  @override
  State<DragDropListPage> createState() => _DragDropListPageState();
}

class _DragDropListPageState extends State<DragDropListPage> {
  final List<int> _items = List<int>.generate(20, (int index) => index);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final String item = "${_items[index]}";
        return DragTarget(
          builder: (context, candidateData, rejectedData) {
            return Draggable(
              data: item,
              feedback: SizedBox(
                width: 200,
                height: 50,
                child: ListTile(
                  tileColor: Colors.blue,
                  title: Text('Item $item'),
                ),
              ),
              child: ListTile(
                key: Key(item),
                title: Text('Item $item'),
              ),
            );
          },
          onWillAccept: (data) {
            return true;
          },
          onAccept: (String data) {
            final int dragIndex = _items.indexOf(int.parse(data));
            final int dropIndex = _items.indexOf(int.parse(item));

            setState(() {
              _items.swap(dragIndex, dropIndex);
            });
          },
        );
      },
      itemCount: _items.length,
    );
  }
}
