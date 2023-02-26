import 'package:common/common.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({super.key});

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  bool _showPropertiesPanel = false;
  int moveOverIndex = -1;
  final List<WidgetData> _placedWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // 左侧组件列表面板
          const SizedBox(
            width: 300,
            child: LeftPane(widgets: [
              WidgetData(icon: Icons.ac_unit, label: 'AC Unit'),
              WidgetData(icon: Icons.access_alarm, label: 'Alarm'),
              WidgetData(icon: Icons.access_time, label: 'Time'),
            ]),
          ),

          // 中间画布
          SizedBox(
            width: 400,
            height: 760,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _showPropertiesPanel = false;
                });
              },
              child: DragTarget(
                builder: (context, candidateData, rejectedData) {
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return DragTarget(
                        builder: (context, candidateData, rejectedData) {
                          final item =
                              _placedWidgets[index].copyWith(sort: index);
                          return _buildDraggableWidget(item, index);
                        },
                        onMove: (details) {
                          setState(() {
                            moveOverIndex = index;
                          });
                        },
                        onLeave: (data) {
                          setState(() {
                            moveOverIndex = -1;
                          });
                        },
                        onWillAccept: (data) {
                          if (data is WidgetData) {
                            /// 如果是从侧边栏拖拽过来的，那么index为null
                            if (data.sort == null) {
                              return true;
                            }

                            /// 如果是从画布中拖拽过来的，需要判断拖拽的和放置的不是同一个
                            final int dragIndex = _placedWidgets
                                .indexWhere((it) => it.sort == data.sort);
                            final int dropIndex = _placedWidgets.indexWhere(
                                (it) => it.sort == _placedWidgets[index].sort);
                            debugPrint(
                                'dragIndex: $dragIndex, dropIndex: $dropIndex');
                            return dragIndex != dropIndex;
                          }
                          return false;
                        },
                        onAccept: (WidgetData data) {
                          /// 获取要放置的位置
                          final int dropIndex = _placedWidgets.indexWhere(
                              (it) => it.sort == _placedWidgets[index].sort);

                          /// 如果是从侧边栏拖拽过来的，在放置的位置下方插入
                          if (data.sort == null) {
                            setState(() {
                              final newData =
                                  data.copyWith(sort: dropIndex + 1);
                              _placedWidgets.insert(dropIndex + 1, newData);
                              moveOverIndex = -1;
                            });
                            return;
                          }
                          final int dragIndex = _placedWidgets
                              .indexWhere((it) => it.sort == data.sort);

                          debugPrint(
                              'dragIndex: $dragIndex, dropIndex: $dropIndex');
                          setState(() {
                            debugPrint('before moved: $_placedWidgets');

                            /// 如果是从画布中拖拽过来的，需要将拖拽的元素插入到放置的位置下方
                            /// 并且将原来的元素删除，这个我们通过 List 的扩展方法 move 来实现
                            _placedWidgets.move(dragIndex, dropIndex);

                            /// 由于是插入，所有元素的 index 都需要更新
                            for (var i = 0; i < _placedWidgets.length; i++) {
                              _placedWidgets[i] =
                                  _placedWidgets[i].copyWith(sort: i);
                            }
                            moveOverIndex = -1;
                          });
                        },
                      );
                    },
                    itemCount: _placedWidgets.length,
                  );
                },
                onWillAccept: (data) {
                  if (data is WidgetData && data.sort == null) {
                    return true;
                  }
                  return false;
                },
                onAccept: (WidgetData data) {
                  setState(() {
                    final newData = data.copyWith(sort: _placedWidgets.length);
                    _placedWidgets.add(newData);
                  });
                },
              ),
            ),
          ),

          // 右侧属性面板
          if (_showPropertiesPanel) ...[
            const Spacer(),
            SizedBox(
              width: 300,
              child: Container(
                color: Colors.grey,
                child: const Center(
                  child: Text('Properties Panel'),
                ),
              ),
            )
          ],
        ],
      ),

      // 按钮
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _showPropertiesPanel = !_showPropertiesPanel;
          });
        },
        backgroundColor: Colors.purple,
        child: const Text(
          '旋转90度',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildDraggableWidget(WidgetData oldData, int sort) {
    final data = oldData.copyWith(sort: sort);
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
          color: moveOverIndex == sort ? Colors.red[200] : Colors.black45,
          child: ListTile(
            leading: Icon(data.icon),
            title: Text(data.label),
          ),
        ),
      ),
    );
  }
}

class WidgetData extends Equatable {
  const WidgetData({required this.icon, required this.label, this.sort});

  final IconData icon;
  final String label;
  final int? sort;

  @override
  String toString() {
    return 'WidgetData{icon: $icon, label: $label, index: $sort}';
  }

  @override
  List<Object?> get props => [icon, label, sort];

  WidgetData copyWith({IconData? icon, String? label, int? sort}) {
    return WidgetData(
      icon: icon ?? this.icon,
      label: label ?? this.label,
      sort: sort ?? this.sort,
    );
  }
}

class LeftPane extends StatelessWidget {
  const LeftPane({super.key, required this.widgets});
  final List<WidgetData> widgets;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < widgets.length; i++)
          _buildDraggableWidget(widgets[i], i),
      ],
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
