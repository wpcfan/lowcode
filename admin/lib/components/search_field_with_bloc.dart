import 'package:admin/blocs/search_bloc.dart';
import 'package:admin/blocs/search_state.dart';
import 'package:admin/components/search_intro_widget.dart';
import 'package:admin/repositories/github_repository.dart';
import 'package:flutter/material.dart';

import 'search_empty_widget.dart';
import 'search_error_widget.dart';
import 'search_loading_widget.dart';
import 'search_result_widget.dart';

class SearchFieldWithBloc extends StatefulWidget {
  final GithubRepository api;
  const SearchFieldWithBloc({super.key, required this.api});

  @override
  State<SearchFieldWithBloc> createState() => _SearchFieldWithBlocState();
}

class _SearchFieldWithBlocState extends State<SearchFieldWithBloc> {
  late final SearchBloc bloc;

  @override
  void initState() {
    super.initState();

    bloc = SearchBloc(widget.api);
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SearchState>(
      stream: bloc.state,
      initialData: SearchInitial(),
      builder: (BuildContext context, AsyncSnapshot<SearchState> snapshot) {
        final state = snapshot.requireData;

        return Scaffold(
          body: Stack(
            children: <Widget>[
              Flex(direction: Axis.vertical, children: <Widget>[
                Container(
                  padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 4.0),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Search Github...',
                    ),
                    style: const TextStyle(
                      fontSize: 36.0,
                      decoration: TextDecoration.none,
                    ),
                    onChanged: bloc.onTextChanged.add,
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _buildChild(state),
                  ),
                )
              ])
            ],
          ),
        );
      },
    );
  }

  Widget _buildChild(SearchState state) {
    if (state is SearchInitial) {
      return const SearchIntroWidget();
    } else if (state is SearchEmpty) {
      return const SearchEmptyWidget();
    } else if (state is SearchLoading) {
      return const SearchLoadingWidget();
    } else if (state is SearchError) {
      return const SearchErrorWidget();
    } else if (state is SearchPopulated) {
      return SearchResultWidget(items: state.result.items);
    }

    throw Exception('${state.runtimeType} is not supported');
  }
}
