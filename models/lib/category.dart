import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category({
    this.id,
    this.name,
    this.code,
    this.categories,
  });

  final int? id;
  final String? name;
  final String? code;
  final List<Category>? categories;

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        categories,
      ];

  Category copyWith({
    int? id,
    String? name,
    String? code,
    List<Category>? categories,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      categories: categories ?? this.categories,
    );
  }

  @override
  String toString() =>
      'Category { id: $id, name: $name, code: $code, categories: $categories }';

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as int?,
        name: json['name'] as String?,
        code: json['code'] as String?,
        categories: (json['categories'] as List<dynamic>?)
            ?.map((e) => Category.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'categories': categories?.map((e) => e.toJson()).toList(),
      };
}
