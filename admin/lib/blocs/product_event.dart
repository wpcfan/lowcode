import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class ProductEventSearchByKeyword extends ProductEvent {
  const ProductEventSearchByKeyword(this.keyword);

  final String keyword;

  @override
  List<Object?> get props => [keyword];
}
