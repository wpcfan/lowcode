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
    this.addToCart,
    this.onTap,
  });
  final BlockConfig config;
  final List<Product> products;
  final String errorImage;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTap;

  @override
  Widget build(BuildContext context) {
    return SliverMasonryGrid.count(
      crossAxisCount: 2,
      mainAxisSpacing: config.horizontalSpacing ?? 0,
      crossAxisSpacing: config.verticalSpacing ?? 0,
      childCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCardOneRowTwoWidget(
          product: product,
          height: config.itemHeight ?? 0,
          width: config.itemWidth ?? 0,
          horizontalSpacing: config.horizontalSpacing ?? 0,
          verticalSpacing: config.verticalSpacing ?? 0,
          errorImage: errorImage,
          addToCart: addToCart,
          onTap: onTap,
        );
      },
    );
  }
}
