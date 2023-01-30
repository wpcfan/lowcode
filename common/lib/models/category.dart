import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    this.id,
    this.name,
    this.image,
    this.categories,
  });

  final int? id;
  final String? name;
  final String? image;
  final List<Category>? categories;

  @override
  List<Object?> get props => [
        id,
        name,
        image,
        categories,
      ];

  Category copyWith({
    int? id,
    String? name,
    String? image,
    List<Category>? categories,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      image: image ?? this.image,
      categories: categories ?? this.categories,
    );
  }

  @override
  String toString() =>
      'Category { id: $id, name: $name, image: $image, categories: $categories }';

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as int?,
        name: json['name'] as String?,
        image: json['image'] as String?,
        categories: (json['categories'] as List<dynamic>?)
            ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'categories': categories?.map((e) => e.toJson()).toList(),
      };
}
