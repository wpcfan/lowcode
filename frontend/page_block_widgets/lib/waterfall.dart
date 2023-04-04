import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/product_row.dart';

/// 瀑布流组件
/// 用于展示商品列表
/// 会根据商品的宽高比来自动计算高度
/// 以适应不同的屏幕
/// 可以通过 [BlockConfig] 参数来指定区块的宽度、高度、内边距、外边距等
/// 可以通过 [Product] 参数来指定商品列表
/// 可以通过 [addToCart] 参数来指定点击添加到购物车按钮时的回调
/// 可以通过 [onTap] 参数来指定点击商品卡片时的回调
class WaterfallWidget extends StatelessWidget {
  const WaterfallWidget({
    super.key,
    required this.config,
    required this.products,
    required this.ratio,
    this.errorImage,
    this.addToCart,
    this.onTap,
    this.isPreview = false,
  });
  final BlockConfig config;
  final List<Product> products;
  final String? errorImage;
  final double ratio;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTap;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = config.backgroundColor != null
        ? config.backgroundColor!
        : Colors.transparent;
    final borderColor =
        config.borderColor != null ? config.borderColor! : Colors.transparent;
    final borderWidth = config.borderWidth ?? 0.0;
    final horizontalPadding = (config.horizontalPadding ?? 0) / ratio;
    final verticalPadding = (config.verticalPadding ?? 0) / ratio;
    final horizontalSpacing = (config.horizontalSpacing ?? 0) / ratio;
    final verticalSpacing = (config.verticalSpacing ?? 0) / ratio;
    final blockWidth = (config.blockWidth ?? 0) / ratio;
    final itemWidth = (blockWidth) / 2;
    return isPreview
        ? _buildPreview(
            horizontalPadding,
            verticalPadding,
            horizontalSpacing,
            verticalSpacing,
            itemWidth,
            backgroundColor,
            borderColor,
            borderWidth)
        : _buildContent(
            horizontalPadding,
            verticalPadding,
            horizontalSpacing,
            verticalSpacing,
            itemWidth,
            backgroundColor,
            borderColor,
            borderWidth);
  }

  Widget _buildPreview(
      double horizontalPadding,
      double verticalPadding,
      double horizontalSpacing,
      double verticalSpacing,
      double itemWidth,
      Color backgroundColor,
      Color borderColor,
      double borderWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: MasonryGridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: horizontalSpacing,
        crossAxisSpacing: verticalSpacing,
        itemBuilder: (context, index) {
          return ProductCardOneRowTwoWidget(
            product: products[index],
            itemWidth: itemWidth,
            verticalSpacing: verticalSpacing,
            errorImage: errorImage,
            addToCart: addToCart,
            onTap: onTap,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
          );
        },
        itemCount: products.length,
      ),
    );
  }

  SliverPadding _buildContent(
      double horizontalPadding,
      double verticalPadding,
      double horizontalSpacing,
      double verticalSpacing,
      double itemWidth,
      Color backgroundColor,
      Color borderColor,
      double borderWidth) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 2,
        mainAxisSpacing: horizontalSpacing,
        crossAxisSpacing: verticalSpacing,
        childCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCardOneRowTwoWidget(
            product: product,
            itemWidth: itemWidth,
            verticalSpacing: verticalSpacing,
            errorImage: errorImage,
            addToCart: addToCart,
            onTap: onTap,
            backgroundColor: backgroundColor,
            borderColor: borderColor,
            borderWidth: borderWidth,
          );
        },
      ),
    );
  }
}
