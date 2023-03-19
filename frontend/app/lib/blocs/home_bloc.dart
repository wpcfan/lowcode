import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'home_event.dart';
import 'home_state.dart';

/// HomeBloc
/// 主页的业务逻辑
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PageRepository pageRepo;
  final ProductRepository productRepo;
  HomeBloc({required this.pageRepo, required this.productRepo})
      : super(const HomeState(status: FetchStatus.initial)) {
    /// 首页内容加载
    on<HomeEventFetch>(_onFetchHome);

    /// 瀑布流加载更多
    on<HomeEventLoadMore>(_onLoadMore);

    /// 切换底部导航
    on<HomeEventSwitchBottomNavigation>(_onSwitchBottomNavigation);

    /// 打开抽屉
    on<HomeEventOpenDrawer>(_onOpenDrawer);

    /// 关闭抽屉
    on<HomeEventCloseDrawer>(_onCloseDrawer);
  }

  void _onOpenDrawer(HomeEvent event, Emitter<HomeState> emit) {
    if (event is HomeEventOpenDrawer) {
      event.scaffoldKey.currentState?.openEndDrawer();
    }
    emit(state.copyWith(drawerOpen: true));
  }

  void _onCloseDrawer(HomeEvent event, Emitter<HomeState> emit) {
    if (event is HomeEventCloseDrawer) {
      event.scaffoldKey.currentState?.closeEndDrawer();
    }
    emit(state.copyWith(drawerOpen: false));
  }

  void _onSwitchBottomNavigation(
      HomeEventSwitchBottomNavigation event, Emitter<HomeState> emit) {
    emit(state.copyWith(selectedIndex: event.index));
  }

  void _onFetchHome(HomeEvent event, Emitter<HomeState> emit) async {
    emit(state.copyWith(status: FetchStatus.loading));
    try {
      /// 获取首页布局
      final layout = await pageRepo.getByPageType(event.pageType);

      /// 如果没有布局，返回错误
      if (layout.blocks.isEmpty) {
        emit(state.copyWith(status: FetchStatus.error));
        return;
      }

      /// 如果有瀑布流布局，获取瀑布流数据
      if (layout.blocks
          .where((element) => element.type == PageBlockType.waterfall)
          .isNotEmpty) {
        /// 获取第一个瀑布流布局
        final waterfallBlock = layout.blocks
            .firstWhere((element) => element.type == PageBlockType.waterfall);

        /// 如果瀑布流布局有内容，获取瀑布流数据
        if (waterfallBlock.data.isNotEmpty) {
          /// 获取瀑布流数据的分类ID
          final categoryId = waterfallBlock.data.first.content.id;
          if (categoryId != null) {
            /// 按分类获取瀑布流中的产品数据
            final waterfall =
                await productRepo.getByCategory(categoryId: categoryId);
            emit(state.copyWith(
              status: FetchStatus.populated,
              layout: layout,
              waterfallList: waterfall.data,
              hasReachedMax: !waterfall.hasNext,
              page: waterfall.page,
              categoryId: categoryId,
            ));
            return;
          }
        }
      }
      emit(state.copyWith(
          status: FetchStatus.populated,
          layout: layout,
          hasReachedMax: true,
          page: 0,
          categoryId: null,
          waterfallList: []));
    } catch (e) {
      emit(state.copyWith(status: FetchStatus.error));
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
