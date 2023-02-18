import 'package:models/models.dart';

class WaterfallState {
  final List<Product> products;
  final bool hasNext;
  final int page;
  final bool isLoading;
  final int pageSize;

  WaterfallState({
    this.products = const [],
    this.hasNext = false,
    this.page = 0,
    this.isLoading = false,
    this.pageSize = 10,
  });

  WaterfallState copyWith({
    List<Product>? products,
    bool? hasNext,
    int? page,
    bool? isLoading,
    int? pageSize,
  }) {
    return WaterfallState(
      products: products ?? this.products,
      hasNext: hasNext ?? this.hasNext,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  @override
  String toString() {
    return 'WaterfallState{products: $products, hasNext: $hasNext, page: $page, isLoading: $isLoading, pageSize: $pageSize}';
  }
}

class WaterfallInitial extends WaterfallState {
  WaterfallInitial() : super();
}

class WaterfallLoading extends WaterfallState {
  WaterfallLoading() : super(isLoading: true);
}

class WaterfallError extends WaterfallState {
  WaterfallError() : super();
}

class WaterfallPopulated extends WaterfallState {
  WaterfallPopulated(List<Product> result, bool hasNext, int page, int pageSize)
      : super(
            products: result, hasNext: hasNext, page: page, pageSize: pageSize);
}
