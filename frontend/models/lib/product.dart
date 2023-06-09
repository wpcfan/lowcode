import 'package:equatable/equatable.dart';

import 'category.dart';

class Product extends Equatable {
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

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        originalPrice,
        images,
        categories,
      ];

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
