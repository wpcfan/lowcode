import 'package:admin/blocs/canvas_event.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';
import 'package:page_repository/page_repository.dart';

import '../blocs/canvas_bloc.dart';
import '../blocs/canvas_state.dart';

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
          body: Row(
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
                onTap: () {
                  setState(() {
                    context.read<CanvasBloc>().add(CanvasEventSelectNoBlock());
                  });
                },
              ),

              // 右侧属性面板
              ...[const Spacer(), const RightPane()],
            ],
          ),
        );
      }),
    );
  }
}

class RightPane extends StatelessWidget {
  const RightPane({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Container(
        color: Colors.grey,
        child: BlocBuilder<CanvasBloc, CanvasState>(
          buildWhen: (previous, current) =>
              current.selectedBlock != previous.selectedBlock &&
              current.layout != null,
          builder: (context, state) {
            final block = state.selectedBlock;
            final layoutConfig = state.layout?.config;
            final fields = block != null
                ? [
                    const Text('区块属性'),
                    TextFormField(
                      initialValue: block.title,
                      decoration: const InputDecoration(
                        labelText: '标题',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: block.sort.toString(),
                      decoration: const InputDecoration(
                        labelText: '排序',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: block.config.horizontalPadding.toString(),
                      decoration: const InputDecoration(
                        labelText: '水平内边距',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: block.config.verticalPadding.toString(),
                      decoration: const InputDecoration(
                        labelText: '垂直内边距',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: block.config.horizontalSpacing.toString(),
                      decoration: const InputDecoration(
                        labelText: '水平间距',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: block.config.verticalSpacing.toString(),
                      decoration: const InputDecoration(
                        labelText: '垂直间距',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: block.config.blockWidth.toString(),
                      decoration: const InputDecoration(
                        labelText: '区块宽度',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: block.config.blockHeight.toString(),
                      decoration: const InputDecoration(
                        labelText: '区块高度',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: block.config.backgroundColor != null
                          ? ColorToHex(block.config.backgroundColor!).toString()
                          : null,
                      decoration: const InputDecoration(
                        labelText: '背景颜色',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: block.config.borderColor != null
                          ? ColorToHex(block.config.borderColor!).toString()
                          : null,
                      decoration: const InputDecoration(
                        labelText: '边框颜色',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: block.config.borderWidth?.toString(),
                      decoration: const InputDecoration(
                        labelText: '边框宽度',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(onPressed: () {}, child: const Text('保存')),
                  ]
                : [
                    const Text('页面属性'),
                    TextFormField(
                      initialValue: layoutConfig?.horizontalPadding.toString(),
                      decoration: const InputDecoration(
                        labelText: '水平内边距',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue: layoutConfig?.verticalPadding.toString(),
                      decoration: const InputDecoration(
                        labelText: '垂直内边距',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      initialValue:
                          layoutConfig?.baselineScreenWidth.toString(),
                      decoration: const InputDecoration(
                        labelText: '基准屏幕宽度',
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedButton(onPressed: () {}, child: const Text('保存')),
                  ];
            return Form(
                child: Column(
              children: fields,
            ));
          },
        ),
      ),
    );
  }
}

class WidgetData extends Equatable {
  const WidgetData(
      {required this.icon,
      required this.label,
      this.sort,
      this.type = PageBlockType.banner});

  final IconData icon;
  final String label;
  final PageBlockType type;
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

/// 中间画布
class CenterPane extends StatefulWidget {
  const CenterPane({super.key, this.onTap});
  final void Function()? onTap;

  @override
  State<CenterPane> createState() => _CenterPaneState();
}

class _CenterPaneState extends State<CenterPane> {
  int moveOverIndex = -1;
  final _paneWidth = 400.0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CanvasBloc, CanvasState>(
      builder: (context, state) {
        switch (state.status) {
          case FetchStatus.initial:
            return const Center(
              child: Text('初始状态'),
            );
          case FetchStatus.loading:
            return const Center(
              child: CircularProgressIndicator(),
            );
          case FetchStatus.error:
            return const Center(
              child: Text('加载失败'),
            );
          case FetchStatus.populated:
            return _buildCanvas(state);
        }
      },
    );
  }

  Widget _buildCanvas(CanvasState state) {
    final paneWidth = state.layout?.config.baselineScreenWidth ?? _paneWidth;
    final blocks = state.layout?.blocks ?? [];
    final products = state.waterfallList;
    final bloc = context.read<CanvasBloc>();
    final pageId = state.layout?.id;
    final defaultBlockConfig = BlockConfig(
      horizontalPadding: 12,
      verticalPadding: 12,
      horizontalSpacing: 6,
      verticalSpacing: 6,
      blockWidth: paneWidth - 24,
      blockHeight: 140,
    );
    return SizedBox(
      width: paneWidth,
      child: Container(
        color: Colors.grey,
        child: GestureDetector(
          onTap: widget.onTap,
          child: DragTarget(
            builder: (context, candidateData, rejectedData) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return DragTarget(
                    builder: (context, candidateData, rejectedData) {
                      final item = blocks[index];
                      return _buildDraggableWidget(
                          item, products, index, paneWidth, bloc);
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
                      /// 如果是从侧边栏拖拽过来的，那么index为null
                      if (data is WidgetData && data.sort == null) {
                        if (data.type == PageBlockType.waterfall) {
                          /// 瀑布流不能插入到中间
                          return false;
                        }
                        return true;
                      }
                      if (data is PageBlock) {
                        if (data.type == PageBlockType.waterfall) {
                          /// 已经有瀑布流不能拖拽
                          return false;
                        }

                        /// 如果是从画布中拖拽过来的，需要判断拖拽的和放置的不是同一个
                        final int dragIndex =
                            blocks.indexWhere((it) => it.sort == data.sort);
                        final int dropIndex = blocks
                            .indexWhere((it) => it.sort == blocks[index].sort);
                        debugPrint('dragIndex: $dragIndex, dropIndex: ');
                        return dragIndex != dropIndex;
                      }
                      return false;
                    },
                    onAccept: (data) {
                      /// 获取要放置的位置
                      final int dropIndex = blocks
                          .indexWhere((it) => it.sort == blocks[index].sort);

                      if (data is WidgetData) {
                        /// 处理从侧边栏拖拽过来的
                        /// 如果是从侧边栏拖拽过来的，在放置的位置下方插入
                        if (data.sort == null) {
                          setState(() {
                            moveOverIndex = -1;
                          });
                          return _insertBlock(data, bloc, dropIndex,
                              defaultBlockConfig, pageId!);
                        }
                      }
                      if (data is PageBlock) {
                        /// 处理从画布中拖拽过来的

                        bloc.add(CanvasEventMoveBlock(
                          pageId!,
                          data.id!,
                          dropIndex + 1,
                        ));
                        setState(() {
                          moveOverIndex = -1;
                        });
                      }
                    },
                  );
                },
                itemCount: blocks.length,
              );
            },
            onWillAccept: (data) {
              if (data is WidgetData && data.sort == null) {
                if (data.type == PageBlockType.waterfall &&
                    blocks.indexWhere(
                            (el) => el.type == PageBlockType.waterfall) !=
                        -1) {
                  /// 已有瀑布流不能拖拽
                  return false;
                }
                return true;
              }
              return false;
            },
            onAccept: (WidgetData data) {
              _addBlock(data, bloc, blocks.length, defaultBlockConfig, pageId!);
            },
          ),
        ),
      ),
    );
  }

  void _insertBlock(WidgetData data, CanvasBloc bloc, int dropIndex,
      BlockConfig defaultBlockConfig, int pageId) {
    switch (data.type) {
      case PageBlockType.banner:
        return bloc.add(CanvasEventInsertBlock(
          pageId,
          BannerPageBlock(
            title: 'Banner ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        ));
      case PageBlockType.waterfall:
        return bloc.add(CanvasEventInsertBlock(
          pageId,
          WaterfallPageBlock(
            title: 'Waterfall ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig,
            data: const [],
          ),
        ));
      case PageBlockType.imageRow:
        return bloc.add(CanvasEventInsertBlock(
          pageId,
          ImageRowPageBlock(
            title: 'ImageRow ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        ));
      case PageBlockType.productRow:
        return bloc.add(CanvasEventInsertBlock(
          pageId,
          ProductRowPageBlock(
            title: 'ProductRow ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        ));
      default:
        return;
    }
  }

  void _addBlock(WidgetData data, CanvasBloc bloc, int dropIndex,
      BlockConfig defaultBlockConfig, int pageId) {
    switch (data.type) {
      case PageBlockType.banner:
        return bloc.add(CanvasEventAddBlock(
          pageId,
          BannerPageBlock(
            title: 'Banner ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        ));
      case PageBlockType.waterfall:
        return bloc.add(CanvasEventAddBlock(
          pageId,
          WaterfallPageBlock(
            title: 'Waterfall ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig,
            data: const [],
          ),
        ));
      case PageBlockType.imageRow:
        return bloc.add(CanvasEventAddBlock(
          pageId,
          ImageRowPageBlock(
            title: 'ImageRow ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        ));
      case PageBlockType.productRow:
        return bloc.add(CanvasEventAddBlock(
          pageId,
          ProductRowPageBlock(
            title: 'ProductRow ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        ));
      default:
        return;
    }
  }

  Widget _buildDraggableWidget(PageBlock block, List<Product> products,
      int index, double itemWidth, CanvasBloc bloc) {
    page({required Widget child}) => Draggable(
          data: block,
          feedback: SizedBox(
            width: itemWidth,
            child: Opacity(
              opacity: 0.5,
              child: child,
            ),
          ),
          child: SizedBox(
            width: itemWidth,
            child: Container(
              color: moveOverIndex == index ? Colors.red[200] : Colors.black45,
              child: child,
            ),
          ),
        );

    Widget widget;
    const errorImage = 'assets/images/error_150_150.png';
    switch (block.type) {
      case PageBlockType.banner:
        final it = block as BannerPageBlock;
        final data = it.data.map((di) => di.content).toList();
        final items = data.isNotEmpty
            ? data
            : [
                const ImageData(image: 'https://picsum.photos/400/100'),
                const ImageData(image: 'https://picsum.photos/400/100'),
                const ImageData(image: 'https://picsum.photos/400/100')
              ];

        /// SliverToBoxAdapter 可以将一个 Widget 转换成 Sliver
        widget = BannerWidget(
          items: items,
          config: it.config,
          ratio: 1.0,
          errorImage: errorImage,
          onTap: (_) {
            bloc.add(CanvasEventSelectBlock(block));
          },
        );
        break;
      case PageBlockType.imageRow:
        final it = block as ImageRowPageBlock;
        final data = it.data.map((di) => di.content).toList();
        final items = data.isNotEmpty
            ? data
            : const [
                ImageData(image: 'https://picsum.photos/100/80'),
                ImageData(image: 'https://picsum.photos/100/80'),
                ImageData(image: 'https://picsum.photos/100/80')
              ];
        widget = ImageRowWidget(
          items: items,
          config: it.config,
          ratio: 1.0,
          errorImage: errorImage,
          onTap: (_) {
            bloc.add(CanvasEventSelectBlock(block));
          },
        );
        break;
      case PageBlockType.productRow:
        final it = block as ProductRowPageBlock;
        final data = it.data.map((di) => di.content).toList();
        final items = data.isNotEmpty
            ? data
            : [
                const Product(
                  id: 1,
                  name: 'Product 1',
                  description: 'Description 1',
                  images: ['https://picsum.photos/100/80'],
                  price: '¥100.23',
                )
              ];
        widget = ProductRowWidget(
          items: items,
          config: it.config,
          ratio: 1.0,
          errorImage: errorImage,
          onTap: (_) {
            bloc.add(CanvasEventSelectBlock(block));
          },
        );
        break;
      case PageBlockType.waterfall:
        final it = block as WaterfallPageBlock;
        final items = products.isNotEmpty
            ? products
            : const [
                Product(
                  id: 1,
                  name: 'Product 1',
                  description: 'Description 1',
                  images: ['https://picsum.photos/100/80'],
                  price: '¥100.23',
                ),
                Product(
                  id: 2,
                  name: 'Product 2',
                  description: 'Description 2',
                  images: ['https://picsum.photos/100/80'],
                  price: '¥200.34',
                ),
                Product(
                  id: 3,
                  name: 'Product 3',
                  description: 'Description 3',
                  images: ['https://picsum.photos/100/80'],
                  price: '¥300.45',
                ),
                Product(
                  id: 4,
                  name: 'Product 4',
                  description: 'Description 4',
                  images: ['https://picsum.photos/100/80'],
                  price: '¥400.56',
                ),
              ];

        widget = WaterfallWidget(
          products: items,
          config: it.config,
          ratio: 1.0,
          errorImage: errorImage,
          isPreview: true,
          onTap: (_) {
            bloc.add(CanvasEventSelectBlock(block));
          },
        );
        break;
      default:
        return Container();
    }

    return page(child: widget);
  }
}
