part of 'product_row.dart';

class ProductCardOneRowOneWidget extends StatelessWidget {
  const ProductCardOneRowOneWidget({
    super.key,
    required this.product,
    required this.width,
    required this.height,
    required this.horizontalSpacing,
    required this.verticalSpacing,
    this.errorImage,
    this.backgroundColor = Colors.white,
    this.borderColor = Colors.grey,
    this.borderWidth = 1.0,
    this.addToCart,
    this.onTap,
  });
  final Product product;
  final double width;
  final double height;
  final double horizontalSpacing;
  final double verticalSpacing;
  final String? errorImage;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTap;

  @override
  Widget build(BuildContext context) {
    // 商品名称
    final productName = Text(
      product.name ?? '',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
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
        fontSize: 14,
        color: Colors.black54,
      ),
      softWrap: true,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    ).padding(bottom: verticalSpacing);

    // 商品原价：划线价
    final productOriginalPrice = product.originalPrice != null
        ? product.originalPrice!
            .lineThru()
            .padding(bottom: verticalSpacing, right: horizontalSpacing)
            .alignment(Alignment.centerRight)
        : null;
    // 商品价格
    final productPrice = product.price != null
        ? product.price!
            .toPriceWithDecimalSize(defaultFontSize: 16, decimalFontSize: 12)
            .padding(right: horizontalSpacing)
            .alignment(Alignment.centerRight)
        : null;

    // 购物车图标
    const double buttonSize = 24.0;
    final cartBtn = const Icon(Icons.add_shopping_cart, color: Colors.white)
        .rounded(size: buttonSize, color: Colors.red)
        .gestures(onTap: () => addToCart?.call(product));

    final priceRow = [
      productOriginalPrice,
      productPrice,

      /// 如果addToCart为null，则忽略点击事件
      IgnorePointer(ignoring: addToCart == null, child: cartBtn)
    ]

        /// 过滤掉null, whereType<T>()返回的是一个Iterable<T>
        /// toList()将Iterable<T>转换为List<T>
        /// toRow()将List<T>转换为Row
        .whereType<Widget>()
        .toList()
        .toRow(
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
    );
    // 商品名称和描述和价格形成一列，价格需要沉底，所以使用Expanded
    final right = [nameAndDescColumn, priceRow]
        .toColumn(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
        )
        .padding(right: horizontalSpacing)
        .expanded();
    // 商品图片
    final productImage = ImageWidget(
      imageUrl: product.images.first,
      width: height - 2 * borderWidth,
      height: height - 2 * borderWidth,
      errorImage: errorImage,
      onTap: onTap != null ? (link) => onTap!(product) : null,
    ).padding(right: horizontalSpacing);
    // 商品图片和右边的名称和描述和价格形成一行
    return [productImage, right]
        .toRow(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
        )
        .gestures(onTap: () => onTap?.call(product));
  }
}
