import 'package:admin/repositories/page_repository.dart';
import 'package:common/common.dart';
import 'package:models/models.dart';
import 'package:rxdart/rxdart.dart';

import 'page_state.dart';

class PageSearchBloc {
  final Sink<String?> onTitleChanged;
  final Sink<Platform?> onPlatformChanged;
  final Sink<PageType?> onPageTypeChanged;
  final Sink<PageStatus?> onPageStatusChanged;
  final Sink<DateTime?> onStartDateFromChanged;
  final Sink<DateTime?> onStartDateToChanged;
  final Sink<DateTime?> onEndDateFromChanged;
  final Sink<DateTime?> onEndDateToChanged;
  final Sink<int> onPageSizeChanged;
  final Sink<PageQuery> onClearAll;

  final Stream<PageSearchState> state;

  factory PageSearchBloc(PageRepository repo) {
    final onTitleChanged = PublishSubject<String?>();
    final onPlatformChanged = PublishSubject<Platform?>();
    final onPageTypeChanged = PublishSubject<PageType?>();
    final onPageStatusChanged = PublishSubject<PageStatus?>();
    final onStartDateFromChanged = PublishSubject<DateTime?>();
    final onStartDateToChanged = PublishSubject<DateTime?>();
    final onEndDateFromChanged = PublishSubject<DateTime?>();
    final onEndDateToChanged = PublishSubject<DateTime?>();
    final onPageSizeChanged = PublishSubject<int>();
    final onClearAll = PublishSubject<PageQuery>();

    /// 使用 CombineLatestStream.combineX 的方式，参数是强类型的，但是有个数限制，最多 9 个
    /// 使用 CombineLatestStream.list 的方式，参数是 List<dynamic>，但是没有参数个数限制

    // final columnFilterStream = CombineLatestStream.combine9(
    //   onTitleChanged,
    //   onPlatformChanged,
    //   onPageTypeChanged,
    //   onPageStatusChanged,
    //   onStartDateFromChanged,
    //   onStartDateToChanged,
    //   onEndDateFromChanged,
    //   onEndDateToChanged,
    //   onPageSizeChanged,
    //   (title, platform, pageType, status, startDateFrom, startDateTo,
    //           endDateFrom, endDateTo, page) =>
    //       PageQuery(
    //     title: title,
    //     platform: platform,
    //     pageType: pageType,
    //     status: status,
    //     startDateFrom: startDateFrom?.formattedYYYYMMDD,
    //     startDateTo: startDateTo?.formattedYYYYMMDD,
    //     endDateFrom: endDateFrom?.formattedYYYYMMDD,
    //     endDateTo: endDateTo?.formattedYYYYMMDD,
    //     page: page,
    //   ),
    // );

    final columnFilterStream = CombineLatestStream.list(
      [
        onTitleChanged.startWith(null),
        onPlatformChanged.startWith(null),
        onPageTypeChanged.startWith(null),
        onPageStatusChanged.startWith(null),
        onStartDateFromChanged.startWith(null),
        onStartDateToChanged.startWith(null),
        onEndDateFromChanged.startWith(null),
        onEndDateToChanged.startWith(null),
        onPageSizeChanged.startWith(0),
      ],
    ).map((values) => PageQuery(
          title: values[0] as String?,
          platform: values[1] as Platform?,
          pageType: values[2] as PageType?,
          status: values[3] as PageStatus?,
          startDateFrom: (values[4] as DateTime?)?.formattedYYYYMMDD,
          startDateTo: (values[5] as DateTime?)?.formattedYYYYMMDD,
          endDateFrom: (values[6] as DateTime?)?.formattedYYYYMMDD,
          endDateTo: (values[7] as DateTime?)?.formattedYYYYMMDD,
          page: (values[8] as int?) ?? 0,
        ));

    final state = columnFilterStream
        .mergeWith([onClearAll])
        .distinct()
        .debounceTime(const Duration(milliseconds: 250))
        .switchMap<PageSearchState>((PageQuery query) => _search(query, repo))
        .startWith(PageSearchInitial());

    return PageSearchBloc._(
      onTitleChanged,
      onPlatformChanged,
      onPageTypeChanged,
      onPageStatusChanged,
      onStartDateFromChanged,
      onStartDateToChanged,
      onEndDateFromChanged,
      onEndDateToChanged,
      onPageSizeChanged,
      onClearAll,
      state,
    );
  }

  PageSearchBloc._(
    this.onTitleChanged,
    this.onPlatformChanged,
    this.onPageTypeChanged,
    this.onPageStatusChanged,
    this.onStartDateFromChanged,
    this.onStartDateToChanged,
    this.onEndDateFromChanged,
    this.onEndDateToChanged,
    this.onPageSizeChanged,
    this.onClearAll,
    this.state,
  );

  void dispose() {
    onTitleChanged.close();
    onPlatformChanged.close();
    onPageTypeChanged.close();
    onPageStatusChanged.close();
    onStartDateFromChanged.close();
    onStartDateToChanged.close();
    onEndDateFromChanged.close();
    onEndDateToChanged.close();
    onPageSizeChanged.close();
    onClearAll.close();
  }

  static Stream<PageSearchState> _search(
      PageQuery query, PageRepository repo) async* {
    yield PageSearchLoading();
    try {
      final pages = await repo.search(query);
      yield PageSearchPopulated(pages, query);
    } catch (e) {
      yield PageSearchError();
    }
  }
}
