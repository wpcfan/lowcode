import 'package:canvas/canvas.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pages/pages.dart';

import '../constants.dart';
import '../widgets/widgets.dart';

final scaffoldKey = GlobalKey<ScaffoldState>();
final innerScaffoldKey = GlobalKey<ScaffoldState>();

final routes = <RouteBase>[
  GoRoute(
    path: '/',
    builder: (context, state) => const PageTableView(),
    routes: [
      ShellRoute(
        builder: (context, state, child) => [
          // 只有桌面端才直接显示侧边栏
          if (Responsive.isDesktop(context))
            // 默认 flex = 1
            // 它占据 1/6 屏幕
            const SideMenu().expanded(),
          // 它占据 5/6 屏幕
          child.expanded(flex: 5),
        ].toRow(crossAxisAlignment: CrossAxisAlignment.start),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.parse(state.pathParameters['id']!);
              return CanvasPage(
                id: id,
                scaffoldKey: innerScaffoldKey,
              );
            },
          ),
        ],
      )
    ],
  ),
];

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    // 嵌套的路由使用 ShellRoute 包裹
    // 我们这里只想让 body 部分刷新，
    // 也就是切换路由时，只刷新 body 部分
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
