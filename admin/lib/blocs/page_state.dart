import '../repositories/page_repository.dart';

class PageSearchState {}

class PageSearchLoading extends PageSearchState {}

class PageSearchError extends PageSearchState {}

class PageSearchInitial extends PageSearchState {}

class PageSearchPopulated extends PageSearchState {
  final PageWrapper<PageSearchResultItem> result;

  PageSearchPopulated(this.result);
}

class PageSearchEmpty extends PageSearchState {}
