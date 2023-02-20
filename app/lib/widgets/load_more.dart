import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/home_bloc.dart';
import '../blocs/home_state.dart';

/// 瀑布流底部加载更多
class LoadMoreWidget extends StatelessWidget {
  const LoadMoreWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      /// buildWhen 用于控制是否需要重新构建
      /// 当 previous.waterfallList != current.waterfallList 时，才会重新构建
      /// 这样做的好处是，当我们需要重新构建时，我们可以通过 state.isEnd 来判断是否需要显示加载更多
      buildWhen: (previous, current) =>
          previous.waterfallList != current.waterfallList,
      builder: (context, state) {
        return state.isEnd
            ? Container()
            : const SizedBox(
                height: 50,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
    );
  }
}
