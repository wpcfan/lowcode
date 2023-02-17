import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class Category extends Equatable {
  const Category({
    this.id,
    this.name,
    this.code,
    this.categories,
    this.productSlice,
  });

  final int? id;
  final String? name;
  final String? code;
  final List<Category>? categories;
  final SliceWrapper<Product>? productSlice;

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        categories,
        productSlice,
      ];

  Category copyWith({
    int? id,
    String? name,
    String? code,
    List<Category>? categories,
    SliceWrapper<Product>? productSlice,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      categories: categories ?? this.categories,
      productSlice: productSlice ?? this.productSlice,
    );
  }

  @override
  String toString() =>
      'Category { id: $id, name: $name, code: $code, categories: $categories, productSlice: $productSlice }';

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as int?,
        name: json['name'] as String?,
        code: json['code'] as String?,
        categories: (json['categories'] as List<dynamic>?)
            ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),
        productSlice: json['products'] == null
            ? null
            : SliceWrapper<Product>.fromJson(
                json['products'] as Map<String, dynamic>, Product.fromJson),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'categories': categories?.map((e) => e.toJson()).toList(),
        'products': productSlice?.toJson(),
      };
}
