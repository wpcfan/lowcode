import 'package:admin/components/header.dart';
import 'package:admin/components/search_field_with_bloc.dart';
import 'package:admin/components/side_menu.dart';
import 'package:admin/constants.dart';
import 'package:admin/controllers/menu_controller.dart';
import 'package:admin/pages/canvas_page.dart';
import 'package:admin/pages/dashboard_page.dart';
import 'package:admin/repositories/github_repository.dart';
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => MenuController(),
          ),
        ],
        child: Builder(builder: (context) {
          return Scaffold(
            key: context.read<MenuController>().scaffoldKey,
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
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          builder: (context, state) => const DashboardPage(),
          routes: [
            GoRoute(
              path: 'search',
              builder: (context, state) => SearchFieldWithBloc(
                api: GithubRepository(),
              ),
            ),
            GoRoute(
                path: 'draggable',
                builder: (context, state) => const CanvasPage()),
          ],
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const DashboardPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                // Change the opacity of the screen using a Curve based on the the animation's
                // value
                return FadeTransition(
                  opacity: CurveTween(curve: Curves.easeInOutCirc)
                      .animate(animation),
                  child: child,
                );
              },
            );
          },
        ),
      ],
    ),
  ],
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Admin Panel',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
      ),
      // 通过 MultiProvider 来管理多个 Provider
      routerConfig: _router,
    );
  }
}
