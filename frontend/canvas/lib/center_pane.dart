import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';

import 'blocs/blocs.dart';
import 'models/models.dart';

/// 中间画布
class CenterPane extends StatefulWidget {
  const CenterPane({super.key, this.onTap, required this.state});
  final void Function()? onTap;
  final CanvasState state;

  @override
  State<CenterPane> createState() => _CenterPaneState();
}

class _CenterPaneState extends State<CenterPane> {
  int moveOverIndex = -1;
  final _paneWidth = 400.0;

  @override
  Widget build(BuildContext context) {
    return _buildCanvas(widget.state);
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
      backgroundColor: Colors.white,
      borderColor: Colors.transparent,
      borderWidth: 0,
    );
    return SizedBox(
      width: paneWidth,
      child: Container(
        color: Colors.grey,
        padding: EdgeInsets.symmetric(
            horizontal: state.layout?.config.horizontalPadding ?? 0.0,
            vertical: state.layout?.config.verticalPadding ?? 0.0),
        child: GestureDetector(
          onTap: widget.onTap,
          child: DragTarget(
            builder: (context, candidateData, rejectedData) {
              return ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return _buildListItem(blocks, index, products, paneWidth,
                      bloc, defaultBlockConfig, pageId);
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

  DragTarget<Object> _buildListItem(
      List<PageBlock<dynamic>> blocks,
      int index,
      List<Product> products,
      double paneWidth,
      CanvasBloc bloc,
      BlockConfig defaultBlockConfig,
      int? pageId) {
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        final item = blocks[index];
        return _buildDraggableWidget(item, products, index, paneWidth, bloc);
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
          final int dragIndex = blocks.indexWhere((it) => it.sort == data.sort);
          final int dropIndex =
              blocks.indexWhere((it) => it.sort == blocks[index].sort);
          debugPrint('dragIndex: $dragIndex, dropIndex: ');
          return dragIndex != dropIndex;
        }
        return false;
      },
      onAccept: (data) {
        /// 获取要放置的位置
        final int dropIndex =
            blocks.indexWhere((it) => it.sort == blocks[index].sort);

        if (data is WidgetData) {
          /// 处理从侧边栏拖拽过来的
          /// 如果是从侧边栏拖拽过来的，在放置的位置下方插入
          if (data.sort == null) {
            setState(() {
              moveOverIndex = -1;
            });
            return _insertBlock(
                data, bloc, dropIndex, defaultBlockConfig, pageId!);
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
  }

  void _insertBlock(WidgetData data, CanvasBloc bloc, int dropIndex,
      BlockConfig defaultBlockConfig, int pageId) {
    switch (data.type) {
      case PageBlockType.banner:
        return bloc.add(CanvasEventInsertBlock(
          pageId,
          PageBlock<ImageData>(
            type: PageBlockType.banner,
            title: 'Banner ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        ));
      case PageBlockType.waterfall:
        return bloc.add(CanvasEventInsertBlock(
          pageId,
          PageBlock<Category>(
            type: PageBlockType.waterfall,
            title: 'Waterfall ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig,
            data: const [],
          ),
        ));
      case PageBlockType.imageRow:
        return bloc.add(CanvasEventInsertBlock(
          pageId,
          PageBlock<ImageData>(
            type: PageBlockType.imageRow,
            title: 'ImageRow ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        ));
      case PageBlockType.productRow:
        return bloc.add(CanvasEventInsertBlock(
          pageId,
          PageBlock<Product>(
            type: PageBlockType.productRow,
            title: 'ProductRow ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig.copyWith(blockHeight: 110),
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
          PageBlock<ImageData>(
            type: PageBlockType.banner,
            title: 'Banner ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        ));
      case PageBlockType.waterfall:
        return bloc.add(CanvasEventAddBlock(
          pageId,
          PageBlock<Category>(
            type: PageBlockType.waterfall,
            title: 'Waterfall ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig,
            data: const [],
          ),
        ));
      case PageBlockType.imageRow:
        return bloc.add(CanvasEventAddBlock(
          pageId,
          PageBlock<ImageData>(
            type: PageBlockType.imageRow,
            title: 'ImageRow ${dropIndex + 1}',
            sort: dropIndex + 1,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        ));
      case PageBlockType.productRow:
        return bloc.add(CanvasEventAddBlock(
          pageId,
          PageBlock<Product>(
            type: PageBlockType.productRow,
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
    switch (block.type) {
      case PageBlockType.banner:
        final it = block as PageBlock<ImageData>;
        final data = it.data.map((di) => di.content).toList();
        final items = data.isNotEmpty
            ? data
            : [
                const ImageData(
                    image: 'http://localhost:8080/api/v1/image/400/100/First'),
                const ImageData(
                    image: 'http://localhost:8080/api/v1/image/400/100/Second'),
                const ImageData(
                    image: 'http://localhost:8080/api/v1/image/400/100/Third')
              ];

        /// SliverToBoxAdapter 可以将一个 Widget 转换成 Sliver
        widget = BannerWidget(
          items: items,
          config: it.config,
          ratio: 1.0,
          onTap: (_) {
            bloc.add(CanvasEventSelectBlock(block));
          },
        );
        break;
      case PageBlockType.imageRow:
        final it = block as PageBlock<ImageData>;
        final data = it.data.map((di) => di.content).toList();
        final items = data.isNotEmpty
            ? data
            : const [
                ImageData(
                    image: 'http://localhost:8080/api/v1/image/100/80/First'),
                ImageData(
                    image: 'http://localhost:8080/api/v1/image/100/80/Second'),
                ImageData(
                    image: 'http://localhost:8080/api/v1/image/100/80/Third')
              ];
        widget = ImageRowWidget(
          items: items,
          config: it.config,
          ratio: 1.0,
          onTap: (_) {
            bloc.add(CanvasEventSelectBlock(block));
          },
        );
        break;
      case PageBlockType.productRow:
        final it = block as PageBlock<Product>;
        final data = it.data.map((di) => di.content).toList();
        final items = data.isNotEmpty
            ? data
            : [
                const Product(
                  id: 1,
                  name: 'Product 1',
                  description: 'Description 1',
                  images: [
                    'http://localhost:8080/api/v1/image/100/80/Product1'
                  ],
                  price: '¥100.23',
                )
              ];
        widget = ProductRowWidget(
          items: items,
          config: it.config,
          ratio: 1.0,
          onTap: (_) {
            bloc.add(CanvasEventSelectBlock(block));
          },
        );
        break;
      case PageBlockType.waterfall:
        final it = block as PageBlock<Category>;
        final items = products.isNotEmpty
            ? products
            : const [
                Product(
                  id: 1,
                  name: 'Product 1',
                  description: 'Description 1',
                  images: [
                    'http://localhost:8080/api/v1/image/100/80/Product1'
                  ],
                  price: '¥100.23',
                ),
                Product(
                  id: 2,
                  name: 'Product 2',
                  description: 'Description 2',
                  images: [
                    'http://localhost:8080/api/v1/image/100/80/Product2'
                  ],
                  price: '¥200.34',
                ),
                Product(
                  id: 3,
                  name: 'Product 3',
                  description: 'Description 3',
                  images: [
                    'http://localhost:8080/api/v1/image/100/80/Product3'
                  ],
                  price: '¥300.45',
                ),
                Product(
                  id: 4,
                  name: 'Product 4',
                  description: 'Description 4',
                  images: [
                    'http://localhost:8080/api/v1/image/100/80/Product4'
                  ],
                  price: '¥400.56',
                ),
              ];

        widget = WaterfallWidget(
          products: items,
          config: it.config,
          ratio: 1.0,
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
