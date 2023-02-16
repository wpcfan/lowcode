import 'package:models/models.dart';

class PageLayoutState {}

class PageLayoutLoading extends PageLayoutState {}

class PageLayoutError extends PageLayoutState {}

class PageLayoutInitial extends PageLayoutState {}

class PageLayoutPopulated extends PageLayoutState {
  final PageLayout result;

  PageLayoutPopulated(this.result);
}
