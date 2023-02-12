part of 'product_row.dart';

class ProductCardOneRowTwoWidget extends StatelessWidget {
  const ProductCardOneRowTwoWidget({
    super.key,
    required this.data,
    required this.width,
    this.addToCart,
    this.onTap,
  });
  final ProductData data;
  final double width;
  final void Function()? addToCart;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    const double spaceVertical = 4;
    page({required Widget child}) => Styled.widget(child: child)
        .padding(
          horizontal: listHorizontalPadding,
          vertical: listVerticalPadding,
        )
        .constrained(maxWidth: width)
        .backgroundColor(Colors.white)
        .border(all: 1, color: Colors.grey);
    // 商品名称
    final productName = Text(
      data.product.name ?? '',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black87,
      ),
      softWrap: true,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ).padding(bottom: spaceVertical);
    // 商品描述
    final productDescription = Text(
      data.product.description ?? '',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black54,
      ),
      softWrap: true,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ).padding(bottom: spaceVertical);

    final discounts = data.product.discounts ?? [];
    final discount = discounts.isNotEmpty
        ? discounts.firstWhere(
            (el) => el.isApplied,
            orElse: () => discounts.first,
          )
        : null;

    // 商品原价：划线价
    final productOriginalPrice = data.product.price != null &&
            discount != null &&
            discount.type == DiscountType.discount &&
            (discount as DiscountPromotion).discount?.amount != null &&
            discount.discount?.amount != data.product.price
        ? data.product.price!
            .toString()
            .lineThru()
            .padding(bottom: spaceVertical)
        : null;
    // 商品价格
    final productPrice = discount != null &&
            discount.type == DiscountType.discount &&
            (discount as DiscountPromotion).discount?.formatted != null
        ? discount.discount?.formatted!
            .toPriceWithDecimalSize(defaultFontSize: 14, decimalFontSize: 10)
        : null;
    // 购物车图标
    const double buttonSize = 30.0;
    final cartBtn = const Icon(Icons.add_shopping_cart, color: Colors.white)
        .rounded(size: buttonSize, color: Colors.red)
        .gestures(onTap: addToCart);
    // 商品图片
    final productImage = ImageWidget(
      image: data.product.images.first,
      width: width - listHorizontalPadding * 2,
      height: width - listVerticalPadding * 2,
    ).padding(
      bottom: spaceVertical,
    );
    // 商品图片、名称和描述形成一列
    final imageNameAndDesc = <Widget>[
      productImage,
      productName,
      productDescription,
    ].toColumn(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start);
    // 商品价格和划线价格形成一列
    final priceColumn = [productOriginalPrice, productPrice]
        .whereType<Widget>()
        .toList()
        .toColumn(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
        );
    // 商品价格和划线价格和购物车图标形成一行
    final priceRow = [
      priceColumn,
      IgnorePointer(ignoring: addToCart == null, child: cartBtn)
    ].toRow(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
    );
    final nameDescAndPrice = [imageNameAndDesc, priceRow].toColumn(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start);

    return nameDescAndPrice.parent(page).gestures(onTap: onTap);
  }
}
