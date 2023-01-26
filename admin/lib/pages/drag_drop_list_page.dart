import 'package:admin/extensions/list_extensions.dart';
import 'package:flutter/material.dart';

class DragDropListPage extends StatefulWidget {
  const DragDropListPage({super.key});

  @override
  State<DragDropListPage> createState() => _DragDropListPageState();
}

class _DragDropListPageState extends State<DragDropListPage>
    with TickerProviderStateMixin {
  final List<int> _items = List<int>.generate(20, (int index) => index);
  int sortType = -1;
  double scale = 1.0;
  int moveOverIndex = -1;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        final String item = "${_items[index]}";
        return DragTarget(
          builder: (context, candidateData, rejectedData) {
            return Draggable(
              data: item,
              feedback: DragListTileWidget(item: item),
              child: ListTileWidget(item: item, isDragOver: moveOverIndex == index, scale: scale),
            );
          },
          onMove: (details) {
            setState(() {
              scale = 1.1;
              moveOverIndex = index;
            });
          },
          onLeave: (data) {
            setState(() {
              scale = 1.0;
            });
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

class ListTileWidget extends StatelessWidget {
  const ListTileWidget({
    super.key,
    required this.item,
    required this.isDragOver,
    required this.scale,
  });

  final String item;
  final bool isDragOver;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      key: Key(item),
      tileColor:
      isDragOver ? Colors.red[100] : Colors.amber,
      title: Text(
        'Item $item',
        textScaleFactor: isDragOver ? scale : 1.0,
      ),
    );
  }
}

class DragListTileWidget extends StatelessWidget {
  const DragListTileWidget({
    super.key,
    required this.item,
  });

  final String item;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: SizedBox(
        width: 200,
        height: 50,
        child: ListTile(
          tileColor: Colors.blue,
          title: Text('Item $item'),
        ),
      ),
    );
  }
}
