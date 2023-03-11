import 'package:equatable/equatable.dart';
import 'package:models/models.dart';

class ProductState extends Equatable {
  final List<Product> products;
  final bool loading;
  final String error;
  final String keyword;

  const ProductState({
    this.products = const [],
    this.loading = false,
    this.error = '',
    this.keyword = '',
  });

  @override
  List<Object?> get props => [products, loading, error, keyword];

  ProductState copyWith({
    List<Product>? products,
    bool? loading,
    String? error,
    String? keyword,
  }) {
    return ProductState(
      products: products ?? this.products,
      loading: loading ?? this.loading,
      error: error ?? this.error,
      keyword: keyword ?? this.keyword,
    );
  }
}
