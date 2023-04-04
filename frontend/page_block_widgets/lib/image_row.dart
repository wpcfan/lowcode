import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'image.dart';

/// 图片行组件
/// 用于展示一行图片
/// 一行图片的数量可以是 1、2、3、或更多
/// 当数量为 1 时，图片会铺满整行
/// 当数量为 2 或 3 时，图片会平分整行
/// 当数量大于 3 时，图片会以横向滚动的方式展示
class ImageRowWidget extends StatelessWidget {
  const ImageRowWidget({
    super.key,
    required this.items,
    required this.config,
    required this.ratio,
    required this.errorImage,
    this.onTap,
  });
  final List<ImageData> items;
  final BlockConfig config;
  final double ratio;
  final String errorImage;

  final void Function(MyLink?)? onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = config.backgroundColor != null
        ? config.backgroundColor!
        : Colors.transparent;
    final borderColor =
        config.borderColor != null ? config.borderColor! : Colors.transparent;
    final borderWidth = config.borderWidth ?? 0.0;
    final blockWidth = (config.blockWidth ?? 0) / ratio;
    final blockHeight = (config.blockHeight ?? 0) / ratio;
    final horizontalPadding = (config.horizontalPadding ?? 0) / ratio;
    final verticalPadding = (config.verticalPadding ?? 0) / ratio;
    final itemWidth = blockWidth - horizontalPadding * 2;
    final itemHeight = blockHeight - verticalPadding * 2;

    /// 构建外层容器，包含背景色、边框、内边距
    /// 用于控制整个组件的大小
    /// 以及控制组件的背景色、边框
    /// 注意这是一个函数，一般我们构建完内层组件后，会调用它来构建外层组件
    /// 使用上，内层如果是 child，那么可以通过 child.parent(page) 来构建外层
    page({required Widget child}) => child
        .padding(horizontal: horizontalPadding, vertical: verticalPadding)
        .decorated(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        )
        .constrained(maxWidth: blockWidth, maxHeight: blockHeight);
    switch (items.length) {
      case 0: // Empty
        return page(child: const Placeholder());
      case 1:
      case 2:
      case 3:
        return _buildRow(context, itemWidth, itemHeight).parent(page);
      default:
        return _buildList(context, itemWidth, itemHeight).parent(page);
    }
  }

  Widget _buildRow(BuildContext context, double width, double itemHeight) {
    final spaceBetweenItems = (config.horizontalSpacing ?? 0) / ratio;
    return items
        .map((e) {
          final isLast = items.last == e;
          return [
            ImageWidget(
              imageUrl: e.image,
              errorImage: errorImage,
              width: width,
              height: itemHeight,
              link: e.link,
              onTap: onTap,
            ).expanded(),
            if (!isLast) SizedBox(width: spaceBetweenItems),
          ];
        })
        .expand((element) => element)
        .toList()
        .toRow();
  }

  Widget _buildList(
      BuildContext context, double blockWidth, double itemHeight) {
    final itemWidth = blockWidth / 3;
    final spaceBetweenItems = (config.horizontalSpacing ?? 0) / ratio;
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ImageWidget(
          imageUrl: item.image,
          errorImage: errorImage,
          width: itemWidth,
          height: itemHeight,
          link: item.link,
          onTap: onTap,
        );
      },
      separatorBuilder: (context, index) => SizedBox(width: spaceBetweenItems),
    );
  }
}
