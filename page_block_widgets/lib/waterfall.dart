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
  });
  final BlockConfig config;
  final List<Product> products;
  final String errorImage;
  final double ratio;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTap;

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = (config.horizontalPadding ?? 0) / ratio;
    final verticalPadding = (config.verticalPadding ?? 0) / ratio;
    final horizontalSpacing = (config.horizontalSpacing ?? 0) / ratio;
    final verticalSpacing = (config.verticalSpacing ?? 0) / ratio;
    final blockWidth = (config.blockWidth ?? 0) / ratio;
    final itemWidth = (blockWidth - 2 * horizontalPadding) / 2;
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
            horizontalSpacing: horizontalSpacing,
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
