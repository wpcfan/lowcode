import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:page_repository/page_repository.dart';

import 'helpers.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PageRepository pageRepo;
  final ProductRepository productRepo;
  HomeBloc({required this.pageRepo, required this.productRepo})
      : super(HomeState.initial()) {
    on<HomeEventFetch>(_onFetchHome,
        transformer: throttleDroppable(throttleDuration));
    on<HomeEventLoadMore>(_onLoadMore);
    on<HomeEventSwitchBottomNavigation>(_onSwitchBottomNavigation);
    on<HomeEventOpenDrawer>(_onOpenDrawer);
    on<HomeEventCloseDrawer>(_onCloseDrawer);
  }

  void _onOpenDrawer(HomeEvent event, Emitter<HomeState> emit) {
    state.scaffoldKey.currentState?.openEndDrawer();
    emit(state.copyWith(drawerOpen: true));
  }

  void _onCloseDrawer(HomeEvent event, Emitter<HomeState> emit) {
    state.scaffoldKey.currentState?.closeEndDrawer();
    emit(state.copyWith(drawerOpen: false));
  }

  void _onSwitchBottomNavigation(
      HomeEventSwitchBottomNavigation event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onFetchHome(HomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeState.loading());
    try {
      final layout = await pageRepo.getByPageType(event.pageType);
      if (layout.blocks.isEmpty) {
        emit(HomeState.error());
        return;
      }
      if (layout.blocks
          .where((element) => element.type == PageBlockType.waterfall)
          .isNotEmpty) {
        final waterfallBlock = layout.blocks.firstWhere(
                (element) => element.type == PageBlockType.waterfall)
            as WaterfallPageBlock;
        if (waterfallBlock.data.isNotEmpty) {
          final categoryId = waterfallBlock.data.first.content.id;
          if (categoryId != null) {
            final waterfall =
                await productRepo.getByCategory(categoryId: categoryId);
            emit(HomeState.populated(layout,
                waterfallList: waterfall.data,
                hasReachedMax: !waterfall.hasNext,
                page: waterfall.page,
                categoryId: categoryId));
            return;
          }
        }
      }
      emit(HomeState.populated(layout));
    } catch (e) {
      emit(HomeState.error());
    }
  }

  void _onLoadMore(HomeEvent event, Emitter<HomeState> emit) async {
    if (state.hasReachedMax) return;
    emit(state.copyWith(loadingMore: true));
    try {
      final waterfall = await productRepo.getByCategory(
          categoryId: state.categoryId!, page: state.page + 1);
      emit(state.copyWith(
        waterfallList: [...state.waterfallList, ...waterfall.data],
        hasReachedMax: !waterfall.hasNext,
        page: waterfall.page,
        loadingMore: false,
      ));
    } catch (e) {
      emit(state.copyWith(loadingMore: false));
    }
  }
}
