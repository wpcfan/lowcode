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
    final horizontalSpacing = (config.horizontalSpacing ?? 0) / ratio;
    final verticalSpacing = (config.verticalSpacing ?? 0) / ratio;
    final itemWidth = (config.itemWidth ?? 0) / ratio;
    final itemHeight = (config.itemHeight ?? 0) / ratio;
    return SliverMasonryGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: horizontalSpacing,
      crossAxisSpacing: verticalSpacing,
      childCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCardOneRowTwoWidget(
          product: product,
          itemHeight: itemWidth,
          itemWidth: itemHeight,
          horizontalSpacing: horizontalSpacing,
          verticalSpacing: verticalSpacing,
          errorImage: errorImage,
          addToCart: addToCart,
          onTap: onTap,
        );
      },
    );
  }
}
