part of 'product_row.dart';

class ProductCardOneRowOneWidget extends StatelessWidget {
  const ProductCardOneRowOneWidget({
    super.key,
    required this.data,
    required this.width,
    required this.height,
    this.addToCart,
    this.onTap,
  });
  final ProductData data;
  final double width;
  final double height;
  final void Function()? addToCart;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final imageHeight = height - 2 * listHorizontalPadding;
    const double spaceVertical = 4;
    page({required Widget child}) => Styled.widget(child: child)
        .padding(
            horizontal: listHorizontalPadding, vertical: listVerticalPadding)
        .constrained(maxWidth: width, maxHeight: height)
        .backgroundColor(Colors.white)
        .border(all: 1, color: Colors.grey);
    // 商品名称
    final productName = Text(
      data.product.name ?? '',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
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
        fontSize: 14,
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
        ? data.product.price
            .toString()
            .lineThru()
            .padding(bottom: spaceVertical, right: 8)
            .alignment(Alignment.centerRight)
        : null;
    // 商品价格
    final productPrice = discount != null &&
            discount.type == DiscountType.discount &&
            (discount as DiscountPromotion).discount?.formatted != null
        ? discount.discount?.formatted!
            .toPriceWithDecimalSize(defaultFontSize: 16, decimalFontSize: 12)
            .padding(bottom: spaceVertical, right: 8)
            .alignment(Alignment.centerRight)
        : null;
    // 购物车图标
    const double buttonSize = 30.0;
    final cartBtn = const Icon(Icons.add_shopping_cart, color: Colors.white)
        .rounded(size: buttonSize, color: Colors.red)
        .gestures(onTap: addToCart);

    final priceRow = [
      productOriginalPrice,
      productPrice,
      IgnorePointer(ignoring: addToCart == null, child: cartBtn)
    ].whereType<Widget>().toList().toRow(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
        );

    // 商品名称和描述形成一列
    final nameAndDescColumn = <Widget>[
      productName,
      productDescription,
    ].toColumn(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start);
    // 商品名称和描述和价格形成一列，价格需要沉底，所以使用Expanded
    final right = [nameAndDescColumn, priceRow]
        .toColumn(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start)
        .padding(right: screenHorizontalPadding)
        .expanded();
    // 商品图片
    final productImage = ImageWidget(
      image: data.product.images.first,
      width: imageHeight,
      height: imageHeight,
    ).padding(right: listHorizontalPadding);
    // 商品图片和右边的名称和描述和价格形成一行
    return [productImage, right]
        .toRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start)
        .parent(page)
        .gestures(onTap: onTap);
  }
}
