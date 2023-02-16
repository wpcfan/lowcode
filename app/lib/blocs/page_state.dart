import 'package:models/models.dart';

enum FetchStatus {
  initial,
  loading,
  populated,
  error,
}

class PageLayoutState {
  final FetchStatus status;
  final PageLayout? result;

  PageLayoutState({this.status = FetchStatus.initial, this.result});

  PageLayoutState copyWith({FetchStatus? status, PageLayout? result}) {
    return PageLayoutState(
      status: status ?? this.status,
      result: result ?? this.result,
    );
  }

  @override
  String toString() {
    return 'PageLayoutState{status: $status, result: $result}';
  }
}

class PageLayoutLoading extends PageLayoutState {
  PageLayoutLoading() : super(status: FetchStatus.loading);
}

class PageLayoutError extends PageLayoutState {
  PageLayoutError() : super(status: FetchStatus.error);
}

class PageLayoutInitial extends PageLayoutState {
  PageLayoutInitial() : super(status: FetchStatus.initial);
}

class PageLayoutPopulated extends PageLayoutState {
  PageLayoutPopulated(PageLayout result)
      : super(status: FetchStatus.populated, result: result);
}
