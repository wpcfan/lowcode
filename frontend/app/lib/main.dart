import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:home/home.dart';

import 'blocs/simple_observer.dart';

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
