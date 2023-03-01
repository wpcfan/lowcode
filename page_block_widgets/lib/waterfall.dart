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
    final horizontalPadding = (config.horizontalPadding ?? 0) / ratio;
    final verticalPadding = (config.verticalPadding ?? 0) / ratio;
    final horizontalSpacing = (config.horizontalSpacing ?? 0) / ratio;
    final verticalSpacing = (config.verticalSpacing ?? 0) / ratio;
    final blockWidth = (config.blockWidth ?? 0) / ratio;
    final itemWidth = (blockWidth) / 2;
    return isPreview
        ? _buildPreview(horizontalPadding, verticalPadding, horizontalSpacing,
            verticalSpacing, itemWidth)
        : _buildContent(horizontalPadding, verticalPadding, horizontalSpacing,
            verticalSpacing, itemWidth);
  }

  Widget _buildPreview(double horizontalPadding, double verticalPadding,
      double horizontalSpacing, double verticalSpacing, double itemWidth) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 200.0 * products.length / 2,
        maxHeight: 300.0 * products.length / 2,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: MasonryGridView.count(
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
            );
          },
          itemCount: products.length,
        ),
      ),
    );
  }

  SliverPadding _buildContent(double horizontalPadding, double verticalPadding,
      double horizontalSpacing, double verticalSpacing, double itemWidth) {
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
          );
        },
      ),
    );
  }
}
