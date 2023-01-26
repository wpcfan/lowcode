import 'package:flutter/material.dart';

/// Provider 模式是一种在 Flutter 中实现状态管理的方式，它可以让我们在任何地方都可以访问到数据。
/// 它是状态管理中非常简单的一种方式，但是它也有一些缺点，比如说它的数据是全局的，所以在使用的时候要注意。
class SideMenuController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void controlMenu() {
    if (!_scaffoldKey.currentState!.isDrawerOpen) {
      _scaffoldKey.currentState!.openDrawer();
    }
  }
}
