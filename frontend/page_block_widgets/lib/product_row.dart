import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'image.dart';

part 'product_card_one_row_one.dart';
part 'product_card_one_row_two.dart';

class ProductRowWidget extends StatelessWidget {
  /// assert 关键字用于断言，当条件不满足时，抛出异常
  /// assert(items.length <= 2 && items.length > 0);
  /// 1. items.length <= 2 表示 items 的长度必须小于等于 2
  /// 2. items.length > 0 表示 items 的长度必须大于 0
  const ProductRowWidget({
    super.key,
    required this.items,
    required this.errorImage,
    required this.config,
    required this.ratio,
    this.addToCart,
    this.onTap,
  }) : assert(items.length <= 2 && items.length > 0);
  final List<Product> items;
  final String errorImage;
  final BlockConfig config;
  final double ratio;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = config.backgroundColor != null
        ? config.backgroundColor!
        : Colors.transparent;
    final borderColor =
        config.borderColor != null ? config.borderColor! : Colors.transparent;
    final borderWidth = config.borderWidth ?? 0.0;
    final width = (config.blockWidth ?? 0) / ratio;
    final height = (config.blockHeight ?? 0) / ratio;
    final horizontalPadding = (config.horizontalPadding ?? 0) / ratio;
    final verticalPadding = (config.verticalPadding ?? 0) / ratio;
    final horizontalSpacing = (config.horizontalSpacing ?? 0) / ratio;
    final verticalSpacing = (config.verticalSpacing ?? 0) / ratio;

    /// 将 Widget 包裹在 Page 中
    /// 注意到 page 其实是一个方法，接受一个 Widget 作为参数，返回一个 Widget
    /// 通过这种方式，我们可以在 page 中对 Widget 进行一些处理，比如添加边框、背景色等
    /// 这样我们可以专注于 Widget 的内容，而不用关心 Widget 的样式
    page({required Widget child}) => SwiftUi.widget(child: child)
        .padding(horizontal: horizontalPadding, vertical: verticalPadding)
        .decorated(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        )
        .constrained(maxWidth: width, maxHeight: height);

    switch (items.length) {
      case 1:
        final product = items.first;
        return ProductCardOneRowOneWidget(
          product: product,
          width: width - 2 * horizontalPadding,
          height: height - 2 * verticalPadding,
          horizontalSpacing: horizontalSpacing,
          verticalSpacing: verticalSpacing,
          errorImage: errorImage,
          onTap: onTap,
          addToCart: addToCart,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
        ).parent(page);
      default:
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final product = items[index];
              return ProductCardOneRowTwoWidget(
                product: product,
                itemWidth: (width - horizontalSpacing) / 2,
                itemHeight: height - 2 * verticalPadding,
                verticalSpacing: verticalSpacing,
                errorImage: errorImage,
                onTap: onTap,
                addToCart: addToCart,
                backgroundColor: Colors.white,
                borderColor: Colors.grey,
                borderWidth: 1,
              ).padding(
                  right: index == items.length - 1 ? 0 : horizontalSpacing);
            }).parent(page);
    }
  }
}
