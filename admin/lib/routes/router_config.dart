import 'package:admin/components/header.dart';
import 'package:admin/components/side_menu.dart';
import 'package:admin/constants.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'routes.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    // 嵌套的路由使用 ShellRoute
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        drawer: const SideMenu(),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Header(),
          primary: true,
          backgroundColor: bgColor,
        ),
        body: SafeArea(
          child: Row(
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
        ),
      ),
      routes: routes,
    ),
  ],
);
