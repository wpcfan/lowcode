import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

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
    final cartBloc = context.read<CartBloc>();
    final messageCubit = context.read<MessageCubit>();
    wrapper(child) => BlocListener<CartBloc, CartState>(
        listener: (context, state) {
          if (state.addStatus == BlocStatus.success) {
            messageCubit.showMessage('Added to cart');
          } else if (state.loadStatus == BlocStatus.failure) {
            messageCubit.showMessage('Failed to add to cart');
          }
        },
        child: child);
    if (pageBlock.data.length == 1) {
      final product = pageBlock.data.first.product;
      final orderQuantity = product.orderQuantity;
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
                addToCart: () {
                  cartBloc.add(CartAddItemEvent(
                    product: product,
                    quantity: orderQuantity.min,
                  ));
                },
                onTap: () =>
                    debugPrint('on tap ${pageBlock.data.first.product.id}'),
              )));
      return wrapper(oneRowOne);
    }
    final oneRowTwo = IntrinsicHeight(
      child: pageBlock.data
          .take(2)
          .map((el) {
            final product = el.product;
            final orderQuantity = product.metadata != null
                ? OrderQuantity.fromJson(product.metadata!['order_quantity'])
                : OrderQuantity();
            return ProductCardOneRowTwoWidget(
              data: el,
              width: (width - spaceBetweenListItems) / 2,
              addToCart: () => cartBloc.add(CartAddItemEvent(
                product: product,
                quantity: orderQuantity.min,
              )),
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
    return wrapper(oneRowTwo);
  }
}
