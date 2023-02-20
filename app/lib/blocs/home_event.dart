import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:models/models.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent(this.pageType);
  final PageType pageType;
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
  const HomeEventSwitchBottomNavigation(int index)
      : _index = index,
        super(PageType.home);
  final int _index;
  int get index => _index;
}

class HomeEventOpenDrawer extends HomeEvent {
  const HomeEventOpenDrawer(GlobalKey<ScaffoldState> scaffoldKey)
      : _scaffoldKey = scaffoldKey,
        super(PageType.home);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
}

class HomeEventCloseDrawer extends HomeEvent {
  const HomeEventCloseDrawer(GlobalKey<ScaffoldState> scaffoldKey)
      : _scaffoldKey = scaffoldKey,
        super(PageType.home);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
}
