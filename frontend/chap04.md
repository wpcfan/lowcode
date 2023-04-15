# 第四章：App 原型之商品组件和瀑布流

做了两个图片类型的组件之后，我们应该对于组件的实现有了一定的了解。现在我们来实现一个商品组件，它的功能是展示商品的图片、名称、价格、购买按钮等信息。当然它在布局上更为复杂。我们仍然遵循 **“问题-方案-原型-验证-改进”** 的开发模式

<!-- @import "[TOC]" {cmd="toc" depthFrom=1 depthTo=6 orderedList=false} -->

<!-- code_chunk_output -->

- [第四章：App 原型之商品组件和瀑布流](#第四章app-原型之商品组件和瀑布流)
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
  - [4.4 作业：一行二商品组件的实现](#44-作业一行二商品组件的实现)
    - [4.4.1 整合到商品行区块中](#441-整合到商品行区块中)
    - [4.4.2 一行二商品区块验证](#442-一行二商品区块验证)
  - [4.5 瀑布流商品组件](#45-瀑布流商品组件)
    - [4.5.1 瀑布流的数据模型](#451-瀑布流的数据模型)
  - [4.6 如何实现瀑布流的无限加载](#46-如何实现瀑布流的无限加载)
    - [4.6.1 一个基础的 `CustomScrollView`](#461-一个基础的-customscrollview)
    - [4.6.2 实现上拉加载更多](#462-实现上拉加载更多)
    - [4.6.3 验证上拉加载更多](#463-验证上拉加载更多)
    - [4.6.4 实现下拉刷新](#464-实现下拉刷新)
  - [4.7 整体布局的领域模型](#47-整体布局的领域模型)
    - [4.7.1 测试整体布局](#471-测试整体布局)

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
  final String? originalPrice;
  final String? imageUrl;
}
```

商品区块的领域模型非常简单，只有四个属性，分别是商品名称、商品描述、商品价格、商品原价和商品图片的 URL。这里我们把商品价格定义为字符串，因为商品价格是一个带有货币符号小数点的数字，所以我们把它定义为字符串类型。

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
  final String? originalPrice;
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
  final String? originalPrice;
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
  final String? originalPrice;
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
    this.originalPrice,
    this.images = const [],
  });

  final int? id;
  final String? sku;
  final String? name;
  final String? description;
  final String? price;
  final String? originalPrice;
  final List<String> images;

  Product copyWith({
    int? id,
    String? sku,
    String? name,
    String? description,
    String? price,
    String? originalPrice,
    List<String>? images,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      images: images ?? this.images,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, sku: $sku, name: $name, description: $description, price: $price, originalPrice: $originalPrice, images: $images)';
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int?,
        sku: json['sku'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        price: json['price'] as String?,
        originalPrice: json['originalPrice'] as String?,
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
        'originalPrice': originalPrice,
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

另外对于商品的原价，一般都会有一个删除线，我们也可以在 `common` 工程中的 `string_extension.dart` 文件中添加一个扩展方法:

```dart
/// 划线价格
  Text lineThru({
    double fontSize = 12.0,
    FontWeight fontWeight = FontWeight.w600,
    Color fontColor = Colors.grey,
  }) {
    return Text(this,
        style: TextStyle(
          fontWeight: fontWeight,
          fontSize: fontSize,
          color: fontColor,
          decoration: TextDecoration.lineThrough,
        ));
  }
```

### 4.3.4 商品价格和购物车按钮

有了处理价格富文本的扩展方法，我们就可以在商品卡片中使用了:

```dart
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
    .gestures(onTap: () => addToCart?.call(product));

// 将价格和购物车按钮放在一行
final priceRow = [
  productOriginalPrice,
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
    ).padding(bottom: verticalSpacing);
    // 商品描述
    final productDescription = Text(
      product.description ?? '',
      style: const TextStyle(
        fontSize: 14,
        color: Colors.black54,
      ),
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

  const ProductRowWidget({
    super.key,
    required this.items,
    required this.config,
    this.errorImage,
    this.addToCart,
    this.onTap,
  }) :
  /// 这里我们引入 assert 关键字用于断言，当条件不满足时，抛出异常
  /// assert(items.length <= 2 && items.length > 0);
  /// 1. items.length <= 2 表示 items 的长度必须小于等于 2
  /// 2. items.length > 0 表示 items 的长度必须大于 0
  assert(items.length <= 2 && items.length > 0);
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

上面的代码中，有一些需求不是那么明显，但是，我们可以通过一些技巧来挖掘出来，比如：

1. 文字类的内容，一般都要考虑过长的情况。比如商品名称、商品描述等，这些内容一般都要考虑过长的情况。那么解决办法有几种，一种是省略或截断，另一种是折行。具体采用什么方案需要和 UI 设计师沟通，然后再做决定。我们这里对于商品名称采用折行，而且最大折行数为 2 行，对于商品描述采用省略，最大省略长度为 1 行，具体的实现如下：

```dart
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
  softWrap: false,
  maxLines: 1,
  overflow: TextOverflow.ellipsis,
).padding(bottom: verticalSpacing);
```

2. 价格文本由于位于图片和购物车图标之间，而且价格一般不允许截断、省略或折行，所以这里一定要确定的是价格的上限是多少，这个地方需要和 UI 设计师以及后台开发人员沟通。这个需求主要是后端控制，我们后面会讲。

## 4.4 作业：一行二商品组件的实现

有了之前的基础，大家可以来实现一行二商品组件了，一个起始框架如下：

```dart
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
    /// TODO: 实现一行二商品组件
  }
}
```

具体，如果发现有什么问题，可以参考 `page_block_widgets/lib/product_card_one_row_two.dart` 文件。

### 4.4.1 整合到商品行区块中

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

        /// 如果商品数量为 2，那么展示一行两列的商品卡片
        return items
            .map((e) {
              final isLast = items.last == e;
              return [
                ProductCardOneRowTwoWidget(
                  product: e,
                  itemWidth: (blockWidth - horizontalSpacing) / 2,
                  itemHeight: height - 2 * verticalPadding,
                  verticalSpacing: verticalSpacing,
                  errorImage: errorImage,
                  onTap: onTap,
                  addToCart: addToCart,
                  backgroundColor: Colors.white,
                  borderColor: Colors.grey,
                  borderWidth: 1,
                ).expanded(),
                if (!isLast) SizedBox(width: horizontalSpacing),
              ];
            })
            .expand((element) => element)
            .toList()
            .toRow(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
            )
            .parent(page);
    }
  }
}
```

### 4.4.2 一行二商品区块验证

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
                  {
                    'id': 2,
                    'sku': 'sku_002',
                    'name': 'product 002',
                    'description': 'some description 002',
                    'price': '¥200.32',
                    'images': ['https://picsum.photos/600/300']
                  },
                ],
                'config': {
                  'horizontalPadding': 12.0,
                  'verticalPadding': 6.0,
                  'horizontalSpacing': 6.0,
                  'blockWidth': 375 - 12 * 2,
                  'blockHeight': 240,
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

商品行的效果如下：

![图 7](http://ngassets.twigcodes.com/721894a8923a72e6f5f57058018193e2a77e7add6ee10a1da122484dd6293dc1.png)

## 4.5 瀑布流商品组件

瀑布流商品组件，是一种比较常见的商品展示方式，它的特点是商品卡片的宽度是固定的，但是高度是不固定的，为什么高度会不固定呢？因为商品卡片中的内容是不固定的，比如商品名称可以一行，也可以两行，另外，有的时候伴随着一些优惠，可能会有划线价的出现，所以高度是不固定的。这里我们先来看一下瀑布流商品组件的效果：

![图 6](http://ngassets.twigcodes.com/3540fdeb768bd3591be166746935d31a47c6ab3dfd35e34f490b7028e7f3ac8b.png)

可以看到，其实瀑布流的商品卡片本身整体布局和一行二商品卡片是一样的，只是商品卡片的高度是不固定的，所以我们需要看一下是否可以复用一行二商品卡片的代码。

在 `page_block_widgets/lib/product_card_one_row_two.dart` 中，我们可以看到外层并没有限制高度。一行二的高度其实是定义在 `page_block_widgets/lib/product_row.dart` 中定义的。这就说明我们可以直接复用一行二商品卡片的代码。

```dart
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
```

那么我们可以在 `page_block_widgets/lib` 中创建一个文件 `waterfall.dart` 。

```dart
/// 瀑布流组件
/// 用于展示商品列表
/// 会根据商品的宽高比来自动计算高度
/// 以适应不同的屏幕
/// 可以通过 [BlockConfig] 参数来指定区块的宽度、高度、内边距、外边距等
/// 可以通过 [Product] 参数来指定商品列表
/// 可以通过 [addToCart] 参数来指定点击添加到购物车按钮时的回调
/// 可以通过 [onTap] 参数来指定点击商品卡片时的回调
class WaterfallWidget extends StatelessWidget {
  const WaterfallWidget({
    super.key,
    required this.config,
    required this.products,
    this.errorImage,
    this.addToCart,
    this.onTap,
    this.isPreview = false,
  });
  final BlockConfig config;
  final List<Product> products;
  final String? errorImage;
  final void Function(Product)? addToCart;
  final void Function(Product)? onTap;
  final bool isPreview;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = config.backgroundColor != null
        ? config.backgroundColor!
        : Colors.transparent;
    final borderColor =
        config.borderColor != null ? config.borderColor! : Colors.transparent;
    final borderWidth = config.borderWidth ?? 0.0;
    final horizontalPadding = config.horizontalPadding ?? 0;
    final verticalPadding = config.verticalPadding ?? 0;
    final horizontalSpacing = config.horizontalSpacing ?? 0;
    final verticalSpacing = config.verticalSpacing ?? 0;
    final blockWidth = config.blockWidth ?? 0;
    final itemWidth = (blockWidth) / 2;
    /// 在这里构建瀑布流布局
  }
}
```

首先，为了更聚焦课程本身的内容，我们就不自己从头实现瀑布流布局了，我们直接使用第三方库 [flutter_staggered_grid_view](https://pub.dev/packages/flutter_staggered_grid_view) 来实现瀑布流布局。

在 `page_block_widgets/pubspec.yaml` 中添加依赖：

```yaml
dependencies:
  flutter_staggered_grid_view: ^0.6.2
```

然后在 `page_block_widgets/lib/waterfall.dart` 中引入 `flutter_staggered_grid_view` 。

```dart
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
```

然后我们就可以直接使用 `SliverMasonryGrid.count` 来实现瀑布流布局了。

```dart
return SliverPadding(
  padding: EdgeInsets.symmetric(
    horizontal: horizontalPadding,
    vertical: verticalPadding,
  ),
  sliver: SliverMasonryGrid.count(
    /// 一行显示两个商品
    crossAxisCount: 2,
    /// 水平间距
    mainAxisSpacing: horizontalSpacing,
    /// 垂直间距
    crossAxisSpacing: verticalSpacing,
    /// 商品个数
    childCount: products.length,
    /// 构建卡片
    itemBuilder: (context, index) {
      final product = products[index];
      return ProductCardOneRowTwoWidget(
        product: product,
        itemWidth: itemWidth,
        verticalSpacing: verticalSpacing,
        errorImage: errorImage,
        addToCart: addToCart,
        onTap: onTap,
        backgroundColor: backgroundColor,
        borderColor: borderColor,
        borderWidth: borderWidth,
      );
    },
  ),
);
```

上面代码中，大家可能很奇怪，为什么我们使用了 `SliverPadding` 来设置内边距，而不是 `Padding` ? 这是因为 `SliverPadding` 是 `Sliver` 的子类，而 `Sliver` 是 `SliverMasonryGrid.count` 的父类，所以我们需要使用 `SliverPadding` 来设置内边距。

那么 `Sliver` 是什么呢？`Sliver` 是 `Flutter` 中的一个概念，它的优点是可以实现懒加载，也就是说，当我们滚动到某个位置的时候，才会去加载对应的内容，而不是一次性加载所有的内容。这样可以提高性能。有很多组件支持 `Sliver`，比如 `SliverAppBar`、`SliverList`、`SliverGrid` 等等。

由于瀑布流是可以无尽加载，所以我们要使用性能好一些的 `SliverMasonryGrid.count` 来实现瀑布流布局。

### 4.5.1 瀑布流的数据模型

瀑布流区块能不能使用商品的数据模型呢？这个问题取决于你的业务需求，如果你的业务需求是，运营人员会直接配置数量非常多的商品到这个区块，那么你就可以复用商品的数据模型。但是如果你的业务需求是，运营人员会配置一个商品的分类，然后根据这个分类来获取商品列表，那么你就不能复用商品的数据模型了。

在这种情况下，我们需要新创建一个 `Category` 的数据模型，它包含了分类的 ID 、分类的名称、分类的编码、分类的子分类等信息。

```dart
/// 分类
class Category {
  const Category({
    this.id,
    this.name,
    this.code,
    this.children,
  });

  final int? id;
  final String? name;
  final String? code;
  final List<Category>? children;

  Category copyWith({
    int? id,
    String? name,
    String? code,
    List<Category>? children,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      children: children ?? this.children,
    );
  }

  @override
  String toString() =>
      'Category { id: $id, name: $name, code: $code, children: $children}';

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as int?,
        name: json['name'] as String?,
        code: json['code'] as String?,
        children: (json['children'] as List<dynamic>?)
            ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'children': children?.map((e) => e.toJson()).toList(),
      };
}
```

商品的模型中也应该加上分类的字段，由于一个商品可以属于多个分类，所以这个字段应该是列表：

```dart
class Product {
  const Product({
    this.id,
    this.sku,
    this.name,
    this.description,
    this.price,
    this.originalPrice,
    this.images = const [],
    this.categories,
  });

  final int? id;
  final String? sku;
  final String? name;
  final String? description;
  final String? price;
  final String? originalPrice;
  final List<String> images;
  final List<Category>? categories;

  Product copyWith({
    int? id,
    String? sku,
    String? name,
    String? description,
    String? price,
    String? originalPrice,
    List<String>? images,
    List<Category>? categories,
  }) {
    return Product(
      id: id ?? this.id,
      sku: sku ?? this.sku,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      images: images ?? this.images,
      categories: categories ?? this.categories,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, sku: $sku, name: $name, description: $description, price: $price, originalPrice: $originalPrice, images: $images, categories: $categories)';
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as int?,
        sku: json['sku'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        price: json['price'] as String?,
        originalPrice: json['originalPrice'] as String?,
        images: (json['images'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        categories: (json['categories'] as List<dynamic>?)
            ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'sku': sku,
        'name': name,
        'description': description,
        'price': price,
        'originalPrice': originalPrice,
        'images': images,
        'categories': categories?.map((e) => e.toJson()).toList(),
      };
}
```

## 4.6 如何实现瀑布流的无限加载

其实这个问题不应该仅仅针对瀑布流，因为瀑布流之所以会有上拉加载更多的行为，不是它自己的原因，而是因为所有的区块是放在一个列表中的，所以当我们滚动到列表的底部的时候，就会触发上拉加载更多的行为。

但是如果希望列表支持 `Sliver`，那么就不能使用 `ListView` 了，而是要使用 `CustomScrollView`。

`CustomScrollView` 是 `Flutter` 中的一个组件，它可以让我们自定义滚动效果，有兴趣的同学可以参考 [CustomScrollView](https://api.flutter.dev/flutter/widgets/CustomScrollView-class.html) 的文档。

简单来说，我们要自定义一个自己的 `CustomScrollView`，它支持下拉刷新、上拉加载更多、自定义 `SliverAppBar`。

### 4.6.1 一个基础的 `CustomScrollView`

一个基本的 `CustomScrollView` 的代码非常简单，如下所示：

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomScrollView extends StatelessWidget {
  const MyCustomScrollView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return
    CustomScrollView(
      slivers: [
        SliverAppBar(
          title: Text('CustomScrollView'),
          floating: true,
          snap: true,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Container(
                height: 100,
                color: Colors.primaries[index % Colors.primaries.length],
              );
            },
            childCount: 20,
          ),
        ),
      ],
    );
  }
}
```

`CustomScrollView` 的 `slivers` 属性，它是一个 `List<Widget>` 类型的属性，我们可以在这里添加任意的 `Sliver` 组件，比如 `SliverAppBar`、`SliverList`、`SliverGrid` 等等。

效果如下：

![图 8](http://ngassets.twigcodes.com/9c85904a73c8d00c121fae43d2254f7562d5ca3932fa51bc6264a336c55a1f66.png)

### 4.6.2 实现上拉加载更多

上拉加载更多其实就是要监听 `CustomScrollView` 的滚动事件，当滚动到底部的时候，就去加载更多的数据。

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCustomScrollView extends StatelessWidget {
  const MyCustomScrollView({
    super.key,
    required this.sliver,
    this.onLoadMore,
    this.loadMoreWidget = const CupertinoActivityIndicator(),
  });

  final Widget sliver;
  final Future<void> Function()? onLoadMore;
  final Widget loadMoreWidget;

  @override
  Widget build(BuildContext context) {
    /// 监听滚动事件，当滚动到底部的时候，就去加载更多的数据
    return
    NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        /// 当滚动停止
        if (notification is ScrollEndNotification) {
          final metrics = notification.metrics;
          /// 检查是否滚动到底部
          if (metrics.pixels == metrics.maxScrollExtent) {
            /// 如果有加载更多的回调，就去加载更多
            if (onLoadMore != null) {
              onLoadMore!();
            }
          }
        }
        return false;
      },
      child: CustomScrollView(
        /// slivers 是一个列表，里面可以放很多个 Sliver 组件
        slivers: [
          sliver,
          if (onLoadMore != null)
          /// SliverToBoxAdapter 可以把一个 Widget 转换成 Sliver
            SliverToBoxAdapter(
              child: Container(
                height: 50,
                child: Center(
                  child: loadMoreWidget,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

要监听 `CustomScrollView` 的滚动事件，我们需要使用 `NotificationListener` 组件，它的 `onNotification` 属性，它是一个 `NotificationListenerCallback` 类型的属性，它的参数是 `ScrollNotification` 类型的，我们可以通过 `notification.metrics` 属性来获取滚动的信息，比如 `pixels`、`maxScrollExtent` 等等。

### 4.6.3 验证上拉加载更多

我们可以在 `MyCustomScrollView` 的 `onLoadMore` 属性中，添加一个 `print` 语句，来验证是否触发了上拉加载更多的行为。

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}

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
              return PullToLoadMore();
            }
          ),
        ),
      ),
    );
  }
}
/// 为测试方便，我们创建一个 StatefulWidget
class PullToLoadMore extends StatefulWidget {
  const PullToLoadMore({super.key});

  @override
  State<PullToLoadMore> createState() => _PullToLoadMoreState();
}

class _PullToLoadMoreState extends State<PullToLoadMore> {
  int page = 1;
  @override
  Widget build(BuildContext context) {
    return MyCustomScrollView(
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Container(
              height: 100,
              color: Colors.primaries[index % Colors.primaries.length],
            );
          },
          childCount: page * 20,
        ),
      ),
      onLoadMore: () async {
        print('加载更多');
        /// 模拟网络请求
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          page++;
        });
      }
    );
  }
}
```

效果如下：

![图 9](http://ngassets.twigcodes.com/8996962f523de1338d15181be8a22caa47b44e243e8155cf8f13a736b03d5c81.gif)

### 4.6.4 实现下拉刷新

由于我们想要的下拉刷新效果不是一个标准的 `Material` 风格，所以我们使用了 `CupertinoSliverRefreshControl` 来实现，它的 `builder` 属性，它是一个 `CupertinoSliverRefreshControlBuilder` 类型的属性，它的参数是 `BuildContext`、`RefreshIndicatorMode`、`double`、`double`、`double`，分别代表 `BuildContext`、刷新的状态、下拉的距离、触发刷新的距离、刷新的高度。

但是外层又需要套一个 `RefreshIndicator`，并且设置 `notificationPredicate` 属性为 `false` ，隐藏 `Material` 风格的刷新。这种做法没有什么道理，如果要实现这个效果，就只能这么做。

```dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 自定义的 CustomScrollView
/// 1. 支持下拉刷新
/// 2. 支持上拉加载更多
/// 3. 支持自定义 SliverAppBar
class MyCustomScrollView extends StatelessWidget {
  const MyCustomScrollView({
    super.key,
    required this.sliver,
    required this.onRefresh,
    this.onLoadMore,
    this.sliverAppBar,
    this.decoration,
    this.loadMoreWidget = const CupertinoActivityIndicator(),

    /// 要注意，如果我们的 CustomScrollView 的外层不是 Scaffold，那么
    /// 在这个空间如果要使用文本，会发现文本下方有两条黄线，这是因为 Text 默认
    /// 是需要外层有 DefaultTextStyle 的，而 Scaffold 会自动包裹一个
    /// 但如果没有 Scaffold，那么就需要我们自己手动包裹一个
    this.pullToRefreshWidget = const DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Text('下拉刷新'),
    ),
    this.releaseToRefreshWidget = const DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Text('松开刷新'),
    ),
    this.refreshingWidget = const CupertinoActivityIndicator(
      color: Colors.white,
    ),
    this.refreshCompleteWidget = const DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Text('刷新完成'),
    ),
  });
  final Widget sliver;
  final Future<void> Function() onRefresh;
  final Future<void> Function()? onLoadMore;
  final Widget? sliverAppBar;
  final BoxDecoration? decoration;
  final Widget loadMoreWidget;
  final Widget refreshingWidget;
  final Widget pullToRefreshWidget;
  final Widget releaseToRefreshWidget;
  final Widget refreshCompleteWidget;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,

      /// 不触发 RefreshIndicator 的下拉刷新
      notificationPredicate: (notification) => false,
      child: NotificationListener(
        onNotification: (scrollNotification) {
          if (scrollNotification is ScrollEndNotification) {
            /// 如果滑动到了最底部，那么就触发加载更多
            if (scrollNotification.metrics.pixels ==
                scrollNotification.metrics.maxScrollExtent) {
              onLoadMore?.call();
            }
          }
          return true;
        },
        child: CustomScrollView(
          /// 这个属性是用来控制下拉刷新的，如果不设置，是无法下拉出一段距离的
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            /// AppBar 一般位于最顶部，所以这里放在最前面
            sliverAppBar,

            /// 自定义在刷新的不同状态下的显示内容
            /// 这里面我们使用了 CupertinoSliverRefreshControl，这个控件是 iOS 风格的
            CupertinoSliverRefreshControl(
              refreshTriggerPullDistance: 100,
              refreshIndicatorExtent: 60,
              onRefresh: onRefresh,
              builder: (context, refreshState, pulledExtent,
                      refreshTriggerPullDistance, refreshIndicatorExtent) =>
                  Container(
                decoration: decoration,
                height: pulledExtent,
                alignment: Alignment.center,
                child: _buildRefreshIndicator(
                  refreshState,
                ),
              ),
            ),

            /// 把其他传入的 slivers 放在这里
            sliver,

            /// 在页面底部显示加载更多的 Widget
            SliverToBoxAdapter(
              child: loadMoreWidget,
            ),
          ]
              // 用于过滤掉空的 Widget
              .whereType<Widget>()
              .toList(),
        ),
      ),
    );
  }

  _buildRefreshIndicator(
    RefreshIndicatorMode refreshState,
  ) {
    switch (refreshState) {
      case RefreshIndicatorMode.drag:
        return pullToRefreshWidget;
      case RefreshIndicatorMode.armed:
        return releaseToRefreshWidget;
      case RefreshIndicatorMode.refresh:
        return refreshingWidget;
      case RefreshIndicatorMode.done:
        return refreshCompleteWidget;
      default:
        return Container();
    }
  }
}
```

这个组件中为了更好的定制，我们还给出了一些属性，比如 `pullToRefreshWidget`、`releaseToRefreshWidget`、`refreshingWidget`、`refreshCompleteWidget`，分别代表下拉刷新的状态下的显示内容，这样我们就可以自定义下拉刷新的效果了。

整体的效果见下图：

![下拉刷新效果](https://i.imgur.com/mq0jWaU.gif)

## 4.7 整体布局的领域模型

在可以测试整体布局之前，我们需要先把整体布局的领域模型搞清楚。我们首先来回顾一下和布局有关的需求：

- 需求 1.1: 页面布局是由一个个区块组成的
- 需求 2：首页的布局是有生效时间段的，比如 2020-01-01 00:00:00 到 2020-01-02 00:00:00
- 需求 3：首页的布局可以有多个，因为不同的时间段，首页的布局可能是不一样的
- 需求 3.1：布局保存时，不会立即生效，而是需要运营人员手动发布布局，才会生效
- 需求 3.2：布局保存时，不保存生效时间段，而是保存布局的状态，比如草稿、已发布、已下线
- 需求 4：首页的布局可以有几个状态，比如草稿、已发布、已下线
- 需求 4.1：草稿状态的布局和已下线状态的布局，只有运营人员可以看到，App 是看不到的
- 需求 4.2：已发布状态的布局，运营人员和 App 都可以看到
- 需求 4.3：运营人员可以发布布局，在发布时，需要选择布局的生效时间段，后端会校验时间段是否有重叠，如果有重叠，那么会提示运营人员，需要重新选择时间段
- 需求 4.4：运营人员可以下线布局，下线布局后，App 就看不到这个布局了
- 需求 5：相同或者重叠的时间段，只能有一个布局是已发布的，因为 App 只能展示一个布局
- 需求 8.1：布局名称含有输入字符
- 需求 8.2：选择布局状态：草稿、已发布、已下线
- 需求 8.3：选择布局生效起始时间段，比如查询所有生效起始时间在从 2020-01-01 00:00:00 到 2020-01-02 00:00:00 之间的布局
- 需求 8.4：选择布局生效结束时间段，比如查询所有生效结束时间在从 2020-01-01 00:00:00 到 2020-01-02 00:00:00 之间的布局
- 需求 8.5：选择平台 App / Web ，默认是 App，其中 web 做为扩展需求
- 需求 8.6：选择布局的目标对象，比如 Home / Category / About 等等，这个是扩展需求

一个布局显然应该是一组区块 `PageBlock` 构成的。

```dart
/// 平台类型
/// - app: App 包括 iOS 和 Android
/// - web: Web 包括移动网页
enum Platform {
  app('App'),
  web('Web');

