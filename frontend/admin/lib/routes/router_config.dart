import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants.dart';
import '../widgets/widgets.dart';
import 'routes.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();
final innerScaffoldKey = GlobalKey<ScaffoldState>();

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    // 嵌套的路由使用 ShellRoute
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        key: scaffoldKey,
        drawer: const SideMenu(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Header(),
          primary: true,
          backgroundColor: bgColor,
        ),
        body: SafeArea(child: child),
      ),
      routes: routes,
    ),
  ],
);
