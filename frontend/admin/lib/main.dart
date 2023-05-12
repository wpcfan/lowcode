import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'constants.dart';
import 'routes/routes.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    debugPrint('${bloc.runtimeType} $change');
  }
}

void main() {
  /// 初始化 Bloc 的观察者，用于监听 Bloc 的生命周期
  Bloc.observer = SimpleBlocObserver();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // 根组件
  @override
  Widget build(BuildContext context) {
    /// 使用 MaterialApp.router 来初始化路由
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: '运营管理后台',

      /// 使用 ThemeData.dark 来初始化一个深色主题
      /// 使用 copyWith 来复制该主题，并修改部分属性
      theme: ThemeData.dark(useMaterial3: false).copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: Theme.of(context).textTheme.apply(bodyColor: Colors.white),
        canvasColor: secondaryColor,
        dataTableTheme: DataTableThemeData(
          headingRowColor: MaterialStateProperty.all(secondaryColor),
          dataRowColor: MaterialStateProperty.all(secondaryColor),
          dividerThickness: 0,
        ),
      ),

      /// 使用 GlobalMaterialLocalizations.delegate 来初始化 Material 组件的本地化
      /// 使用 GlobalWidgetsLocalizations.delegate 来初始化 Widget 组件的本地化
      /// 使用 GlobalCupertinoLocalizations.delegate 来初始化 Cupertino 组件的本地化
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      /// 使用 zh 来初始化中文本地化
      supportedLocales: const [
        Locale('zh'),
      ],

      /// 使用 routerConfig 来初始化路由
      routerConfig: routerConfig,
    );
  }
}
