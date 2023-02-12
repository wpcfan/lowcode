part of 'page_block.dart';

class CategoryData extends Equatable {
  final int sort;
  final Category data;

  const CategoryData({required this.sort, required this.data});

  @override
  List<Object?> get props => [sort, data];

  factory CategoryData.fromJson(Map<String, dynamic> json) {
    return CategoryData(
      sort: json['sort'],
      data: Category.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sort': sort,
      'data': data.toJson(),
    };
  }

  CategoryData copyWith({
    int? sort,
    Category? data,
  }) {
    return CategoryData(
      sort: sort ?? this.sort,
      data: data ?? this.data,
    );
  }

  @override
  String toString() => 'CategoryData(sort: $sort, data: $data)';
}
