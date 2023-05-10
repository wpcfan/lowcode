import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/page_block_widgets.dart';

import 'models/models.dart';

/// 中间画布
class CenterPane extends StatelessWidget {
  const CenterPane(
      {super.key,
      this.onTap,
      required this.blocks,
      required this.products,
      required this.defaultBlockConfig,
      required this.pageConfig,
      this.onBlockAdded,
      this.onBlockInserted,
      this.onBlockMoved,
      this.onBlockSelected});
  final void Function()? onTap;
  final List<PageBlock<dynamic>> blocks;
  final List<Product> products;
  final BlockConfig defaultBlockConfig;
  final PageConfig pageConfig;
  final void Function(PageBlock<dynamic> block)? onBlockAdded;
  final void Function(PageBlock<dynamic> block)? onBlockInserted;
  final void Function(PageBlock<dynamic> block, int targetSort)? onBlockMoved;
  final void Function(PageBlock<dynamic> block)? onBlockSelected;

  @override
  Widget build(BuildContext context) {
    // 整体作为左侧拖拽目标
    final dragTarget = DragTarget(
      builder: (context, candidateData, rejectedData) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return _buildListItem(index);
          },
          itemCount: blocks.length,
        );
      },
      onWillAccept: (data) {
        if (data is WidgetData && data.sort == null) {
          if (data.type == PageBlockType.waterfall &&
              blocks.indexWhere((el) => el.type == PageBlockType.waterfall) !=
                  -1) {
            /// 已有瀑布流不能拖拽
            return false;
          }
          return true;
        }
        return false;
      },
      onAccept: (WidgetData data) {
        _addBlock(data, blocks.length + 1);
      },
    );
    return dragTarget
        .gestures(onTap: onTap)
        .padding(
          horizontal: pageConfig.horizontalPadding ?? 0.0,
          vertical: pageConfig.verticalPadding ?? 0.0,
        )
        .backgroundColor(Colors.grey)
        .constrained(width: pageConfig.baselineScreenWidth ?? 375.0);
  }

  DragTarget<Object> _buildListItem(int index) {
    return DragTarget(
      builder: (context, candidateData, rejectedData) {
        final item = blocks[index];
        return _buildDraggableWidget(
            item, index, pageConfig.baselineScreenWidth ?? 375.0);
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

        /// 已经有瀑布流不能拖拽
        if (data is PageBlock && data.type != PageBlockType.waterfall) {
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
            return _insertBlock(data, dropIndex + 1);
          }
        }
        if (data is PageBlock) {
          /// 处理从画布中拖拽过来的
          onBlockMoved?.call(data, blocks[dropIndex].sort);
        }
      },
    );
  }

  void _insertBlock(WidgetData data, int dropIndex) {
    switch (data.type) {
      case PageBlockType.banner:
        return onBlockInserted?.call(
          PageBlock<ImageData>(
            type: PageBlockType.banner,
            title: 'Banner $dropIndex ',
            sort: dropIndex,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        );
      case PageBlockType.waterfall:
        return onBlockInserted?.call(
          PageBlock<Category>(
            type: PageBlockType.waterfall,
            title: 'Waterfall $dropIndex ',
            sort: dropIndex,
            config: defaultBlockConfig,
            data: const [],
          ),
        );
      case PageBlockType.imageRow:
        return onBlockInserted?.call(
          PageBlock<ImageData>(
            type: PageBlockType.imageRow,
            title: 'ImageRow $dropIndex',
            sort: dropIndex,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        );
      case PageBlockType.productRow:
        return onBlockInserted?.call(
          PageBlock<Product>(
            type: PageBlockType.productRow,
            title: 'ProductRow $dropIndex ',
            sort: dropIndex,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        );
      default:
        return;
    }
  }

  void _addBlock(WidgetData data, int dropIndex) {
    switch (data.type) {
      case PageBlockType.banner:
        return onBlockAdded?.call(
          PageBlock<ImageData>(
            type: PageBlockType.banner,
            title: 'Banner $dropIndex ',
            sort: dropIndex,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        );
      case PageBlockType.waterfall:
        return onBlockAdded?.call(
          PageBlock<Category>(
            type: PageBlockType.waterfall,
            title: 'Waterfall $dropIndex',
            sort: dropIndex,
            config: defaultBlockConfig,
            data: const [],
          ),
        );
      case PageBlockType.imageRow:
        return onBlockAdded?.call(
          PageBlock<ImageData>(
            type: PageBlockType.imageRow,
            title: 'ImageRow $dropIndex',
            sort: dropIndex,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        );
      case PageBlockType.productRow:
        return onBlockAdded?.call(
          PageBlock<Product>(
            type: PageBlockType.productRow,
            title: 'ProductRow $dropIndex',
            sort: dropIndex,
            config: defaultBlockConfig.copyWith(blockHeight: 100),
            data: const [],
          ),
        );
      default:
        return;
    }
  }

  Widget _buildDraggableWidget(PageBlock block, int index, double itemWidth) {
    final config = block.config;
    page({required Widget child}) => Draggable(
          data: block,
          feedback: SizedBox(
            width: itemWidth,
            child: Opacity(opacity: 0.5, child: child),
          ),
          child: SizedBox(
            width: itemWidth,
            child: Container(
              color: Colors.black45,
              child: child,
            ),
          ),
        );

    Widget child;
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
        child = BannerWidget(
          items: items,
          config: config,
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
        child = ImageRowWidget(
          items: items,
          config: config,
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
        child = ProductRowWidget(
          items: items,
          config: config,
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

        child = WaterfallWidget(
          products: items,
          config: config,
          isPreview: true,
        );
        break;
      default:
        return Container();
    }

    return page(child: IgnorePointer(child: child)).gestures(
        behavior: HitTestBehavior.opaque,
        onTap: () => onBlockSelected?.call(block));
  }
}
