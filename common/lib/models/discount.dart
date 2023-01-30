import 'package:equatable/equatable.dart';

import 'money.dart';
import 'product.dart';

enum DiscountType {
  discount('discount'),
  discountOnUnit('discount_on_unit'),
  discountOnTotal('discount_on_total'),
  discountEveryXUnit('discount_every_x_unit'),
  discountEveryXTotal('discount_every_x_total'),
  freeProduct('free_product'),
  freeProductOnUnit('free_product_on_unit'),
  freeProductOnTotal('free_product_on_total'),
  freeProductEveryXUnit('free_product_every_x_unit'),
  freeProductEveryXTotal('free_product_every_x_total'),
  buyXGetY('buy_x_get_y'),
  flashSale('flash_sale'),
  ;

  final String value;
  const DiscountType(this.value);
}

abstract class Discount extends Equatable {
  final int id;
  final String title;
  final DiscountType type;
  final String tag;
  final String titleWhenApplied;
  final bool isApplied;

  const Discount({
    required this.id,
    required this.title,
    required this.type,
    required this.tag,
    required this.titleWhenApplied,
    this.isApplied = false,
  });

  factory Discount.fromJson(Map<String, dynamic> json) {
    final index =
        DiscountType.values.indexWhere((it) => it.value == json['type']);
    if (index == -1) {
      throw Exception('Unknown discount type: ${json['type']}');
    }
    final type = DiscountType.values[index];
    switch (type) {
      case DiscountType.discount:
        return DiscountPromotion.fromJson(json);
      case DiscountType.discountOnUnit:
        return DiscountOnUnitPromotion.fromJson(json);
      case DiscountType.discountOnTotal:
        return DiscountOnTotalPromotion.fromJson(json);
      case DiscountType.discountEveryXUnit:
        return DiscountEveryXUnitPromotion.fromJson(json);
      case DiscountType.discountEveryXTotal:
        return DiscountEveryXTotalPromotion.fromJson(json);
      case DiscountType.freeProduct:
        return FreeProductPromotion.fromJson(json);
      case DiscountType.freeProductOnUnit:
        return FreeProductOnUnitPromotion.fromJson(json);
      case DiscountType.freeProductOnTotal:
        return FreeProductOnTotalPromotion.fromJson(json);
      case DiscountType.freeProductEveryXUnit:
        return FreeProductEveryXUnitPromotion.fromJson(json);
      case DiscountType.freeProductEveryXTotal:
        return FreeProductEveryXTotalPromotion.fromJson(json);
      case DiscountType.buyXGetY:
        return BuyXGetYPromotion.fromJson(json);
      case DiscountType.flashSale:
        return FlashSalePromotion.fromJson(json);
    }
  }

  Map<String, dynamic> toJson();
}

/// Discount
class DiscountPromotion extends Discount {
  final Money? discount;

  const DiscountPromotion({
    required int id,
    required String title,
    required String tag,
    required String titleWhenApplied,
    this.discount,
    bool isApplied = false,
  }) : super(
          id: id,
          title: title,
          type: DiscountType.discount,
          tag: tag,
          titleWhenApplied: titleWhenApplied,
          isApplied: isApplied,
        );

  @override
  List<Object?> get props => [id, title, type, tag, titleWhenApplied, discount];

  @override
  String toString() {
    return '''DiscountPromotion {
        id: $id,
        title: $title,
        type: $type,
        tag: $tag,
        titleWhenApplied: $titleWhenApplied,
        discount: $discount,
        isApplied: $isApplied,
      }''';
  }

