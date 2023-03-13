library canvas;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';
import 'package:page_repository/page_repository.dart';

import 'blocs/canvas_bloc.dart';
import 'blocs/canvas_event.dart';
import 'blocs/canvas_state.dart';
import 'center_pane.dart';
import 'left_pane.dart';
import 'models/widget_data.dart';
import 'right_pane.dart';

class CanvasPage extends StatelessWidget {
  const CanvasPage({super.key, required this.id});
  final int id;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<Dio>(
          create: (context) => AdminClient.getInstance(),
        ),
        RepositoryProvider<PageAdminRepository>(
          create: (context) => PageAdminRepository(client: context.read<Dio>()),
        ),
        RepositoryProvider<PageBlockRepository>(
          create: (context) => PageBlockRepository(client: context.read<Dio>()),
        ),
        RepositoryProvider<PageBlockDataRepository>(
          create: (context) =>
              PageBlockDataRepository(client: context.read<Dio>()),
        ),
        RepositoryProvider<ProductRepository>(
          create: (context) => ProductRepository(client: context.read<Dio>()),
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => CategoryRepository(client: context.read<Dio>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CanvasBloc>(
            create: (context) => CanvasBloc(
              context.read<PageAdminRepository>(),
              context.read<PageBlockRepository>(),
              context.read<PageBlockDataRepository>(),
              context.read<ProductRepository>(),
            )..add(CanvasEventLoad(id)),
          ),
        ],
        child: Builder(builder: (context) {
          return Scaffold(
            body: BlocConsumer<CanvasBloc, CanvasState>(
              listener: (context, state) {
                if (state.error.isNotEmpty) {
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
                      Expanded(
                        flex: 4,
                        child: RighePane(
                          showBlockConfig: state.selectedBlock != null,
                          state: state,
                          onSavePageBlock: (pageBlock) {
                            context.read<CanvasBloc>().add(
                                  CanvasEventUpdateBlock(state.layout!.id!,
                                      pageBlock.id!, pageBlock),
                                );
                          },
                          onSavePageLayout: (pageLayout) {
                            context.read<CanvasBloc>().add(
                                  CanvasEventSave(
                                      state.layout!.id!, pageLayout),
                                );
                          },
                          onDeleteBlock: (blockId) async {
                            final bloc = context.read<CanvasBloc>();
                            final result = await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('删除'),
                                    content: const Text('确定要删除吗？'),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: const Text('取消'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text('确定'),
                                      ),
                                    ],
                                  );
                                });
                            if (result) {
                              bloc.add(
                                CanvasEventDeleteBlock(
                                    state.layout!.id!, blockId),
                              );
                            }
                          },
                          onCategoryAdded: (data) {
                            context
                                .read<CanvasBloc>()
                                .add(CanvasEventAddBlockData(data));
                          },
                          onCategoryUpdated: (data) {
                            context
                                .read<CanvasBloc>()
                                .add(CanvasEventUpdateBlockData(data));
                          },
                          onCategoryRemoved: (dataId) {
                            context
                                .read<CanvasBloc>()
                                .add(CanvasEventDeleteBlockData(dataId));
                          },
                          onProductAdded: (data) {
                            context
                                .read<CanvasBloc>()
                                .add(CanvasEventAddBlockData(data));
                          },
                          onProductRemoved: (dataId) {
                            context
                                .read<CanvasBloc>()
                                .add(CanvasEventDeleteBlockData(dataId));
                          },
                        ),
                      ),
                    ],
                  ],
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
