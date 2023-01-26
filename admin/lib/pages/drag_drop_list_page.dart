import 'package:admin/extensions/list_extensions.dart';
import 'package:flutter/material.dart';

class DragDropListPage extends StatefulWidget {
  const DragDropListPage({super.key});

  @override
  State<DragDropListPage> createState() => _DragDropListPageState();
}

class _DragDropListPageState extends State<DragDropListPage> {
  final List<int> _items = List<int>.generate(20, (int index) => index);
  int sortType = -1;
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
            if (data is String) {
              final int dragIndex = _items.indexOf(int.parse(data));
              final int dropIndex = _items.indexOf(int.parse(item));
              return dragIndex != dropIndex;
            }
            return false;
          },
          onAccept: (String data) async {
            final int dragIndex = _items.indexOf(int.parse(data));
            final int dropIndex = _items.indexOf(int.parse(item));

            final result = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: Text('Item $item'),
                      content: const Text('Please choose the sort type below.'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, 0),
                          child: const Text('Swap'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 1),
                          child: const Text('Move'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, -1),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ));
            setState(() {
              sortType = result;
              if (sortType == 0) {
                _items.swap(dragIndex, dropIndex);
              } else if (sortType == 1) {
                _items.move(dragIndex, dropIndex);
              }
            });
          },
        );
      },
      itemCount: _items.length,
    );
  }
}
