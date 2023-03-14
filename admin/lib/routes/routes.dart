import 'package:canvas/canvas.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pages/pages.dart';

import '../components/side_menu.dart';
import 'custom_slide_transition.dart';
import 'router_config.dart';

final routes = <RouteBase>[
  GoRoute(
    path: '/',
    builder: (context, state) => const PageTableView(),
    routes: [
      ShellRoute(
        builder: (context, state, child) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 只有桌面端才直接显示侧边栏
            if (Responsive.isDesktop(context))
              const Expanded(
                // 默认 flex = 1
                // 它占据 1/6 屏幕
                child: SideMenu(),
              ),
            Expanded(
              // 它占据 5/6 屏幕
              flex: 5,
              child: child,
            ),
          ],
        ),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.parse(state.params['id']!);
              return CanvasPage(
                id: id,
                scaffoldKey: innerScaffoldKey,
              );
            },
            pageBuilder: (context, state) {
              final id = int.parse(state.params['id']!);
              return CustomSlideTransition(
                  key: state.pageKey,
                  child: CanvasPage(
                    id: id,
                    scaffoldKey: innerScaffoldKey,
                  ));
            },
          ),
        ],
      )
    ],
  ),
];
