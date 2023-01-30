import 'package:common/config.dart';
import 'package:common/extensions/all.dart';
import 'package:common/models/all.dart';
import 'package:common/widgets/swift_ui.dart';
import 'package:flutter/material.dart';

import 'image_widget.dart';

part 'product_card_one_row_one.dart';
part 'product_card_one_row_two.dart';

class ProductRowWidget extends StatelessWidget {
  const ProductRowWidget({super.key, required this.pageBlock});
  final ProductRowPageBlock pageBlock;

  @override
  Widget build(BuildContext context) {
    if (pageBlock.data.isEmpty) {
      return const SizedBox();
    }
    final aspectRatio = pageBlock.width! / pageBlock.height!;
    final width =
        MediaQuery.of(context).size.width - screenHorizontalPadding * 2;
    final height = (width / aspectRatio).ceilToDouble();

    if (pageBlock.data.length == 1) {
      final oneRowOne = SizedBox(
          height: height + 2 * spaceBetweenListItems,
          child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: screenHorizontalPadding,
                vertical: spaceBetweenListItems,
              ),
              child: ProductCardOneRowOneWidget(
                data: pageBlock.data.first,
                width: width,
                height: height,
                onTap: () =>
                    debugPrint('on tap ${pageBlock.data.first.product.id}'),
              )));
      return oneRowOne;
    }
    final oneRowTwo = IntrinsicHeight(
      child: pageBlock.data
          .take(2)
          .map((el) {
            return ProductCardOneRowTwoWidget(
              data: el,
              width: (width - spaceBetweenListItems) / 2,
              onTap: () => debugPrint('on tap ${el.product.id}'),
            );
          })
          .toList()
          .toRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start)
          .padding(
              horizontal: screenHorizontalPadding,
              vertical: spaceBetweenListItems / 2),
    );
    return oneRowTwo;
  }
}
