import 'package:common/common.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_repository/page_repository.dart';

import 'layout_event.dart';
import 'layout_state.dart';

class LayoutBloc extends Bloc<LayoutEvent, LayoutState> {
  final PageAdminRepository adminRepo;
  LayoutBloc(this.adminRepo) : super(LayoutState.initial()) {
    on<LayoutEventTitleChanged>(_onLayoutEventTitleChanged);
    on<LayoutEventPlatformChanged>(_onLayoutEventPlatformChanged);
    on<LayoutEventPageTypeChanged>(_onLayoutEventPageTypeChanged);
    on<LayoutEventPageStatusChanged>(_onLayoutEventPageStatusChanged);
    on<LayoutEventStartDateChanged>(_onLayoutEventStartDateChanged);
    on<LayoutEventEndDateChanged>(_onLayoutEventEndDateChanged);
    on<LayoutEventPageChanged>(_onLayoutEventPageChanged);
    on<LayoutEventCreate>(_onLayoutEventCreate);
    on<LayoutEventUpdate>(_onLayoutEventUpdate);
    on<LayoutEventDelete>(_onLayoutEventDelete);
    on<LayoutEventClearAll>(_onLayoutEventClearAll);
    on<LayoutEventPublish>(_onLayoutEventPublish);
    on<LayoutEventDraft>(_onLayoutEventDraft);
  }

  void _onLayoutEventPublish(
      LayoutEventPublish event, Emitter<LayoutState> emit) async {
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

  void _onLayoutEventDraft(
      LayoutEventDraft event, Emitter<LayoutState> emit) async {
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

  void _onLayoutEventClearAll(
      LayoutEventClearAll event, Emitter<LayoutState> emit) async {
    const query = PageQuery();
    emit(state.copyWith(query: query));
    await _query(query, emit);
  }

  void _onLayoutEventDelete(
      LayoutEventDelete event, Emitter<LayoutState> emit) async {
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

  void _onLayoutEventUpdate(
      LayoutEventUpdate event, Emitter<LayoutState> emit) async {
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

  void _onLayoutEventCreate(
      LayoutEventCreate event, Emitter<LayoutState> emit) async {
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

  void _onLayoutEventEndDateChanged(
      LayoutEventEndDateChanged event, Emitter<LayoutState> emit) async {
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

  void _onLayoutEventStartDateChanged(
      LayoutEventStartDateChanged event, Emitter<LayoutState> emit) async {
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

  void _onLayoutEventPageStatusChanged(
      LayoutEventPageStatusChanged event, Emitter<LayoutState> emit) async {
    final pageQuery = event.pageStatus != null
        ? state.query.copyWith(
            status: event.pageStatus,
          )
        : state.query.clear('status');
    await _query(pageQuery, emit);
  }

  void _onLayoutEventPageTypeChanged(
      LayoutEventPageTypeChanged event, Emitter<LayoutState> emit) async {
    final pageQuery = event.pageType != null
        ? state.query.copyWith(
            pageType: event.pageType,
          )
        : state.query.clear('pageType');
    await _query(pageQuery, emit);
  }

  void _onLayoutEventPlatformChanged(
      LayoutEventPlatformChanged event, Emitter<LayoutState> emit) async {
    final pageQuery = event.platform != null
        ? state.query.copyWith(
            platform: event.platform,
          )
        : state.query.clear('platform');
    await _query(pageQuery, emit);
  }

  void _onLayoutEventTitleChanged(
      LayoutEventTitleChanged event, Emitter<LayoutState> emit) async {
    final pageQuery = event.title != null
        ? state.query.copyWith(
            title: event.title,
          )
        : state.query.clear('title');
    await _query(pageQuery, emit);
  }

  void _onLayoutEventPageChanged(
      LayoutEventPageChanged event, Emitter<LayoutState> emit) async {
    final pageQuery = event.page != null
        ? state.query.copyWith(
            page: event.page,
          )
        : state.query.clear('page');
    await _query(pageQuery, emit);
  }

  Future<void> _query(PageQuery pageQuery, Emitter<LayoutState> emit) async {
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
