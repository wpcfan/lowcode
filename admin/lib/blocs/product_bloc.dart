import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_repository/page_repository.dart';

import 'helpers.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository productRepository;
  ProductBloc(this.productRepository) : super(const ProductState()) {
    on<ProductEventSearchByKeyword>(_onProductEventSearchByKeyword,
        transformer: debounceDroppable(const Duration(milliseconds: 500)));
  }

  void _onProductEventSearchByKeyword(
    ProductEventSearchByKeyword event,
    Emitter<ProductState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    try {
      final products = await productRepository.searchByKeyword(event.keyword);
      emit(state.copyWith(
        products: products,
        loading: false,
        error: '',
        keyword: event.keyword,
      ));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }
}
