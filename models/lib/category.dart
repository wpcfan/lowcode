import 'package:equatable/equatable.dart';

class Category extends Equatable {
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

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        children,
      ];

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
