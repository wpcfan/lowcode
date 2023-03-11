import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class CategoryState extends Equatable {
  const CategoryState({
    this.categories = const [],
    this.loading = false,
    this.error = '',
    this.keyword = '',
  });
  final List<Category> categories;
  final bool loading;
  final String error;
  final String keyword;

  @override
  List<Object> get props => [categories, loading, error, keyword];

  CategoryState copyWith({
    List<Category>? categories,
    List<Category>? selectedCategories,
    bool? loading,
    String? error,
    String? keyword,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      keyword: keyword ?? this.keyword,
    );
  }

  List<Category> get flattenedCategories {
    return categories.expand((element) {
      final children = element.children ?? [];
      return [element, ...children];
    }).toList();
  }

  List<Category> get matchedCategories {
    if (keyword.isEmpty) {
      return flattenedCategories;
    }
    return flattenedCategories
        .where((element) =>
            element.name!.toLowerCase().contains(keyword.toLowerCase()))
        .toList();
  }
}
