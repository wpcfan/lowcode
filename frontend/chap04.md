# 第四章：App 商品组件的实现

做了两个图片类型的组件之后，我们应该对于组件的实现有了一定的了解。现在我们来实现一个商品组件，它的功能是展示商品的图片、名称、价格、购买按钮等信息。当然它在布局上更为复杂。

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [第四章：App 商品组件的实现](#第四章app-商品组件的实现)
  - [4.1 需求分析](#41-需求分析)
    - [4.1.1 一行一商品的卡片界面需求分析](#411-一行一商品的卡片界面需求分析)
    - [4.1.2 一行二商品的卡片界面需求分析](#412-一行二商品的卡片界面需求分析)
  - [4.2 领域模型](#42-领域模型)
  - [4.3 一行一商品组件的实现](#43-一行一商品组件的实现)
    - [4.3.1 左侧商品图片](#431-左侧商品图片)
    - [4.3.2 右侧商品名称和商品描述](#432-右侧商品名称和商品描述)
    - [4.3.3 商品价格的富文本展示](#433-商品价格的富文本展示)
    - [4.3.4 商品价格和购物车按钮](#434-商品价格和购物车按钮)
    - [4.3.5 一行一商品组件最后的整合](#435-一行一商品组件最后的整合)
    - [4.3.6 一行一商品组件的完整代码](#436-一行一商品组件的完整代码)
    - [4.3.7 验证](#437-验证)
      - [4.3.7.1 重构 `PageBlock` 领域对象以支持泛型](#4371-重构-pageblock-领域对象以支持泛型)
    - [4.3.7.2 商品行区块](#4372-商品行区块)
    - [4.3.7.3 使用假数据测试](#4373-使用假数据测试)
    - [4.3.8 挖掘隐性需求](#438-挖掘隐性需求)
  - [4.4 一行二商品组件的实现](#44-一行二商品组件的实现)

<!-- /code_chunk_output -->

## 4.1 需求分析

- 需求 1.1: 页面布局是由一个个区块组成的
  - 需求 1.1.1: 区块的定义就是一个包括内边距的矩形区域
  - 需求 1.1.5: 商品行可以放 1-2 个商品，注意这个需求也是一个假定的数量，每个公司根据运营需要不一定和我们课程一样的。单个商品的卡片样式和 2 个商品的卡片样式都由 UI 设计师提供。不提供配置卡片内的样式的能力。

![图 1](http://ngassets.twigcodes.com/6b63238f227846e3979b5feab0b675001546e08c1be30b77ac59b11dcc203ec6.png)

一行一个商品的卡片样式和两个商品的卡片样式是完全不一样的，所以为了简单起见，我们为它们分别创建两个组件。

### 4.1.1 一行一商品的卡片界面需求分析

对于这种较复杂的布局，建议先从设计图上找到一些规律，然后再去实现。从一行一的商品卡片的设计图上，我们可以发现:

- 它的布局首先从左到右可以分成两部分，图片和右边的信息区域。
- 图片区域的宽度和高度相等，是一个正方形。
- 右边的信息区域的宽度应该是整个区块的宽度减去图片区域的宽度和间距。
- 右边信息区域由上至下分为三行
  - 分别是商品名称、商品描述和商品价格及购买按钮。
  - 其中商品名称和商品描述的间距是固定的，商品价格和购买按钮的间距也是固定的。
  - 而商品价格和购买按钮是左右排列的，而且是右对齐的。
  - 所以右侧区域可以先分为上下两部分
    - 上面是商品名称和商品描述
    - 下面是商品价格和购买按钮。
    - 另外关注到一点是商品的价格是一个带有小数点的数字，而且小数点后面的数字的字体大小和之前的数字是不一样的。

当然以上的分析需要和 UI 设计师沟通，因为有些细节可能不一样，但是这些细节都是可以通过沟通解决的。但无论如何，就界面需求来讲，把一个复杂界面分解成一些简单的小部件，然后再组合起来，这是一个很好的思路。

接下来，我们需要画一个简单的示意图，来帮助我们理清思路。我们先画出一个商品卡片的示意图，卡片分为左右两部分，左边是一个正方形区域，右边是一个矩形区域。右边的矩形区域又分为上下两部分，上面是商品名称和商品描述，下面是商品价格和购买按钮。如下图所示:

![图 2](http://ngassets.twigcodes.com/17b44e5da7f087601c916391cb62f3dd73a39c2c0c3c5304d830d8622fca8fa4.png)

### 4.1.2 一行二商品的卡片界面需求分析

一行二的商品卡片的设计图和一行一的商品卡片的设计图有一些不同，我们来分析一下:

- 它的布局首先从左到右可以分成三部分，左边的商品卡片、中间的间距和右边的商品卡片。
- 左右两边的商品卡片布局完全一致。
- 中间的间距是一个固定的宽度的间距。
- 商品卡片是一个矩形区域，它的宽度是整个区块的宽度减去间距的一半。
- 单个的商品卡片内部也是有边距的。
- 单个商品卡片是由上至下分为四行
  - 分别是商品图片、商品名称、商品描述和商品价格及购买按钮。
  - 其中，图片和商品名称的间距是固定的，商品名称和商品描述的间距是固定的，商品价格和购买按钮的间距也是固定的。
  - 而商品价格和购买按钮是左右排列的，而且是分别对齐到左右两边的。
  - 其中商品价格的文字和一行一商品的效果类似，是一个带有小数点的数字，而且小数点后面的数字的字体大小和之前的数字是不一样的。
  - 商品图片的宽度和高度相等，是一个正方形。其宽度是整个区块的宽度减去间距的一半然后再减去单个商品卡片的内边距。

![图 3](http://ngassets.twigcodes.com/dd0eff5c038ac9b177530fe984333578ad3744e4fb3f0109a1efe1a28fbd7754.png)

## 4.2 领域模型

有了之前一章图片区块的经验，我们可以很快的把商品区块的领域模型设计出来。我们先来看一下商品区块的领域模型:

```dart
class Product {
  final String? name;
  final String? description;
  final String? price;
  final String? imageUrl;
}
```

商品区块的领域模型非常简单，只有四个属性，分别是商品名称、商品描述、商品价格和商品图片的 URL。这里我们把商品价格定义为字符串，因为商品价格是一个带有货币符号小数点的数字，所以我们把它定义为字符串类型。

我们目前只是根据可见的元素构建模型，但是如果更深入的思考一下，我们要问自己几个问题：

- 点击购买按钮后，我们需要将商品加入购物车，那么购物车的接口需要哪些数据？这些数据是否体现在商品的属性中？如果没有，应该添加到商品的属性中吗？
- 如果点击卡片，而不是点击购买按钮，我们需要有哪些响应动作？是跳转到商品详情页面吗？那么商品详情页面需要哪些数据？这些数据是否体现在商品的属性中？如果没有，应该添加到商品的属性中吗？

这些问题都是需要我们思考的，而且实际的开发中，我们需要和产品经理、UI 设计师、后端开发人员沟通，来确定这些问题的答案。

对于我们的课程来说，我们暂时需要考虑的应该是：不管是加到购物车，还是到商品详情，可能我们都需要有一个 `id` 属性，来标识商品。所以我们可以在商品的领域模型中添加一个 `id` 属性，如下所示:

```dart
class Product {
  final int? id;
  final String? name;
  final String? description;
  final String? price;
  final String? imageUrl;
}
```

但做过电商的同学应该知道，一般情况下，商品应该有一个唯一的 `sku` 属性，来标识商品的唯一性。但这个 `id` 和 `sku` 的区别是什么呢？`id` 往往是和数据库的主键相关联的，而 `sku` 是厂家为商城中的商品分配的一个唯一的编码。目前我们把它们都放在 `Product` 的领域模型中，以后我们再来讨论这个问题。

```dart
class Product {
  final int? id;
  final String? sku;
  final String? name;
  final String? description;
  final String? price;
  final String? imageUrl;
}
```

另外商品的图片往往是一个列表，因为一个商品可能有多张图片，所以我们可以把商品图片的 URL 改成一个列表:

```dart
class Product {
  final int? id;
  final String? sku;
  final String? name;
  final String? description;
  final String? price;
  final List<String>? images;
}
```

一般在 Flutter 的设计中，我们对于从 API 获得的数据模型，要写几个比较常用的方法，比如 `fromJson` 和 `toJson` 方法，用来将 JSON 数据转换成模型，或者将模型转换成 JSON 数据。这里我们也需要写这两个方法，来将 JSON 数据转换成模型，或者将模型转换成 JSON 数据。

```dart
class Product {
  const Product({
    this.id,
    this.sku,
    this.name,
    this.description,
    this.price,
    this.images = const [],
  });

  final int? id;
  final String? sku;
  final String? name;
  final String? description;
  final String? price;
  final List<String> images;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        images,
      ];

  Product copyWith({
    int? id,
    String? sku,
    String? name,
    String? description,
    String? price,
    List<String>? images,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, sku: $sku, name: $name, description: $description, price: $price, images: $images)';
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int?,
        sku: json['sku'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        price: json['price'] as String?,
        images: (json['images'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sku': sku,
        'name': name,
        'description': description,
        'price': price,
        'images': images,
      };
}
```

## 4.3 一行一商品组件的实现

首先，还是先把组件的框架搭起来，在 `page_block_widgets/lib` 下新建 `product_card_one_row_one.dart` :

```dart
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
    /// 在这里写组件的实现
  }
}
```

### 4.3.1 左侧商品图片

![图 4](http://ngassets.twigcodes.com/3ce43227c1a06082d9d5c4bd3403b748da9e870856d5b3cd9f6291629d97c6c2.png)

还是按我们之前的想法，一个复杂组件要拆分为多个小组件，从简单到复杂逐步来实现。第一步，我们定义左侧的图片组件，由于之前我们已经抽象了图片组件，所以直接使用就行了:

```dart
// 商品图片
final productImage = ImageWidget(
  imageUrl: product.images.first,
  width: itemWidth - 2 * borderWidth,
  height: itemWidth - 2 * borderWidth,
  errorImage: errorImage,
  onTap: onTap != null ? (link) => onTap!(product) : null,
);
```

### 4.3.2 右侧商品名称和商品描述

接下来我们来实现右侧的商品信息上面部分，包括商品名称、商品描述:

```dart
// 商品名称
final productName = Text(
  product.name ?? '',
  style: const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: Colors.black87,
  ),
).padding(bottom: verticalSpacing);
// 商品描述
final productDescription = Text(
  product.description ?? '',
  style: const TextStyle(
    fontSize: 14,
    color: Colors.black54,
  ),
).padding(bottom: verticalSpacing);
// 商品名称和描述形成一列
final nameAndDescColumn = <Widget>[
  productName,
  productDescription,
].toColumn(
  mainAxisAlignment: MainAxisAlignment.start,
  crossAxisAlignment: CrossAxisAlignment.start,
  mainAxisSize: MainAxisSize.min,
);
```

我们在上面代码中，把商品名称和商品描述形成了一列。接下来我们来实现商品价格和购物车按钮。

### 4.3.3 商品价格的富文本展示

第一步看商品价格，这个地方我们需要使用一个外部依赖包 `easy_rich_text` ，我们之前在第二章中让大家给 `common` 工程中添加了这个包，所以这里我们可以直接使用。这个包主要用来处理富文本的展示，详细用法可以参考 [easy_rich_text](https://pub.dev/packages/easy_rich_text) ，这里我们只是简单的使用一下。

我们要为 `String` 类型添加两个扩展方法

- `toEasyRichText`：将 `String` 转换为 `EasyRichText` 组件
- `toPriceWithDecimalSize`：将 `String` 转换为 `EasyRichText` 组件，同时设置小数点的字体大小，在内部使用了 `toEasyRichText` 方法。

我们把 `common` 工程中的 `string_extension.dart` 文件打开并添加 `toEasyRichText` 和 `toPriceWithDecimalSize` 方法:

```dart
extension StringExtension on String {
  /// 转换为 EasyRichText
  EasyRichText toEasyRichText({
    TextStyle? defaultStyle,
    List<EasyRichTextPattern>? patternList,
  }) =>
      EasyRichText(
        this,
        defaultStyle: defaultStyle,
        patternList: patternList,
      );

  /// 价格的富文本展示
  EasyRichText toPriceWithDecimalSize({
    double defaultFontSize = 14,
    double decimalFontSize = 12.0,
    String decimalSign = '.',
  }) {
    /// 默认样式
    final defaultStyle = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: defaultFontSize,
      color: Colors.red,
    );
    /// 按小数点分割
    final parts = split(decimalSign);
    /// 如果没有小数点，直接返回
    if (parts.length != 2) {
      return toEasyRichText(defaultStyle: defaultStyle, patternList: const []);
    }
    /// 如果有小数点，得到小数点前后的字符串
    final first = parts.first;
    final last = parts.last;
    return toEasyRichText(
      defaultStyle: defaultStyle,
      patternList: [
        EasyRichTextPattern(
          /// 匹配小数点前面的字符串
          targetString: first,
          matchWordBoundaries: false,
          style: TextStyle(
            fontSize: defaultFontSize,
          ),
        ),
        EasyRichTextPattern(
          /// 匹配小数点后面的字符串
          targetString: last,
          matchWordBoundaries: false,
          style: TextStyle(
            fontSize: decimalFontSize,
          ),
        ),
      ],
    );
  }
}
```

### 4.3.4 商品价格和购物车按钮

有了处理价格富文本的扩展方法，我们就可以在商品卡片中使用了:

```dart
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
    .gestures(onTap: () => addToCart?.call(product));

// 将价格和购物车按钮放在一行
final priceRow = [
  productPrice,
  cartBtn
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
```

这里注意一下，我们使用了 `product.price?.toPriceWithDecimalSize` ，这里使用了空安全的语法，因为 `product.price` 可能为 `null` ，所以我们需要使用 `?.` 运算符来判断 `product.price` 是否为 `null` ，如果不为 `null` ，则调用 `toPriceWithDecimalSize` 方法，否则返回 `null` 。所以我们在将价格和购物车按钮放在一行时，需要过滤掉 `null` 值，否则会报错。 `whereType<T>` 是一个常用技巧，可以过滤掉 `List` 中的 `null` 值，只保留 `T` 类型的值。

由于购物车需要一个圆形的背景，这也是一个常见的需求，所以我们在 `common` 工程中添加一个 `common/lib/extensions/icon_widget_extensions.dart` 文件，添加如下代码:

```dart
extension IconWidget<T extends Icon> on T {
  T copyWith({
    double? size,
    Color? color,
    String? semanticLabel,
    TextDirection? textDirection,
  }) =>
      Icon(
        icon,
        color: color ?? this.color,
        size: size ?? this.size,
        semanticLabel: semanticLabel ?? this.semanticLabel,
        textDirection: textDirection ?? this.textDirection,
      ) as T;

  T iconSize(double size) => this.copyWith(size: size);

  T iconColor(Color color) => this.copyWith(color: color);

  Widget rounded({
    required double size,
    Color? color,
    double? radius,
    double? borderWidth,
    Color? borderColor,
  }) =>
      constrained(width: size, height: size)
          .alignment(Alignment.center)
          .ripple()
          .decorated(
            color: color ?? Colors.transparent,
            borderRadius: BorderRadius.circular(size / 2),
            border: Border.all(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 0,
            ),
          )
          .clipRRect(all: size / 2);
}
```

然后购物车图标就可以这样写了:

```dart
final cartBtn = const Icon(Icons.add_shopping_cart, color: Colors.white)
    .rounded(size: buttonSize, color: Colors.red)
    .gestures(onTap: () => addToCart?.call(product));
```

### 4.3.5 一行一商品组件最后的整合

```dart
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
```

### 4.3.6 一行一商品组件的完整代码

现在我们已经完成了一行一商品组件的开发，下面是完整的代码:

```dart
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
```

### 4.3.7 验证

如果要验证我们还是需要构造一个 `JSON` 数据，我们重新审视一下 `PageBlock` 这个领域对象，之前我们的定义如下

```dart
class PageBlock {
  final BlockConfig config;
  final List<ImageData> data;

  PageBlock({
    required this.config,
    required this.data,
  });

  factory PageBlock.fromJson(Map<String, dynamic> json) {
    return PageBlock(
      config: BlockConfig.fromJson(json['config']),
      data: (json['data'] as List).map((e) => ImageData.fromJson(e)).toList(),
    );
  }
}
```

现在显然 `data` 不再是 `ImageData` 的集合，而是要兼容 `Product` 和 `ImageData`，所以我们需要修改一下 `PageBlock` 的定义。

#### 4.3.7.1 重构 `PageBlock` 领域对象以支持泛型

我们需要引入泛型的概念，这样我们就可以定义一个 `PageBlock` 的领域对象，它可以携带任意类型的数据，这样我们就可以定义一个 `PageBlock<Product>` 的领域对象，它可以携带 `Product` 类型的数据，而如果我们定义一个 `PageBlock<ImageData>` 的领域对象，它可以携带 `ImageData` 类型的数据。

```dart
class PageBlock<T> {
  const PageBlock({
    required this.config,
    required this.data,
  });
  final BlockConfig config;
  final List<T> data;
}
```

但如果改造成泛型之后，我们很快会碰到几个问题：

- `fromJson` 方法的实现，因为 `fromJson` 方法是静态方法，它不知道 `T` 是什么类型，所以我们需要将 `fromJson` 方法改造成一个泛型方法，方法是传入一个返回 `T` 类型的函数，这个函数的参数是 `Map<String, dynamic>`，这样我们就可以在调用 `fromJson` 方法的时候传入一个函数，这个函数的作用是将 `Map<String, dynamic>` 转换为 `T` 类型的对象，这样我们就可以将 `List<Map<String, dynamic>>` 转换为 `List<T>`。

- `toJson` 方法的实现，因为 `toJson` 方法是实例方法，但 `T` 这个类型过于抽象，它并没有自己的 `toJson` 方法，我们可以对 `T` 进行约束，要求 `T` 必须是某个自定义抽象类型，这个抽象类中定义 `toJson` 方法，这样我们就可以调用 `T` 的 `toJson` 方法。

```dart
/// 这个抽象类定义了一个 toJson 的抽象方法，它的返回值是 Map<String, dynamic>
abstract class Jsonable {
  Map<String, dynamic> toJson();
}
/// 让商品和图片都实现这个抽象类
class Product implements Jsonable {
  // ...
  @override
  Map<String, dynamic> toJson() {
    // ...
  }
}
class ImageData implements Jsonable {
  // ...
  @override
  Map<String, dynamic> toJson() {
    // ...
  }
}
/// 约束 PageBlock 的泛型 T 必须是 Jsonable 的子类
class PageBlock<T extends Jsonable> {
  const PageBlock({
    required this.config,
    required this.data,
  });
  final BlockConfig config;
  final List<T> data;

  /// 现在有两个参数，一个是json，一个是fromJson
  /// 这个 fromJson 方法是一个泛型方法，它的类型是 T Function(Map<String, dynamic>)
  /// 这个方法的作用是将一个 Map<String, dynamic> 转换为 T 类型的对象
  /// 需要这么做的原因是在转换 List<T> 的时候，我们需要将 List<Map<String, dynamic>> 转换为 List<T>
  /// 调用方式，比如 `PageBlock.fromJson(json, ImageData.fromJson)`
  /// 注意 ImageData.fromJson 不要加括号
  /// 因为如果加了括号，那么 fromJson 就会变成一个值，而不是一个函数了
  factory PageBlock.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return PageBlock<T>(
      config: BlockConfig.fromJson(json['config']),
      data: (json['data'] as List)
          .map((e) => fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'config': config.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}
```

### 4.3.7.2 商品行区块

要使用数据测试的话，我们还需要一点工作。我们完成了一行一商品卡片之后，可以着手写商品行区块的组件，所谓商品行区块就是包裹在一行一商品卡片或者一行两商品卡片外面的容器，在这个容器中，我们传入配置参数和商品列表，然后根据配置参数和商品列表来决定展示一行一商品卡片还是一行两商品卡片。

```dart
/// 商品行组件
/// 用于展示一或两个商品
/// 可以通过 [BlockConfig] 参数来指定区块的宽度、高度、内边距、外边距等
/// 可以通过 [Product] 参数来指定商品列表
/// 可以通过 [addToCart] 参数来指定点击添加到购物车按钮时的回调
/// 可以通过 [onTap] 参数来指定点击商品卡片时的回调
class ProductRowWidget extends StatelessWidget {
  /// assert 关键字用于断言，当条件不满足时，抛出异常
  /// assert(items.length <= 2 && items.length > 0);
  /// 1. items.length <= 2 表示 items 的长度必须小于等于 2
  /// 2. items.length > 0 表示 items 的长度必须大于 0
  const ProductRowWidget({
    super.key,
    required this.items,
    required this.config,
    this.errorImage,
    this.addToCart,
    this.onTap,
  }) : assert(items.length <= 2 && items.length > 0);
  final List<Product> items;
  final String? errorImage;
  final BlockConfig config;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = config.backgroundColor != null
        ? config.backgroundColor!
        : Colors.transparent;
    final borderColor =
        config.borderColor != null ? config.borderColor! : Colors.transparent;
    final borderWidth = config.borderWidth ?? 0.0;
    final width = config.blockWidth ?? 0;
    final height = config.blockHeight ?? 0;
    final horizontalPadding = config.horizontalPadding ?? 0;
    final verticalPadding = config.verticalPadding ?? 0;
    final horizontalSpacing = config.horizontalSpacing ?? 0;
    final verticalSpacing = config.verticalSpacing ?? 0;
    final blockWidth = width - 2 * horizontalPadding;

    /// 将 Widget 包裹在 Page 中
    /// 注意到 page 其实是一个方法，接受一个 Widget 作为参数，返回一个 Widget
    /// 通过这种方式，我们可以在 page 中对 Widget 进行一些处理，比如添加边框、背景色等
    /// 这样我们可以专注于 Widget 的内容，而不用关心 Widget 的样式
    page({required Widget child}) => child
        .padding(horizontal: horizontalPadding, vertical: verticalPadding)
        .decorated(
          color: backgroundColor,
          border: Border.all(
            color: borderColor,
            width: borderWidth,
          ),
        )
        .constrained(width: width, maxHeight: height);

    switch (items.length) {
      /// 如果商品数量为 1，那么展示一行一列的商品卡片
      case 1:
        final product = items.first;
        return ProductCardOneRowOneWidget(
          product: product,
          width: blockWidth,
          height: height - 2 * verticalPadding,
          horizontalSpacing: horizontalSpacing,
          verticalSpacing: verticalSpacing,
          errorImage: errorImage,
          onTap: onTap,
          addToCart: addToCart,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          borderWidth: borderWidth,
        ).parent(page);
      default:

        /// TODO: 如果商品数量为 2，那么展示一行两列的商品卡片
        return Placeholder();
    }
  }
}
```

### 4.3.7.3 使用假数据测试

我们可以使用假数据来测试一下商品行组件，具体的实现如下：

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: darkBlue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) {
              /// 1. 获取屏幕宽度
              final screenWidth = MediaQuery.of(context).size.width;
              /// 2. 定义基准屏幕宽度
              const baselineScreenWidth = 375.0;
              /// 3. 计算比例
              final ratio = screenWidth / baselineScreenWidth;

              final block = PageBlock<Product>.fromJson({
                'data':  [
                  {
                    'id': 1,
                    'sku': 'sku_001',
                    'name': 'product 001',
                    'description': 'some description 001',
                    'price': '¥230.21',
                    'images': ['https://picsum.photos/600/300']
                  },
                ],
                'config': {
                  'horizontalPadding': 12.0,
                  'verticalPadding': 6.0,
                  'horizontalSpacing': 6.0,
                  'blockWidth': 375 - 12 * 2,
                  'blockHeight': 100,
                  'backgroundColor': '#ffffff',
                },
              }, Product.fromJson);

              return ProductRowWidget(
                items: block.data,
                config: block.config.withRatio(ratio),
              );
            }
          ),
        ),
      ),
    );
  }
}
```

然后你就可以看到如下的效果：

![图 5](http://ngassets.twigcodes.com/a00fafed9604ef71ab31c18bfa385b96970d9220d6ed47c5c48795f6079323e0.png)

### 4.3.8 挖掘隐性需求

上面的

## 4.4 一行二商品组件的实现
