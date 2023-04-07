import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:models/models.dart';
import 'package:repositories/repositories.dart';

import 'home.dart';

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

        RepositoryProvider<PageRepository>(
            create: (context) => PageRepository()),
        RepositoryProvider<ProductRepository>(
            create: (context) => ProductRepository()),
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