  DiscountPromotion copyWith({
    int? id,
    String? title,
    String? tag,
    String? titleWhenApplied,
    Money? discount,
    bool? isApplied,
  }) {
    return DiscountPromotion(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      titleWhenApplied: titleWhenApplied ?? this.titleWhenApplied,
      discount: discount ?? this.discount,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory DiscountPromotion.fromJson(Map<String, dynamic> json) =>
      DiscountPromotion(
        id: json["id"],
        title: json["title"],
        tag: json["tag"],
        titleWhenApplied: json["titleWhenApplied"],
        discount: json["discount"] == null
            ? null
            : Money.fromJson(json["discount"] as Map<String, dynamic>),
        isApplied: json["isApplied"] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "tag": tag,
        "titleWhenApplied": titleWhenApplied,
        "discount": discount?.toJson(),
        "isApplied": isApplied,
      };
}

/// Free Product on purchase
class FreeProductPromotion extends Discount {
  final Product product;

  const FreeProductPromotion({
    required int id,
    required String title,
    required String tag,
    required String titleWhenApplied,
    required this.product,
    bool isApplied = false,
  }) : super(
          id: id,
          title: title,
          type: DiscountType.freeProduct,
          tag: tag,
          titleWhenApplied: titleWhenApplied,
          isApplied: isApplied,
        );

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        tag,
        titleWhenApplied,
        product,
      ];

  @override
  String toString() {
    return '''FreeProductPromotion {
        id: $id,
        title: $title,
        type: $type,
        tag: $tag,
        titleWhenApplied: $titleWhenApplied,
        product: $product,
        isApplied: $isApplied,
      }''';
  }

  FreeProductPromotion copyWith({
    int? id,
    String? title,
    String? tag,
    String? titleWhenApplied,
    Product? product,
    bool? isApplied,
  }) {
    return FreeProductPromotion(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      titleWhenApplied: titleWhenApplied ?? this.titleWhenApplied,
      product: product ?? this.product,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory FreeProductPromotion.fromJson(Map<String, dynamic> json) =>
      FreeProductPromotion(
        id: json["id"],
        title: json["title"],
        tag: json["tag"],
        titleWhenApplied: json["titleWhenApplied"],
        product: Product.fromJson(json["product"] as Map<String, dynamic>),
        isApplied: json["isApplied"] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "tag": tag,
        "titleWhenApplied": titleWhenApplied,
        "product": product.toJson(),
        "isApplied": isApplied,
      };
}

/// Buy X Get Y
/// note: X and Y are the same product
class BuyXGetYPromotion extends Discount {
  final int buy;
  final int get;

  const BuyXGetYPromotion({
    required int id,
    required String title,
    required String tag,
    required String titleWhenApplied,
    required this.buy,
    required this.get,
    bool isApplied = false,
  }) : super(
          id: id,
          title: title,
          type: DiscountType.buyXGetY,
          tag: tag,
          titleWhenApplied: titleWhenApplied,
          isApplied: isApplied,
        );

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        tag,
        titleWhenApplied,
        buy,
        get,
      ];

  @override
  String toString() {
    return '''BuyXGetYPromotion {
        id: $id,
        title: $title,
        type: $type,
        tag: $tag,
        titleWhenApplied: $titleWhenApplied,
        buy: $buy,
        get: $get,
        isApplied: $isApplied,
      }''';
  }

  BuyXGetYPromotion copyWith({
    int? id,
    String? title,
    String? tag,
    String? titleWhenApplied,
    String? productId,
    String? productName,
    String? productImage,
    String? productPrice,
    int? buy,
    int? get,
    bool? isApplied,
  }) {
    return BuyXGetYPromotion(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      titleWhenApplied: titleWhenApplied ?? this.titleWhenApplied,
      buy: buy ?? this.buy,
      get: get ?? this.get,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory BuyXGetYPromotion.fromJson(Map<String, dynamic> json) =>
      BuyXGetYPromotion(
        id: json["id"],
        title: json["title"],
        tag: json["tag"],
        titleWhenApplied: json["titleWhenApplied"],
        buy: json["buy"],
        get: json["get"],
        isApplied: json["isApplied"] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "tag": tag,
        "titleWhenApplied": titleWhenApplied,
        "buy": buy,
        "get": get,
        "isApplied": isApplied,
      };
}

/// Discount based on the quantity of the product
/// NOTE: the condition is NOT repeated,
/// i.e. if the quantity of the product in cart is 5 and minQuantity is 3,
/// then the discount is applied only once
class DiscountOnUnitPromotion extends Discount {
  final Money discount;
  final int minQuantity;

  const DiscountOnUnitPromotion({
    required int id,
    required String title,
    required String tag,
    required String titleWhenApplied,
    required this.discount,
    required this.minQuantity,
    bool isApplied = false,
  }) : super(
          id: id,
          title: title,
          type: DiscountType.discountOnUnit,
          tag: tag,
          titleWhenApplied: titleWhenApplied,
          isApplied: isApplied,
        );

  @override
  List<Object?> get props =>
      [id, title, type, tag, titleWhenApplied, discount, minQuantity];

  @override
  String toString() {
    return '''DiscountOnMultiplePromotion {
        id: $id,
        title: $title,
        type: $type,
        tag: $tag,
        titleWhenApplied: $titleWhenApplied,
        discount: $discount,
        minQuantity: $minQuantity,
        isApplied: $isApplied,
      }''';
  }

  DiscountOnUnitPromotion copyWith({
    int? id,
    String? title,
    String? tag,
    String? titleWhenApplied,
    Money? discount,
    int? minQuantity,
    bool? isApplied,
  }) {
    return DiscountOnUnitPromotion(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      titleWhenApplied: titleWhenApplied ?? this.titleWhenApplied,
      discount: discount ?? this.discount,
      minQuantity: minQuantity ?? this.minQuantity,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory DiscountOnUnitPromotion.fromJson(Map<String, dynamic> json) =>
      DiscountOnUnitPromotion(
        id: json["id"],
        title: json["title"],
        tag: json["tag"],
        titleWhenApplied: json["titleWhenApplied"],
        discount: Money.fromJson(json["discount"]),
        minQuantity: json["minQuantity"],
        isApplied: json["isApplied"] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "tag": tag,
        "titleWhenApplied": titleWhenApplied,
        "discount": discount.toJson(),
        "minQuantity": minQuantity,
        "isApplied": isApplied,
      };
}

/// Discount based on the total price of the product
/// NOTE: the condition is NOT repeated,
/// i.e. if the total price of the product in cart is 5 and minPrice is 3,
/// then the discount is applied only once
class DiscountOnTotalPromotion extends Discount {
  final Money discount;
  final int minTotal;

  const DiscountOnTotalPromotion({
    required int id,
    required String title,
    required String tag,
    required String titleWhenApplied,
    required this.discount,
    required this.minTotal,
    bool isApplied = false,
  }) : super(
          id: id,
          title: title,
          type: DiscountType.discountOnTotal,
          tag: tag,
          titleWhenApplied: titleWhenApplied,
          isApplied: isApplied,
        );

  @override
  List<Object?> get props => [id, title, type, tag, titleWhenApplied, discount];

  @override
  String toString() {
    return '''DiscountOnTotalPromotion {
        id: $id,
        title: $title,
        type: $type,
        tag: $tag,
        titleWhenApplied: $titleWhenApplied,
        discount: $discount,
        minTotal: $minTotal,
        isApplied: $isApplied,
      }''';
  }

  DiscountOnTotalPromotion copyWith({
    int? id,
    String? title,
    String? tag,
    String? titleWhenApplied,
    Money? discount,
    int? minTotal,
    bool? isApplied,
  }) {
    return DiscountOnTotalPromotion(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      titleWhenApplied: titleWhenApplied ?? this.titleWhenApplied,
      discount: discount ?? this.discount,
      minTotal: minTotal ?? this.minTotal,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory DiscountOnTotalPromotion.fromJson(Map<String, dynamic> json) =>
      DiscountOnTotalPromotion(
        id: json["id"],
        title: json["title"],
        tag: json["tag"],
        titleWhenApplied: json["titleWhenApplied"],
        discount: Money.fromJson(json["discount"]),
        minTotal: json["minTotal"],
        isApplied: json["isApplied"] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "tag": tag,
        "titleWhenApplied": titleWhenApplied,
        "discount": discount.toJson(),
        "minTotal": minTotal,
        "isApplied": isApplied,
      };
}

/// Discount based on the quantity of the product
/// NOTE: the condition is repeated,
/// i.e. if the quantity of the product in cart is 6 and minQuantity is 3,
/// then the discount is applied 2 times
class DiscountEveryXUnitPromotion extends Discount {
  final Money discount;
  final int everyXUnit;

  const DiscountEveryXUnitPromotion({
    required int id,
    required String title,
    required String tag,
    required String titleWhenApplied,
    required this.discount,
    required this.everyXUnit,
    bool isApplied = false,
  }) : super(
          id: id,
          title: title,
          type: DiscountType.discountEveryXUnit,
          tag: tag,
          titleWhenApplied: titleWhenApplied,
          isApplied: isApplied,
        );

  @override
  List<Object?> get props =>
      [id, title, type, tag, titleWhenApplied, discount, everyXUnit];

  @override
  String toString() {
    return '''DiscountOnEveryXUnitPromotion {
        id: $id,
        title: $title,
        type: $type,
        tag: $tag,
        titleWhenApplied: $titleWhenApplied,
        discount: $discount,
        everyXUnit: $everyXUnit,
        isApplied: $isApplied,
      }''';
  }

  DiscountEveryXUnitPromotion copyWith({
    int? id,
    String? title,
    String? tag,
    String? titleWhenApplied,
    Money? discount,
    int? everyXUnit,
    bool? isApplied,
  }) {
    return DiscountEveryXUnitPromotion(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      titleWhenApplied: titleWhenApplied ?? this.titleWhenApplied,
      discount: discount ?? this.discount,
      everyXUnit: everyXUnit ?? this.everyXUnit,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory DiscountEveryXUnitPromotion.fromJson(Map<String, dynamic> json) =>
      DiscountEveryXUnitPromotion(
        id: json["id"],
        title: json["title"],
        tag: json["tag"],
        titleWhenApplied: json["titleWhenApplied"],
        discount: Money.fromJson(json["discount"]),
        everyXUnit: json["everyXUnit"],
        isApplied: json["isApplied"] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "tag": tag,
        "titleWhenApplied": titleWhenApplied,
        "discount": discount.toJson(),
        "everyXUnit": everyXUnit,
        "isApplied": isApplied,
      };
}

/// Discount based on the total price of the product
/// NOTE: the condition is repeated,
/// i.e. if the total price of the product in cart is 6 and minTotal is 3,
/// then the discount is applied 2 times
class DiscountEveryXTotalPromotion extends Discount {
  final Money discount;
  final int everyXTotal;

  const DiscountEveryXTotalPromotion({
    required int id,
    required String title,
    required String tag,
    required String titleWhenApplied,
    required this.discount,
    required this.everyXTotal,
    bool isApplied = false,
  }) : super(
          id: id,
          title: title,
          type: DiscountType.discountEveryXTotal,
          tag: tag,
          titleWhenApplied: titleWhenApplied,
          isApplied: isApplied,
        );

  @override
  List<Object?> get props =>
      [id, title, type, tag, titleWhenApplied, discount, everyXTotal];

  @override
  String toString() {
    return '''DiscountOnEveryXTotalPromotion {
        id: $id,
        title: $title,
        type: $type,
        tag: $tag,
        titleWhenApplied: $titleWhenApplied,
        discount: $discount,
        everyXTotal: $everyXTotal,
        isApplied: $isApplied,
      }''';
  }

  DiscountEveryXTotalPromotion copyWith({
    int? id,
    String? title,
    String? tag,
    String? titleWhenApplied,
    Money? discount,
    int? everyXTotal,
    bool? isApplied,
  }) {
    return DiscountEveryXTotalPromotion(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      titleWhenApplied: titleWhenApplied ?? this.titleWhenApplied,
      discount: discount ?? this.discount,
      everyXTotal: everyXTotal ?? this.everyXTotal,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory DiscountEveryXTotalPromotion.fromJson(Map<String, dynamic> json) =>
      DiscountEveryXTotalPromotion(
        id: json["id"],
        title: json["title"],
        tag: json["tag"],
        titleWhenApplied: json["titleWhenApplied"],
        discount: Money.fromJson(json["discount"]),
        everyXTotal: json["everyXTotal"],
        isApplied: json["isApplied"] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "tag": tag,
        "titleWhenApplied": titleWhenApplied,
        "discount": discount.toJson(),
        "everyXTotal": everyXTotal,
        "isApplied": isApplied,
      };
}

class FreeProductOnUnitPromotion extends Discount {
  final Product product;
  final int minQuantity;

  const FreeProductOnUnitPromotion({
    required int id,
    required String title,
    required String tag,
    required String titleWhenApplied,
    required this.product,
    required this.minQuantity,
    bool isApplied = false,
  }) : super(
          id: id,
          title: title,
          type: DiscountType.freeProductOnUnit,
          tag: tag,
          titleWhenApplied: titleWhenApplied,
          isApplied: isApplied,
        );

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        tag,
        titleWhenApplied,
        product,
        minQuantity,
      ];

  @override
  String toString() {
    return '''FreeProductOnUnitPromotion {
        id: $id,
        title: $title,
        type: $type,
        tag: $tag,
        titleWhenApplied: $titleWhenApplied,
        product: $product,
        minQuantity: $minQuantity,
        isApplied: $isApplied,
      }''';
  }

  FreeProductOnUnitPromotion copyWith({
    int? id,
    String? title,
    String? tag,
    String? titleWhenApplied,
    Product? product,
    int? minQuantity,
    bool? isApplied,
  }) {
    return FreeProductOnUnitPromotion(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      titleWhenApplied: titleWhenApplied ?? this.titleWhenApplied,
      product: product ?? this.product,
      minQuantity: minQuantity ?? this.minQuantity,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory FreeProductOnUnitPromotion.fromJson(Map<String, dynamic> json) =>
      FreeProductOnUnitPromotion(
        id: json["id"],
        title: json["title"],
        tag: json["tag"],
        titleWhenApplied: json["titleWhenApplied"],
        product: Product.fromJson(json["product"]),
        minQuantity: json["minQuantity"],
        isApplied: json["isApplied"] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "tag": tag,
        "titleWhenApplied": titleWhenApplied,
        "product": product.toJson(),
        "minQuantity": minQuantity,
        "isApplied": isApplied,
      };
}

class FreeProductOnTotalPromotion extends Discount {
  final Product product;
  final int minTotal;

  const FreeProductOnTotalPromotion({
    required int id,
    required String title,
    required String tag,
    required String titleWhenApplied,
    required this.product,
    required this.minTotal,
    bool isApplied = false,
  }) : super(
          id: id,
          title: title,
          type: DiscountType.freeProductOnTotal,
          tag: tag,
          titleWhenApplied: titleWhenApplied,
          isApplied: isApplied,
        );

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        tag,
        titleWhenApplied,
        product,
        minTotal,
      ];

  @override
  String toString() {
    return '''FreeProductOnTotalPromotion {
        id: $id,
        title: $title,
        type: $type,
        tag: $tag,
        titleWhenApplied: $titleWhenApplied,
        product: $product,
        minTotal: $minTotal,
        isApplied: $isApplied,
      }''';
  }

  FreeProductOnTotalPromotion copyWith({
    int? id,
    String? title,
    String? tag,
    String? titleWhenApplied,
    Product? product,
    int? minTotal,
    bool? isApplied,
  }) {
    return FreeProductOnTotalPromotion(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      titleWhenApplied: titleWhenApplied ?? this.titleWhenApplied,
      product: product ?? this.product,
      minTotal: minTotal ?? this.minTotal,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory FreeProductOnTotalPromotion.fromJson(Map<String, dynamic> json) =>
      FreeProductOnTotalPromotion(
        id: json["id"],
        title: json["title"],
        tag: json["tag"],
        titleWhenApplied: json["titleWhenApplied"],
        product: Product.fromJson(json["product"]),
        minTotal: json["minTotal"],
        isApplied: json["isApplied"] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "tag": tag,
        "titleWhenApplied": titleWhenApplied,
        "product": product.toJson(),
        "minTotal": minTotal,
        "isApplied": isApplied,
      };
}

class FreeProductEveryXUnitPromotion extends Discount {
  final Product product;
  final int everyXUnit;

  const FreeProductEveryXUnitPromotion({
    required int id,
    required String title,
    required String tag,
    required String titleWhenApplied,
    required this.product,
    required this.everyXUnit,
    bool isApplied = false,
  }) : super(
          id: id,
          title: title,
          type: DiscountType.freeProductEveryXUnit,
          tag: tag,
          titleWhenApplied: titleWhenApplied,
          isApplied: isApplied,
        );

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        tag,
        titleWhenApplied,
        product,
        everyXUnit,
      ];

  @override
  String toString() {
    return '''FreeProductEveryXUnitPromotion {
        id: $id
        title: $title
        type: $type
        tag: $tag
        titleWhenApplied: $titleWhenApplied
        product: $product
        everyXUnit: $everyXUnit
        isApplied: $isApplied
      }''';
  }

  FreeProductEveryXUnitPromotion copyWith({
    int? id,
    String? title,
    String? tag,
    String? titleWhenApplied,
    Product? product,
    int? everyXUnit,
    bool? isApplied,
  }) {
    return FreeProductEveryXUnitPromotion(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      titleWhenApplied: titleWhenApplied ?? this.titleWhenApplied,
      product: product ?? this.product,
      everyXUnit: everyXUnit ?? this.everyXUnit,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory FreeProductEveryXUnitPromotion.fromJson(Map<String, dynamic> json) =>
      FreeProductEveryXUnitPromotion(
        id: json["id"],
        title: json["title"],
        tag: json["tag"],
        titleWhenApplied: json["titleWhenApplied"],
        product: Product.fromJson(json["product"]),
        everyXUnit: json["everyXUnit"],
        isApplied: json["isApplied"] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "tag": tag,
        "titleWhenApplied": titleWhenApplied,
        "product": product.toJson(),
        "everyXUnit": everyXUnit,
        "isApplied": isApplied,
      };
}

class FreeProductEveryXTotalPromotion extends Discount {
  final Product product;
  final int everyXTotal;

  const FreeProductEveryXTotalPromotion({
    required int id,
    required String title,
    required String tag,
    required String titleWhenApplied,
    required this.product,
    required this.everyXTotal,
    bool isApplied = false,
  }) : super(
          id: id,
          title: title,
          type: DiscountType.freeProductEveryXTotal,
          tag: tag,
          titleWhenApplied: titleWhenApplied,
          isApplied: isApplied,
        );

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        tag,
        titleWhenApplied,
        product,
        everyXTotal,
      ];

  @override
  String toString() {
    return '''FreeProductEveryXTimesPromotion {
        id: $id,
        title: $title,
        type: $type,
        tag: $tag,
        titleWhenApplied: $titleWhenApplied,
        product: $product,
        everyXTotal: $everyXTotal,
        isApplied: $isApplied,
      }''';
  }

  FreeProductEveryXTotalPromotion copyWith({
    int? id,
    String? title,
    String? tag,
    String? titleWhenApplied,
    Product? product,
    int? everyXTotal,
    bool? isApplied,
  }) {
    return FreeProductEveryXTotalPromotion(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      titleWhenApplied: titleWhenApplied ?? this.titleWhenApplied,
      product: product ?? this.product,
      everyXTotal: everyXTotal ?? this.everyXTotal,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory FreeProductEveryXTotalPromotion.fromJson(Map<String, dynamic> json) =>
      FreeProductEveryXTotalPromotion(
        id: json["id"],
        title: json["title"],
        tag: json["tag"],
        titleWhenApplied: json["titleWhenApplied"],
        product: Product.fromJson(json["product"]),
        everyXTotal: json["everyXTotal"],
        isApplied: json["isApplied"] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "tag": tag,
        "titleWhenApplied": titleWhenApplied,
        "product": product.toJson(),
        "everyXTotal": everyXTotal,
        "isApplied": isApplied,
      };
}

class FlashSalePromotion extends Discount {
  final Money salePrice;
  final DateTime endTime;
  final DateTime startTime;

  const FlashSalePromotion({
    required int id,
    required String title,
    required String tag,
    required String titleWhenApplied,
    required this.salePrice,
    required this.endTime,
    required this.startTime,
    bool isApplied = false,
  }) : super(
          id: id,
          title: title,
          type: DiscountType.flashSale,
          tag: tag,
          titleWhenApplied: titleWhenApplied,
          isApplied: isApplied,
        );

  @override
  List<Object?> get props => [
        id,
        title,
        type,
        tag,
        titleWhenApplied,
        salePrice,
        endTime,
        startTime,
      ];

  @override
  String toString() {
    return '''FlashSalePromotion {
        id: $id,
        title: $title,
        type: $type,
        tag: $tag,
        titleWhenApplied: $titleWhenApplied,
        salePrice: $salePrice,
        endTime: $endTime,
        startTime: $startTime,
        isApplied: $isApplied,
      }''';
  }

  FlashSalePromotion copyWith({
    int? id,
    String? title,
    String? tag,
    String? titleWhenApplied,
    Money? salePrice,
    DateTime? endTime,
    DateTime? startTime,
    bool? isApplied,
  }) {
    return FlashSalePromotion(
      id: id ?? this.id,
      title: title ?? this.title,
      tag: tag ?? this.tag,
      titleWhenApplied: titleWhenApplied ?? this.titleWhenApplied,
      salePrice: salePrice ?? this.salePrice,
      endTime: endTime ?? this.endTime,
      startTime: startTime ?? this.startTime,
      isApplied: isApplied ?? this.isApplied,
    );
  }

  factory FlashSalePromotion.fromJson(Map<String, dynamic> json) =>
      FlashSalePromotion(
        id: json["id"],
        title: json["title"],
        tag: json["tag"],
        titleWhenApplied: json["titleWhenApplied"],
        salePrice: Money.fromJson(json["salePrice"]),
        endTime: DateTime.parse(json["endTime"]),
        startTime: DateTime.parse(json["startTime"]),
        isApplied: json["isApplied"] ?? false,
      );

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "tag": tag,
        "titleWhenApplied": titleWhenApplied,
        "salePrice": salePrice.toJson(),
        "endTime": endTime.toIso8601String(),
        "startTime": startTime.toIso8601String(),
        "isApplied": isApplied,
      };
}
