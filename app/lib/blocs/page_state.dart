import 'package:models/models.dart';

enum FetchStatus {
  initial,
  loading,
  populated,
  error,
}

class PageLayoutState {
  final FetchStatus status;
  final PageLayout? layout;

  PageLayoutState({
    this.status = FetchStatus.initial,
    this.layout,
  });

  PageLayoutState copyWith({
    FetchStatus? status,
    PageLayout? layout,
  }) {
    return PageLayoutState(
      status: status ?? this.status,
      layout: layout ?? this.layout,
    );
  }

  @override
  String toString() {
    return 'PageLayoutState{status: $status, layout: $layout}';
  }
}

class PageLayoutLoading extends PageLayoutState {
  PageLayoutLoading() : super(status: FetchStatus.loading);
}

class PageLayoutError extends PageLayoutState {
  PageLayoutError() : super(status: FetchStatus.error);
}

class PageLayoutInitial extends PageLayoutState {
  PageLayoutInitial()
      : super(
          status: FetchStatus.initial,
          layout: null,
        );
}

class PageLayoutPopulated extends PageLayoutState {
  PageLayoutPopulated(PageLayout result)
      : super(status: FetchStatus.populated, layout: result);
}
