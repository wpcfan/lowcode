import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'image.dart';

part 'product_card_one_row_one.dart';
part 'product_card_one_row_two.dart';

class ProductRowWidget extends StatelessWidget {
  const ProductRowWidget({
    super.key,
    required this.items,
    required this.errorImage,
    required this.config,
    required this.ratio,
    this.borderWidth = 1,
    this.borderColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.addToCart,
    this.onTap,
  }) : assert(items.length <= 2 && items.length > 0);
  final List<Product> items;
  final String errorImage;
  final BlockConfig config;
  final double ratio;
  final double borderWidth;
  final Color borderColor;
  final Color backgroundColor;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTap;

  @override
  Widget build(BuildContext context) {
    final width = (config.blockWidth ?? 0) / ratio;
    final height = (config.blockHeight ?? 0) / ratio;
    final horizontalPadding = (config.horizontalPadding ?? 0) / ratio;
    final verticalPadding = (config.verticalPadding ?? 0) / ratio;
    final horizontalSpacing = (config.horizontalSpacing ?? 0) / ratio;
    final verticalSpacing = (config.verticalSpacing ?? 0) / ratio;
    page({required Widget child}) => SwiftUi.widget(child: child)
        .padding(horizontal: horizontalPadding, vertical: verticalPadding)
        .constrained(maxWidth: width, maxHeight: height)
        .backgroundColor(backgroundColor)
        .border(all: borderWidth, color: borderColor);

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
        ).parent(page);
      case 2:
        return items
            .map((product) => ProductCardOneRowTwoWidget(
                  product: product,
                  itemWidth: (width - horizontalSpacing) / 2,
                  itemHeight: height - 2 * verticalPadding,
                  verticalSpacing: verticalSpacing,
                  errorImage: errorImage,
                  onTap: onTap,
                  addToCart: addToCart,
                ))
            .toList()
            .toRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
            )
            .parent(page);
      default:
        return Container();
    }
  }
}
