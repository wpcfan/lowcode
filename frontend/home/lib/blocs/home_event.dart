import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

abstract class HomeEvent extends Equatable {
  final PageType pageType;

  const HomeEvent(this.pageType);

  @override
  List<Object> get props => [pageType];
}

class HomeEventFetch extends HomeEvent {
  const HomeEventFetch(PageType pageType) : super(pageType);
}

class HomeEventLoadMore extends HomeEvent {
  const HomeEventLoadMore() : super(PageType.home);
}

class HomeEventSwitchBottomNavigation extends HomeEvent {
  final int index;

  const HomeEventSwitchBottomNavigation(this.index) : super(PageType.home);
}

class HomeEventOpenDrawer extends HomeEvent {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeEventOpenDrawer(this.scaffoldKey) : super(PageType.home);
}

class HomeEventCloseDrawer extends HomeEvent {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const HomeEventCloseDrawer(this.scaffoldKey) : super(PageType.home);
}
