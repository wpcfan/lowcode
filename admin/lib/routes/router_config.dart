import 'package:admin/components/header.dart';
import 'package:admin/components/side_menu.dart';
import 'package:admin/constants.dart';
import 'package:admin/controllers/side_menu_controller.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      // 通过 MultiProvider 来管理多个 Provider
      builder: (context, state, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => SideMenuController(),
          ),
        ],
        child: Builder(builder: (context) {
          return Scaffold(
            key: context.read<SideMenuController>().scaffoldKey,
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
          );
        }),
      ),
      routes: routes,
    ),
  ],
);