  final String value;

  const Platform(this.value);
}
/// 页面类型
/// - home: 首页
/// - category: 分类页
/// - about: 关于页
enum PageType {
  home('home'),
  category('category'),
  about('about');

  final String value;

  const PageType(this.value);
}
/// 页面状态
/// - draft: 草稿
/// - published: 已发布
/// - archived: 已归档，过期后会自动归档
enum PageStatus {
  draft('Draft'),
  published('Published'),
  archived('Archived');

  final String value;

  const PageStatus(this.value);
}
class PageLayout {
  final int? id;
  final String title;
  final Platform platform;
  final PageType pageType;
  final PageConfig config;
  final PageStatus status;
  final DateTime? startTime;
  final DateTime? endTime;
  final List<PageBlock> blocks;

  const PageLayout({
    this.id,
    required this.title,
    required this.platform,
    required this.pageType,
    required this.config,
    required this.status,
    this.startTime,
    this.endTime,
    this.blocks = const [],
  });
}
```

然后我们继续考虑如何进行 `Json` 的序列化和反序列化。在前面的章节中，我们已经知道了如何进行 `Json` 的序列化和反序列化，但是在这里，我们需要对 `PageBlock` 进行序列化和反序列化，因为 `PageBlock` 中的 `data` 是一个动态的类型，虽然我们做了泛型，之前的测试中我们是预先知道 `data` 的类型的，但是在这里，我们不知道 `data` 的类型，因为它是一个动态的类型，所以我们需要在 `PageBlock` 引入一个枚举类型 `PageBlockType`，用来标识 `data` 的类型，然后在序列化和反序列化的时候，根据 `PageBlockType` 来进行序列化和反序列化。

```dart
/// 页面区块类型
/// - banner: 轮播图
/// - imageRow: 图片行
/// - productRow: 商品行
/// - waterfall: 瀑布流
enum PageBlockType {
  banner('banner'),
  imageRow('image_row'),
  productRow('product_row'),
  waterfall('waterfall'),
  unknown('unknown');

