import 'package:admin/repositories/page_repository.dart';
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

    final state = CombineLatestStream.combine8(
      onTitleChanged.startWith(null),
      onPlatformChanged.startWith(null),
      onPageTypeChanged.startWith(null),
      onPageStatusChanged.startWith(null),
      onStartDateFromChanged.startWith(null),
      onStartDateToChanged.startWith(null),
      onEndDateFromChanged.startWith(null),
      onEndDateToChanged.startWith(null),
      (String? title,
          Platform? platform,
          PageType? pageType,
          PageStatus? pageStatus,
          DateTime? startDateFrom,
          DateTime? startDateTo,
          DateTime? endDateFrom,
          DateTime? endDateTo) {
        return PageQuery(
          title: title,
          platform: platform,
          pageType: pageType,
          status: pageStatus,
          startDateFrom: startDateFrom?.formattedYYYYMMDDHHmmsss,
          startDateTo: startDateTo?.formattedYYYYMMDDHHmmsss,
          endDateFrom: endDateFrom?.formattedYYYYMMDDHHmmsss,
          endDateTo: endDateTo?.formattedYYYYMMDDHHmmsss,
        );
      },
    )
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
  }

  static Stream<PageSearchState> _search(
      PageQuery query, PageRepository repo) async* {
    yield PageSearchLoading();
    try {
      final pages = await repo.search(query);
      if (pages.isEmpty) {
        yield PageSearchEmpty();
      } else {
        yield PageSearchPopulated(pages);
      }
    } catch (e) {
      yield PageSearchError();
    }
  }
}

extension DateTimeExtension on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
  String get formattedYYYYMMDDHHmmsss =>
      '${year.toString().padLeft(4, '0')}${month.toString().padLeft(2, '0')}${day.toString().padLeft(2, '0')}${hour.toString().padLeft(2, '0')}${minute.toString().padLeft(2, '0')}${second.toString().padLeft(2, '0')}';
}
