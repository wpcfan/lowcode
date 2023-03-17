import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';
import 'package:page_repository/page_repository.dart';

import 'blocs/home_bloc.dart';
import 'blocs/home_event.dart';
import 'blocs/simple_observer.dart';
import 'views/home_view.dart';

/// 入口函数
/// 运行 Flutter 应用，也可以使用异步方式运行
/// ```dart
/// runAppAsync(() async {
///   await Future.delayed(const Duration(seconds: 3));
///   return const MyApp();
/// });
/// ```
void main() {
  /// 初始化 Bloc 的观察者，用于监听 Bloc 的生命周期
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

/// 根 Widget，也就是 Flutter 应用的根 Widget
/// 一般情况下，我们的应用都是从这里开始的
/// 我们可以在这里初始化一些全局的配置，比如主题、路由等
/// 我们也可以在这里初始化一些全局的对象，比如 Dio、SharedPreferences 等
/// 这个组件尽量保持简单，不要在这里做太多的事情
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        /// 这里使用了 Colors.blue 作为主题色，swatch 是一个颜色的色系
        /// 通过 swatch，我们可以获取到该色系的不同颜色
        /// 例如，我们可以通过 Colors.blue.shade100 来获取该色系的浅色
        /// 通过 Colors.blue.shade900 来获取该色系的深色
        /// 通过 Colors.blue.shade500 来获取该色系的中等色
        /// 通过 Colors.blue.shade50 来获取该色系的最浅色
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          foregroundColor: Colors.white,
        ),

        /// 使用最新的 Material Design 3.0 风格
        useMaterial3: true,
      ),
      home: const HomeViewWithProvider(),
    );
  }
}

class HomeViewWithProvider extends StatelessWidget {
  const HomeViewWithProvider({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    /// 使用 MultiRepositoryProvider 来管理多个 RepositoryProvider
    /// 使用 MultiBlocProvider 来管理多个 BlocProvider
    /// 这样做的好处是，我们可以在这里统一管理多个 RepositoryProvider 和 BlocProvider
    /// 而不需要在每个页面中都添加一个 RepositoryProvider 和 BlocProvider
    /// 如果我们需要添加一个新的 RepositoryProvider 或 BlocProvider
    /// 那么我们只需要在这里添加一个 RepositoryProvider 或 BlocProvider 即可
    /// 而不需要修改每个页面的代码
    return MultiRepositoryProvider(
      providers: [
        /// RepositoryProvider 用于管理 Repository，其实不光是 Repository，任何对象都可以通过 RepositoryProvider 来管理
        /// 它提供的是一种依赖注入的方式，可以在任何地方通过 context.read<T>() 来获取 RepositoryProvider 中的对象
        RepositoryProvider<Dio>(create: (context) => AppClient.getInstance()),
        RepositoryProvider<PageRepository>(
            create: (context) => PageRepository(client: context.read<Dio>())),
        RepositoryProvider<ProductRepository>(
            create: (context) =>
                ProductRepository(client: context.read<Dio>())),
      ],

      /// 使用 MultiBlocProvider 来管理多个 BlocProvider
      child: MultiBlocProvider(
        providers: [
          /// BlocProvider 用于管理 Bloc
          /// 在构造函数后面的 `..` 是级联操作符，可以用于连续调用多个方法
          /// 意思就是构造后立刻调用 add 方法，构造 HomeBloc 后立刻调用 HomeEventFetch 事件
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(
              pageRepo: context.read<PageRepository>(),
              productRepo: context.read<ProductRepository>(),
            )..add(const HomeEventFetch(PageType.home)),
          ),
        ],

        /// 需要注意的是，避免在这里使用 BlocBuilder 或 BlocListener
        /// 因为这里的 BlocProvider 还没有构造完成，所以这里的 BlocBuilder 和 BlocListener 会报错
        /// 如果需要使用 BlocBuilder 或 BlocListener，那么需要在子 Widget 中使用
        child: const HomeView(),
      ),
    );
  }
}
