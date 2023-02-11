import 'package:equatable/equatable.dart';

import 'category.dart';

class Product extends Equatable {
  const Product({
    this.id,
    this.name,
    this.description,
    this.price,
    this.images = const [],
    this.categories,
  });

  final String? id;
  final String? name;
  final String? description;
  final int? price;
  final List<String> images;
  final List<Category>? categories;

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        price,
        images,
        categories,
      ];

  Product copyWith({
    String? id,
    String? name,
    String? description,
    int? price,
    List<String>? images,
    List<Category>? categories,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      images: images ?? this.images,
      categories: categories ?? this.categories,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, images: $images, categories: $categories)';
  }

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String?,
        name: json['name'] as String?,
        description: json['description'] as String?,
        price: (json['price'] as num?)?.toInt(),
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
        'name': name,
        'description': description,
        'price': price,
        'images': images,
        'categories': categories?.map((e) => e.toJson()).toList(),
      };
}