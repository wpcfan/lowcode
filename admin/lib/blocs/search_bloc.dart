import 'dart:async';

import 'package:admin/repositories/github_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'search_state.dart';

class SearchBloc {
  // Sink 是一个 Stream 的输入，可以通过它来添加新的事件
  final Sink<String> onTextChanged;
  // Stream 是一个输出，可以通过它来获取新的状态
  final Stream<SearchState> state;

  // 工厂构造函数，用于创建 SearchBloc
  factory SearchBloc(GithubRepository repo) {
    // 用于接收搜索词的 Stream
    final onTextChanged = PublishSubject<String>();

    final state = onTextChanged
        // 如果文本没有改变，则不会发出新的事件
        .distinct()
        // 等待用户停止输入后 250ms，再发出事件，防止频繁请求
        .debounceTime(const Duration(milliseconds: 250))
        // 调用 Github api，将结果转换为 State
        // 如果又输入了新的搜索词，switchMap 会确保之前的搜索被丢弃，以便不会将过期的结果传递给 View
        .switchMap<SearchState>((String term) => _search(term, repo))
        // 最开始的状态
        .startWith(SearchInitial());

    return SearchBloc._(onTextChanged, state);
  }

  // 私有构造函数，防止外部创建
  SearchBloc._(this.onTextChanged, this.state);

  // 释放资源
  void dispose() {
    onTextChanged.close();
  }

  // 调用 Github api，将结果转换为 State
  // 私有方法，外部不可见，一般使用 _ 开头
  static Stream<SearchState> _search(String term, GithubRepository repo) =>
      term.isEmpty
          ? Stream.value(SearchInitial())
          : Rx.fromCallable(() => repo.search(term))
              .map((result) =>
                  result.isEmpty ? SearchEmpty() : SearchPopulated(result))
              .startWith(SearchLoading())
              .onErrorReturn(SearchError());
}
