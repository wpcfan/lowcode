import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_repository/page_repository.dart';

import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  CategoryBloc(this.categoryRepository) : super(const CategoryState()) {
    on<CategoryEventLoad>(_onCategoryEventLoad);
    on<CategoryEventSearch>(_onCategoryEventSearch);
  }

  void _onCategoryEventSearch(
      CategoryEventSearch event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(keyword: event.keyword));
  }

  void _onCategoryEventLoad(
      CategoryEventLoad event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final categories = await categoryRepository.getCategories();
      emit(state.copyWith(categories: categories, loading: false, error: ''));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), loading: false));
    }
  }
}
