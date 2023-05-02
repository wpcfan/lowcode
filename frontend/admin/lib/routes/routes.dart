import 'package:canvas/canvas.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pages/pages.dart';

import '../widgets/widgets.dart';
import 'router_config.dart';

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
