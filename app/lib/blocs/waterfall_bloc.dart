import 'dart:async';

import 'package:page_repository/page_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'waterfall_state.dart';

class WaterfallBloc {
  final Sink<int> onLoadMore;
  final Sink<int> onCategoryChanged;
  final Stream<WaterfallState> state;

  factory WaterfallBloc(ProductRepository repo) {
    final onLoadMore = PublishSubject<int>();
    final onCategoryChanged = PublishSubject<int>();

    final state = CombineLatestStream.list(
      [
        onCategoryChanged,
        onLoadMore.startWith(0),
      ],
    ).switchMap((value) => _getByCategory(value[0], value[1], repo)).scan(
        (acc, curr, _) {
      if (curr is WaterfallPopulated) {
        return WaterfallPopulated(
          [...curr.products, ...acc.products],
          curr.hasNext,
          curr.page,
          curr.pageSize,
        );
      }
      return curr;
    }, WaterfallState()).shareReplay(maxSize: 1);

    return WaterfallBloc._(
      onLoadMore: onLoadMore,
      onCategoryChanged: onCategoryChanged,
      state: state,
    );
  }

  WaterfallBloc._({
    required this.onLoadMore,
    required this.onCategoryChanged,
    required this.state,
  });

  void dispose() {
    onLoadMore.close();
    onCategoryChanged.close();
  }

  static Stream<WaterfallState> _getByCategory(
      int categoryId, int page, ProductRepository repo) async* {
    yield WaterfallState(isLoading: true);
    try {
      final productSlice =
          await repo.getByCategory(categoryId: categoryId, page: page);
      yield WaterfallPopulated(productSlice.data, productSlice.hasNext,
          productSlice.page, productSlice.size);
    } catch (e) {
      yield WaterfallState();
    }
  }
}
