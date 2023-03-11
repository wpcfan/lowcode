import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class CategoryEventLoad extends CategoryEvent {
  const CategoryEventLoad();
  @override
  List<Object?> get props => [];
}

class CategoryEventSearch extends CategoryEvent {
  const CategoryEventSearch(this.keyword);
  final String keyword;
  @override
  List<Object?> get props => [keyword];
}

class CategoryEventToggle extends CategoryEvent {
  const CategoryEventToggle(this.categoryId);
  final int categoryId;
  @override
  List<Object?> get props => [categoryId];
}
