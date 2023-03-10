import 'package:admin/blocs/layout_bloc.dart';
import 'package:admin/blocs/layout_event.dart';
import 'package:admin/components/header.dart';
import 'package:admin/components/side_menu.dart';
import 'package:admin/constants.dart';
import 'package:admin/controllers/side_menu_controller.dart';
import 'package:admin/responsive.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:networking/networking.dart';
import 'package:page_repository/page_repository.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

final routerConfig = GoRouter(
  initialLocation: '/',
  routes: [
    // 嵌套的路由使用 ShellRoute
    ShellRoute(
      // 通过 MultiProvider 来管理多个 Provider
      builder: (context, state, child) => MultiRepositoryProvider(
        providers: [
          RepositoryProvider<Dio>(
            create: (context) => AdminClient.getInstance(),
          ),
          RepositoryProvider<PageAdminRepository>(
            create: (context) =>
                PageAdminRepository(client: context.read<Dio>()),
          ),
          RepositoryProvider<PageBlockRepository>(
            create: (context) =>
                PageBlockRepository(client: context.read<Dio>()),
          ),
          RepositoryProvider<PageBlockDataRepository>(
            create: (context) =>
                PageBlockDataRepository(client: context.read<Dio>()),
          ),
          RepositoryProvider<ProductRepository>(
            create: (context) => ProductRepository(
                client: context.read<Dio>(),
                baseUrl:
                    'http://localhost:8080/api/v1/app/products/by-category'),
          ),
          RepositoryProvider<FileAdminRepository>(
            create: (context) =>
                FileAdminRepository(client: context.read<Dio>()),
          ),
          RepositoryProvider<FileUploadRepository>(
            create: (context) => FileUploadRepository(),
          ),
          ChangeNotifierProvider(
            create: (context) => SideMenuController(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider<LayoutBloc>(
              create: (context) => LayoutBloc(
                context.read<PageAdminRepository>(),
              )..add(LayoutEventClearAll()),
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
      ),
      routes: routes,
    ),
  ],
);
