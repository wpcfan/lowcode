import 'package:admin/blocs/canvas_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_repository/page_repository.dart';

import '../blocs/canvas_bloc.dart';
import '../blocs/canvas_state.dart';
import '../models/widget_data.dart';
import 'page/center_pane.dart';
import 'page/left_pane.dart';
import 'page/right_pane.dart';

class CanvasPage extends StatefulWidget {
  const CanvasPage({super.key, required this.id});
  final int id;

  @override
  State<CanvasPage> createState() => _CanvasPageState();
}

class _CanvasPageState extends State<CanvasPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<CanvasBloc>(
      create: (context) => CanvasBloc(
        context.read<PageAdminRepository>(),
        context.read<PageBlockRepository>(),
        context.read<PageBlockDataRepository>(),
        context.read<ProductRepository>(),
      )..add(CanvasEventLoad(widget.id)),
      child: Builder(builder: (context) {
        return Scaffold(
          body: BlocConsumer<CanvasBloc, CanvasState>(
            listener: (context, state) {
              if (state.status == FetchStatus.error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 左侧组件列表面板
                  const LeftPane(widgets: [
                    WidgetData(
                        icon: Icons.photo_library,
                        label: '轮播图',
                        type: PageBlockType.banner),
                    WidgetData(
                        icon: Icons.imagesearch_roller,
                        label: '图片行',
                        type: PageBlockType.imageRow),
                    WidgetData(
                        icon: Icons.production_quantity_limits,
                        label: '产品行',
                        type: PageBlockType.productRow),
                    WidgetData(
                        icon: Icons.category,
                        label: '瀑布流',
                        type: PageBlockType.waterfall),
                  ]),

                  // 中间画布

                  CenterPane(
                    state: state,
                    onTap: () {
                      context
                          .read<CanvasBloc>()
                          .add(CanvasEventSelectNoBlock());
                    },
                  ),

                  // 右侧属性面板
                  ...[
                    const Spacer(),
                    RightPane(
                      showBlockConfig: state.selectedBlock != null,
                      state: state,
                    ),
                  ],
                ],
              );
            },
          ),
        );
      }),
    );
  }
}
