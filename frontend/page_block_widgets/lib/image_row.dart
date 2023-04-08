import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

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
    this.errorImage,
    this.numOfDisplayed = 3,
    this.onTap,
  });
  final List<ImageData> items;
  final BlockConfig config;
  final double ratio;
  final String? errorImage;
  final int numOfDisplayed;

  final void Function(MyLink?)? onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = config.backgroundColor != null
        ? config.backgroundColor!
        : Colors.transparent;
    final borderColor =
        config.borderColor != null ? config.borderColor! : Colors.transparent;
    final borderWidth = config.borderWidth ?? 0.0;
    final horizontalSpacing = (config.horizontalSpacing ?? 0.0) * ratio;
    final scaledPaddingHorizontal = (config.horizontalPadding ?? 0.0) * ratio;
    final scaledPaddingVertical = (config.verticalPadding ?? 0.0) * ratio;

    final imageWidth = ((config.blockWidth ?? 0.0) -
            2 * scaledPaddingHorizontal -
            (items.length - 1) * horizontalSpacing) /
        (items.length > numOfDisplayed
            ?

            /// 以 List 显示的时候需要露出30%下一张图片的内容
            (numOfDisplayed + 0.3)

            /// 其它情况下，图片数量就是显示的数量

            : items.length);
    final blockWidth = (config.blockWidth ?? 0.0) * ratio;
    final blockHeight = (config.blockHeight ?? 0.0) * ratio;
    final imageHeight = blockHeight - 2 * scaledPaddingVertical;

    /// 构建外层容器，包含背景色、边框、内边距
    /// 用于控制整个组件的大小
    /// 以及控制组件的背景色、边框
    /// 注意这是一个函数，一般我们构建完内层组件后，会调用它来构建外层组件
    /// 使用上，内层如果是 child，那么可以通过 child.parent(page) 来构建外层
    page({required Widget child}) => child
        .padding(
            horizontal: scaledPaddingHorizontal,
            vertical: scaledPaddingVertical)
        .decorated(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        )
        .constrained(width: blockWidth, height: blockHeight);

    /// 构建图片组件
    Widget buildImageWidget(ImageData imageData) => Image.network(
          imageData.image,
          width: imageWidth,
          height: imageHeight,
          fit: BoxFit.cover,
        ).gestures(onTap: () => onTap?.call(imageData.link));

    /// 如果没有图片，那么直接返回一个占位符
    if (items.isEmpty) {
      return page(child: const Placeholder()).parent(page);
    }

    /// 如果图片数量大于 3，那么使用横向滚动的方式展示
    if (items.length > numOfDisplayed) {
      return ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          itemBuilder: (context, index) => buildImageWidget(items[index]),
          separatorBuilder: (BuildContext context, int index) =>
              SizedBox(width: horizontalSpacing)).parent(page);
    }

    /// 如果图片数量小于等于 3，那么使用 Row 的方式展示
    return items
        .map((e) {
          final isLast = items.last == e;
          return [
            buildImageWidget(e),
            if (!isLast) SizedBox(width: horizontalSpacing),
          ];
        })
        .expand((element) => element)
        .toList()
        .toRow()
        .parent(page);
  }
}