  final String value;
  const PageBlockType(this.value);
}
class PageBlock<T> {
  const PageBlock({
    this.id,
    required this.title,
    required this.type,
    required this.sort,
    required this.config,
    required this.data,
  });
  final int? id;
  final String title;
  final PageBlockType type;
  final int sort;
  final BlockConfig config;
  final List<T> data;

  /// 根据不同的类型，反序列化不同的数据
  static PageBlock mapPageBlock(Map<String, dynamic> json) {
    if (json['type'] == PageBlockType.banner.value) {
      return PageBlock<ImageData>.fromJson(json, ImageData.fromJson);
    } else if (json['type'] == PageBlockType.imageRow.value) {
      return PageBlock<ImageData>.fromJson(json, ImageData.fromJson);
    } else if (json['type'] == PageBlockType.productRow.value) {
      return PageBlock<Product>.fromJson(json, Product.fromJson);
    } else if (json['type'] == PageBlockType.waterfall.value) {
      return PageBlock<Category>.fromJson(json, Category.fromJson);
    }
    throw Exception('Unknown PageBlockType');
  }

  factory PageBlock.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return PageBlock<T>(
      id: json['id'],
      title: json['title'],
      type: PageBlockType.values.firstWhere((e) => e.value == json['type'],
          orElse: () => PageBlockType.unknown),
      sort: json['sort'],
      config: BlockConfig.fromJson(json['config']),
      data: (json['data'] as List)
          .map((e) => fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.value,
      'sort': sort,
      'config': config.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  PageBlock<T> copyWith({
    int? id,
    String? title,
    PageBlockType? type,
    int? sort,
    BlockConfig? config,
    List<T>? data,
  }) {
    return PageBlock(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      sort: sort ?? this.sort,
      config: config ?? this.config,
      data: data ?? this.data,
    );
  }
}
```

进一步的思考就是区块的数据类型，之前我们简单化为 `ImageData` 和 `Product` ，但是其实对于瀑布流来说，我们需要提供的是一个新的类型 `Category` 。我们当然可以按之前的做法，让 `Category` 实现 `Jsonable` 接口。

但 `Jsonable` 到底够不够用？我们先来考虑图片区块，多张图片的情况下，是有顺序的，也就是说哪张图片在第一个位置，哪张图片在第二个位置，这个顺序是有意义的，商品区块类似，多个商品的情况下，也是有顺序的，我们需要引入一个属性 `sort` 。另外如果考虑到以后要修改或者删除某个特定数据的话，每个数据项其实还应该有 `id` ，这样才能够唯一标识某个数据项。所以我们需要一个新的类型来表示这种数据，我们引入一个新的类型 `BlockData` ，它包含了 `id` ，`sort` ，`content` 三个属性，其中 `content` 是一个泛型，表示数据的类型。

```dart
class BlockData<T> {
  final int? id;
  final int sort;
  final T content;

  BlockData({this.id, required this.sort, required this.content});

  factory BlockData.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return BlockData(
      id: json['id'],
      sort: json['sort'],
      content: fromJson(json['content']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sort': sort,
      'content': content,
    };
  }

  BlockData<T> copyWith({
    int? id,
    int? sort,
    T? content,
  }) {
    return BlockData(
      id: id ?? this.id,
      sort: sort ?? this.sort,
      content: content ?? this.content,
    );
  }
}
```

而区块的数据类型，我们就可以改为 `List<BlockData<T>>` 了。

```dart
class PageBlock<T> {
  const PageBlock({
    this.id,
    required this.title,
    required this.type,
    required this.sort,
    required this.config,
    required this.data,
  });
  final int? id;
  final String title;
  final PageBlockType type;
  final int sort;
  final BlockConfig config;
  final List<BlockData<T>> data;

  static PageBlock mapPageBlock(Map<String, dynamic> json) {
    if (json['type'] == PageBlockType.banner.value) {
      return PageBlock<ImageData>.fromJson(json, ImageData.fromJson);
    } else if (json['type'] == PageBlockType.imageRow.value) {
      return PageBlock<ImageData>.fromJson(json, ImageData.fromJson);
    } else if (json['type'] == PageBlockType.productRow.value) {
      return PageBlock<Product>.fromJson(json, Product.fromJson);
    } else if (json['type'] == PageBlockType.waterfall.value) {
      return PageBlock<Category>.fromJson(json, Category.fromJson);
    }
    throw Exception('Unknown PageBlockType');
  }

  factory PageBlock.fromJson(
      Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJson) {
    return PageBlock<T>(
      id: json['id'],
      title: json['title'],
      type: PageBlockType.values.firstWhere((e) => e.value == json['type'],
          orElse: () => PageBlockType.unknown),
      sort: json['sort'],
      config: BlockConfig.fromJson(json['config']),
      data: (json['data'] as List)
          .map((e) => BlockData.fromJson(e, fromJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type.value,
      'sort': sort,
      'config': config.toJson(),
      'data': data.map((e) => e.toJson()).toList(),
    };
  }

  PageBlock<T> copyWith({
    int? id,
    String? title,
    PageBlockType? type,
    int? sort,
    BlockConfig? config,
    List<BlockData<T>>? data,
  }) {
    return PageBlock(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      sort: sort ?? this.sort,
      config: config ?? this.config,
      data: data ?? this.data,
    );
  }
}
```

在此情况下，我们不需要 `Jsonable` 接口了，请删掉 `Jsonable` 接口和 `Product` ，`ImageData` ，`Category` 类的实现 `Jsonable` 的声明。

改造完 `PageBlock` 后，我们给 `PageLayout` 添加 `fromJson` 方法，同时将 `PageLayout` 的 `blocks` 属性改为 `List<PageBlock>` 。

```dart
factory PageLayout.fromJson(
  dynamic json,
) {
  final blocks = (json['blocks'] as List<dynamic>).map((e) {
    if (e['type'] == PageBlockType.productRow.value) {
      return PageBlock.fromJson(e, Product.fromJson);
    } else if (e['type'] == PageBlockType.waterfall.value) {
      return PageBlock.fromJson(e, Category.fromJson);
    } else if (e['type'] == PageBlockType.imageRow.value) {
      return PageBlock.fromJson(e, ImageData.fromJson);
    } else if (e['type'] == PageBlockType.banner.value) {
      return PageBlock.fromJson(e, ImageData.fromJson);
    } else {
      return PageBlock.fromJson(e, (e) => e);
    }
  }).toList();
  /// 排序
  blocks.sort((a, b) => a.sort.compareTo(b.sort));
  return PageLayout(
    id: json['id'] as int?,
    title: json['title'] as String,
    platform: Platform.values.firstWhere(
      (e) => e.value == json['platform'],
      orElse: () => Platform.app,
    ),
    pageType: PageType.values.firstWhere(
      (e) => e.value == json['pageType'],
      orElse: () => PageType.home,
    ),
    config: PageConfig.fromJson(json['config']),
    status: PageStatus.values.firstWhere(
      (e) => e.value == json['status'],
      orElse: () => PageStatus.draft,
    ),
    startTime: json['startTime'] == null
        ? null
        : DateTime.parse(json['startTime'] as String),
    endTime: json['endTime'] == null
        ? null
        : DateTime.parse(json['endTime'] as String),
    blocks: blocks,
  );
}
```

### 4.7.1 测试整体布局

`MyCustomScrollView` 的 `sliver` 属性是希望接受一个 `sliver` 作为可滚动的内容，为什么不是一个列表呢？一个布局不是有多个区块吗？

主要的原因是在页面一级，我们也会有内边距等设置，这其实在 flutter 中等于要求外面会套一层 `SliverPadding`，所以你接受的还是一个 `sliver`，而不是一个列表。但请注意不同平台不一定是这样的，如果使用不同的语言框架在 Web/iOS/Android 上，我们可能会有不同的实现。

在 `app/lib/main.dart` 中，我们在 `MyApp` 中添加如下方法。

```dart
Widget _buildSliver(
      BuildContext context, PageLayout layout, List<Product> products) {
  final blocks = layout.blocks;
  final pageConfig = layout.config;
  final horizontalPadding = pageConfig.horizontalPadding ?? 0.0;
  final verticalPadding = pageConfig.verticalPadding ?? 0.0;
  final ratio = MediaQuery.of(context).size.width /
      (pageConfig.baselineScreenWidth ?? 375.0);
  const errorImage = '';
  return SliverPadding(
    padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding, vertical: verticalPadding),
    sliver: MultiSliver(
        children: blocks.map((block) {
      final config = block.config.withRatio(ratio);
      switch (block.type) {
        case PageBlockType.banner:
          final it = block as PageBlock<ImageData>;

          /// SliverToBoxAdapter 可以将一个 Widget 转换成 Sliver
          return SliverToBoxAdapter(
            child: BannerWidget(
              items: it.data.map((di) => di.content).toList(),
              config: config,
              errorImage: errorImage,
              onTap: (link) => debugPrint('$link'),
            ),
          );
        case PageBlockType.imageRow:
          final it = block as PageBlock<ImageData>;
          return SliverToBoxAdapter(
            child: ImageRowWidget(
              items: it.data.map((di) => di.content).toList(),
              config: config,
              errorImage: errorImage,
              onTap: (link) => debugPrint('$link'),
            ),
          );
        case PageBlockType.productRow:
          final it = block as PageBlock<Product>;
          return SliverToBoxAdapter(
            child: ProductRowWidget(
              items: it.data.map((di) => di.content).toList(),
              config: config,
              errorImage: errorImage,
              onTap: (product) => debugPrint('$product'),
              addToCart: (product) => debugPrint('$product'),
            ),
          );
        case PageBlockType.waterfall:
          final it = block as PageBlock<Category>;

          /// WaterfallWidget 是一个瀑布流的 Widget
          /// 它本身就是 Sliver，所以不需要再包装一层 SliverToBoxAdapter
          return WaterfallWidget(
            products: products,
            config: config,
            errorImage: errorImage,
            onTap: (product) => debugPrint('$product'),
            addToCart: (product) => debugPrint('$product'),
          );
        default:
          return SliverToBoxAdapter(
            child: Container(),
          );
      }
    }).toList()),
  );
}
```

这个方法是根据 `PageLayout` 的 `blocks` 属性，生成对应的 `sliver`，并且根据 `PageBlock` 的 `type` 属性，生成对应的 `Widget`。然后外层再包装一层 `SliverPadding`，这样就可以在页面一级设置内边距了。

我们这次可以把数据抽取出来放到一个 `.json` 文件中，然后在代码中读取，我们甚至可以放在 `assets` 目录中，使用异步方式访问。那么我们可以根据这个思路，把 `layout` 和 `products` 也放到 `assets` 目录中，然后在代码中读取，这样就可以把代码简化为：

```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      child: FutureBuilder(
        future: Future.wait([
          rootBundle.loadString('layout.json'),
          rootBundle.loadString('products.json'),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          const decoration = BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue,
                Colors.green,
              ],
            ),
          );
          final layout =
              PageLayout.fromJson(jsonDecode(snapshot.data!.first));
          final products = (jsonDecode(snapshot.data!.last) as List)
              .map((e) => Product.fromJson(e))
              .toList();
          final sliver = _buildSliver(context, layout, products);
          return MyCustomScrollView(
            decoration: decoration,
            sliver: sliver,
            sliverAppBar: SliverAppBar(
              floating: true,
              snap: false,
              pinned: false,
              systemOverlayStyle: SystemUiOverlayStyle.light,
              actions: [
                IconButton(
                  icon: const Icon(Icons.notification_important),
                  onPressed: () => debugPrint('menu clicked'),
                ),
              ],
              flexibleSpace: Container(
                decoration: decoration,
              ),
            ),
            onRefresh: () async => debugPrint('onRefresh'),
            onLoadMore: () async => debugPrint('onLoadMore'),
          );
        },
      ),
    ),
  );
}
```
