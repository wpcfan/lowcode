import 'package:models/models.dart';
import 'package:page_repository/page_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'page_state.dart';

class PageLayoutBloc {
  final Sink<PageType> onPageTypeChanged;

  final Stream<PageLayoutState> state;

  factory PageLayoutBloc(PageRepository repo) {
    final onPageTypeChanged = PublishSubject<PageType>();

    final state = onPageTypeChanged
        .startWith(PageType.home)
        .switchMap((value) => _getByType(value, repo));

    return PageLayoutBloc._(
      onPageTypeChanged: onPageTypeChanged,
      state: state,
    );
  }

  PageLayoutBloc._({
    required this.onPageTypeChanged,
    required this.state,
  });

  void dispose() {
    onPageTypeChanged.close();
  }

  static Stream<PageLayoutState> _getByType(
      PageType pageType, PageRepository repo) async* {
    try {
      final page = await repo.getByPageType(pageType);
      yield PageLayoutPopulated(page);
    } catch (e) {
      yield PageLayoutError();
    }
  }
}
