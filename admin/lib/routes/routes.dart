import 'package:admin/components/search_field_with_bloc.dart';
import 'package:admin/pages/dashboard_page.dart';
import 'package:admin/pages/drag_drop_list_page.dart';
import 'package:admin/pages/drag_drop_page.dart';
import 'package:admin/repositories/github_repository.dart';
import 'package:go_router/go_router.dart';

import 'custom_slide_transition.dart';

final routes = <RouteBase>[
  GoRoute(
    path: '/',
    builder: (context, state) => const DashboardPage(),
    routes: [
      GoRoute(
        path: 'search',
        builder: (context, state) => SearchFieldWithBloc(
          api: GithubRepository(),
        ),
        pageBuilder: (context, state) => CustomSlideTransition(
            key: state.pageKey,
            child: SearchFieldWithBloc(
              api: GithubRepository(),
            )),
      ),
      GoRoute(
        path: 'draggable',
        builder: (context, state) => const DragDropPage(),
        pageBuilder: (context, state) => CustomSlideTransition(
            key: state.pageKey, child: const DragDropPage()),
      ),
      GoRoute(
        path: 'dragdrop',
        builder: (context, state) => const DragDropListPage(),
        pageBuilder: (context, state) => CustomSlideTransition(
            key: state.pageKey, child: const DragDropListPage()),
      ),
    ],
    pageBuilder: (context, state) =>
        CustomSlideTransition(key: state.pageKey, child: const DashboardPage()),
  ),
];
