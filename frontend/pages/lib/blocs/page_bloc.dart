import 'package:common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'page_event.dart';
import 'page_state.dart';

class PageBloc extends Bloc<PageEvent, PageState> {
  final PageAdminRepository adminRepo;
  PageBloc(this.adminRepo) : super(PageState.initial()) {
    on<PageEventTitleChanged>(_onPageEventTitleChanged);
    on<PageEventPlatformChanged>(_onPageEventPlatformChanged);
    on<PageEventPageTypeChanged>(_onPageEventPageTypeChanged);
    on<PageEventPageStatusChanged>(_onPageEventPageStatusChanged);
    on<PageEventStartDateChanged>(_onPageEventStartDateChanged);
    on<PageEventEndDateChanged>(_onPageEventEndDateChanged);
    on<PageEventPageChanged>(_onPageEventPageChanged);
    on<PageEventCreate>(_onPageEventCreate);
    on<PageEventUpdate>(_onPageEventUpdate);
    on<PageEventDelete>(_onPageEventDelete);
    on<PageEventClearAll>(_onPageEventClearAll);
    on<PageEventPublish>(_onPageEventPublish);
    on<PageEventDraft>(_onPageEventDraft);
    on<PageEventClearError>(_onPageEventClearError);
  }

  void _onPageEventClearError(
      PageEventClearError event, Emitter<PageState> emit) async {
    emit(state.copyWith(error: ''));
  }

  void _onPageEventPublish(
      PageEventPublish event, Emitter<PageState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final layout =
          await adminRepo.publish(event.id, event.startTime, event.endTime);
      final index = state.items.indexWhere((element) => element.id == event.id);
      emit(state.copyWith(
        loading: false,
        items: [
          ...state.items.sublist(0, index),
          layout,
          ...state.items.sublist(index + 1)
        ],
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onPageEventDraft(PageEventDraft event, Emitter<PageState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final layout = await adminRepo.draft(event.id);
      final index = state.items.indexWhere((element) => element.id == event.id);
      emit(state.copyWith(
        loading: false,
        items: [
          ...state.items.sublist(0, index),
          layout,
          ...state.items.sublist(index + 1)
        ],
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onPageEventClearAll(
      PageEventClearAll event, Emitter<PageState> emit) async {
    const query = PageQuery();
    emit(state.copyWith(query: query));
    await _query(query, emit);
  }

  void _onPageEventDelete(
      PageEventDelete event, Emitter<PageState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      await adminRepo.delete(event.id);
      final index = state.items.indexWhere((element) => element.id == event.id);
      emit(state.copyWith(
        loading: false,
        items: [
          ...state.items.sublist(0, index),
          ...state.items.sublist(index + 1)
        ],
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onPageEventUpdate(
      PageEventUpdate event, Emitter<PageState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final layout = await adminRepo.update(event.id, event.layout);
      final index = state.items.indexWhere((element) => element.id == event.id);
      emit(state.copyWith(
        loading: false,
        items: [
          ...state.items.sublist(0, index),
          layout,
          ...state.items.sublist(index + 1)
        ],
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onPageEventCreate(
      PageEventCreate event, Emitter<PageState> emit) async {
    emit(state.copyWith(loading: true));
    try {
      final layout = await adminRepo.create(event.layout);
      emit(state.copyWith(
        loading: false,
        items: [layout, ...state.items],
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(loading: false, error: e.toString()));
    }
  }

  void _onPageEventEndDateChanged(
      PageEventEndDateChanged event, Emitter<PageState> emit) async {
    if (event.endDateFrom != null && event.endDateTo != null) {
      final pageQuery = state.query.copyWith(
        endDateFrom: event.endDateFrom?.formattedYYYYMMDD,
        endDateTo: event.endDateTo?.formattedYYYYMMDD,
      );
      await _query(pageQuery, emit);
    } else {
      final pageQuery = state.query.clear('endDateFrom').clear('endDateTo');
      await _query(pageQuery, emit);
    }
  }

  void _onPageEventStartDateChanged(
      PageEventStartDateChanged event, Emitter<PageState> emit) async {
    if (event.startDateFrom != null && event.startDateTo != null) {
      final pageQuery = state.query.copyWith(
        startDateFrom: event.startDateFrom?.formattedYYYYMMDD,
        startDateTo: event.startDateTo?.formattedYYYYMMDD,
      );
      await _query(pageQuery, emit);
    } else {
      final pageQuery = state.query.clear('startDateFrom').clear('startDateTo');
      await _query(pageQuery, emit);
    }
  }

  void _onPageEventPageStatusChanged(
      PageEventPageStatusChanged event, Emitter<PageState> emit) async {
    final pageQuery = event.pageStatus != null
        ? state.query.copyWith(
            status: event.pageStatus,
          )
        : state.query.clear('status');
    await _query(pageQuery, emit);
  }

  void _onPageEventPageTypeChanged(
      PageEventPageTypeChanged event, Emitter<PageState> emit) async {
    final pageQuery = event.pageType != null
        ? state.query.copyWith(
            pageType: event.pageType,
          )
        : state.query.clear('pageType');
    await _query(pageQuery, emit);
  }

  void _onPageEventPlatformChanged(
      PageEventPlatformChanged event, Emitter<PageState> emit) async {
    final pageQuery = event.platform != null
        ? state.query.copyWith(
            platform: event.platform,
          )
        : state.query.clear('platform');
    await _query(pageQuery, emit);
  }

  void _onPageEventTitleChanged(
      PageEventTitleChanged event, Emitter<PageState> emit) async {
    final pageQuery = event.title != null
        ? state.query.copyWith(
            title: event.title,
          )
        : state.query.clear('title');
    await _query(pageQuery, emit);
  }

  void _onPageEventPageChanged(
      PageEventPageChanged event, Emitter<PageState> emit) async {
    final pageQuery = event.page != null
        ? state.query.copyWith(
            page: event.page,
          )
        : state.query.clear('page');
    await _query(pageQuery, emit);
  }

  Future<void> _query(PageQuery pageQuery, Emitter<PageState> emit) async {
    emit(state.copyWith(
      status: FetchStatus.loading,
    ));
    try {
      final response = await adminRepo.search(pageQuery);
      emit(state.copyWith(
        items: response.items,
        total: response.totalSize,
        page: response.page,
        pageSize: response.size,
        query: pageQuery,
        status: FetchStatus.populated,
        error: '',
      ));
    } catch (e) {
      emit(state.copyWith(
        error: e.toString(),
        status: FetchStatus.error,
      ));
    }
  }
}
