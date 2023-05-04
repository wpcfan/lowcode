import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

abstract class HomeEvent extends Equatable {
  final PageType pageType;

  const HomeEvent(this.pageType);

  @override
  List<Object> get props => [pageType];
}

/// 首页数据加载
class HomeEventFetch extends HomeEvent {
  const HomeEventFetch(PageType pageType) : super(pageType);
}

/// 上拉加载更多
class HomeEventLoadMore extends HomeEvent {
  const HomeEventLoadMore() : super(PageType.home);
}

/// 切换底部导航栏
class HomeEventSwitchBottomNavigation extends HomeEvent {
  final int index;

  const HomeEventSwitchBottomNavigation(this.index) : super(PageType.home);
}

/// 打开抽屉
class HomeEventOpenDrawer extends HomeEvent {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeEventOpenDrawer(this.scaffoldKey) : super(PageType.home);
}

/// 关闭抽屉
class HomeEventCloseDrawer extends HomeEvent {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeEventCloseDrawer(this.scaffoldKey) : super(PageType.home);
}
