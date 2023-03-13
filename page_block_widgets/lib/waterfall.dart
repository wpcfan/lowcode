import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:models/models.dart';
import 'package:page_block_widgets/product_row.dart';

class WaterfallWidget extends StatelessWidget {
  const WaterfallWidget({
    super.key,
    required this.config,
    required this.products,
    required this.errorImage,
    required this.ratio,
    this.addToCart,
    this.onTap,
    this.isPreview = false,
  });
  final BlockConfig config;
  final List<Product> products;
  final String errorImage;
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
