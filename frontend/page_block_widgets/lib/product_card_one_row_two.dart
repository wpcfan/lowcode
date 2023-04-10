part of 'product_row.dart';

class ProductCardOneRowTwoWidget extends StatelessWidget {
  const ProductCardOneRowTwoWidget({
    super.key,
    required this.product,
    required this.itemWidth,
    this.itemHeight,
    required this.verticalSpacing,
    this.errorImage,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.addToCart,
    this.onTap,
  });
  final Product product;
  final double itemWidth;
  final double? itemHeight;
  final double verticalSpacing;
  final String? errorImage;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTap;

  @override
  Widget build(BuildContext context) {
    page({required Widget child}) => child
        .padding(all: 6)
        .decorated(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
            strokeAlign: BorderSide.strokeAlignOutside,
          ),
        )
        .constrained(width: itemWidth);
    // 商品名称
    final productName = Text(
      product.name ?? '',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 14,
        color: Colors.black87,
      ),
      softWrap: true,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ).padding(bottom: verticalSpacing);
    // 商品描述
    final productDescription = Text(
      product.description ?? '',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black54,
      ),
      softWrap: true,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ).padding(bottom: verticalSpacing);

    // 商品原价：划线价
    final productOriginalPrice = product.originalPrice != null
        ? product.originalPrice!
            .toString()
            .lineThru()
            .padding(bottom: verticalSpacing)
        : null;
    // 商品价格
    final productPrice = product.price != null
        ? product.price!
            .toPriceWithDecimalSize(defaultFontSize: 14, decimalFontSize: 10)
        : null;
    // 购物车图标
    const double buttonSize = 30.0;
    final cartBtn = const Icon(Icons.add_shopping_cart, color: Colors.white)
        .rounded(size: buttonSize, color: Colors.red)
        .gestures(onTap: () => addToCart?.call(product));
    // 商品图片
    final productImage = ImageWidget(
      imageUrl: product.images.first,
      width: itemWidth - 2 * borderWidth,
      height: itemWidth - 2 * borderWidth,
      errorImage: errorImage,
      onTap: onTap != null ? (link) => onTap!(product) : null,
    );
    // 商品图片、名称和描述形成一列
    final imageNameAndDesc = <Widget>[
      productImage,
      productName,
      productDescription,
    ].toColumn(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start);

    return nameDescAndPrice
        .parent(page)
        .gestures(onTap: () => onTap?.call(product));
  }
}
