import 'package:admin/repositories/github_repository.dart';

class SearchState {}

class SearchLoading extends SearchState {}

class SearchError extends SearchState {}

class SearchInitial extends SearchState {}

class SearchPopulated extends SearchState {
  final SearchResult result;

  SearchPopulated(this.result);
}

class SearchEmpty extends SearchState {}
