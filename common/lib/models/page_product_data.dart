part of 'page.dart';

class ProductData extends Equatable {
  final int sort;
  final Product product;

  const ProductData({required this.sort, required this.product});

  factory ProductData.fromJson(Map<String, dynamic> json) {
    return ProductData(
      sort: json['sort'],
      product: Product.fromJson(json['product']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sort': sort,
      'product': product.toJson(),
    };
  }

  @override
  List<Object?> get props => [sort, product];
}
