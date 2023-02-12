import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

import 'image.dart';

part 'product_card_one_row_one.dart';
part 'product_card_one_row_two.dart';

class ProductRowWidget extends StatelessWidget {
  const ProductRowWidget({
    super.key,
    required this.data,
    required this.horizontalPadding,
    required this.verticalPadding,
    required this.width,
    required this.height,
    required this.errorImage,
    required this.config,
    required this.ratio,
    this.addToCart,
    this.onTap,
  }) : assert(data.length <= 2 && data.length > 0);
  final List<ProductData> data;
  final double horizontalPadding;
  final double verticalPadding;
  final double width;
  final double height;
  final String errorImage;
  final BlockConfig config;
  final double ratio;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTap;

  @override
  Widget build(BuildContext context) {
    page({required Widget child}) => SwiftUi.widget(child: child)
        .padding(horizontal: horizontalPadding, vertical: verticalPadding)
        .constrained(maxWidth: width, maxHeight: height)
        .backgroundColor(Colors.white)
        .border(all: 1, color: Colors.grey);

    switch (data.length) {
      case 1:
        final product = data.first.product;

        return ProductCardOneRowOneWidget(
          product: data[0].product,
          width: width,
          height: height,
          horizontalPadding: (config.horizontalPadding ?? 0) * ratio,
          verticalPadding: (config.verticalPadding ?? 0) * ratio,
          horizontalSpacing: (config.horizontalSpacing ?? 0) * ratio,
          verticalSpacing: (config.verticalSpacing ?? 0) * ratio,
          errorImage: errorImage,
          onTap: onTap,
          addToCart: addToCart,
        ).parent(page);
      case 2:
        return data
            .map((e) => e.product)
            .map((product) => ProductCardOneRowTwoWidget(
                  product: product,
                  width: width / 2 - (config.horizontalPadding ?? 0) * ratio,
                  height: height - 2 * (config.verticalPadding ?? 0) * ratio,
                  horizontalSpacing: (config.horizontalSpacing ?? 0) * ratio,
                  verticalSpacing: (config.verticalSpacing ?? 0) * ratio,
                  errorImage: errorImage,
                  onTap: onTap,
                  addToCart: addToCart,
                ))
            .toList()
            .toRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
            )
            .parent(page);
      default:
        return Container();
    }
  }
}
