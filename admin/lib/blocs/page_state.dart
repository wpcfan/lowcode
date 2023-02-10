import '../repositories/page_repository.dart';

class PageSearchState {}

class PageSearchLoading extends PageSearchState {}

class PageSearchError extends PageSearchState {}

class PageSearchInitial extends PageSearchState {}

class PageSearchPopulated extends PageSearchState {
  final PageWrapper<PageSearchResultItem> result;
  final PageQuery query;

  PageSearchPopulated(this.result, this.query);
}
