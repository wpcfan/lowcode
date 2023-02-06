import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import 'repository_detail_page.dart';

class Repository {
  final String name;
  final String fullName;
  final String avatarUrl;
  final String description;
  final int stargazersCount;

  Repository({
    required this.name,
    required this.avatarUrl,
    required this.fullName,
    required this.description,
    required this.stargazersCount,
  });

  static List<Repository> fromJson(List<dynamic> json) {
    return json
        .map((repositoryJson) => Repository(
              name: repositoryJson['name'],
              avatarUrl: repositoryJson['avatar_url'],
              fullName: repositoryJson['full_name'],
              description: repositoryJson['description'],
              stargazersCount: repositoryJson['stargazers_count'],
            ))
        .toList();
  }
}

class RepositoryService {
  static const String BASE_URL = 'https://api.github.com/repositories';

  static Future<List<Repository>> fetch(
      {int page = 1, int pageSize = 10}) async {
    final response =
        await http.get(Uri.parse('$BASE_URL?page=$page&per_page=$pageSize'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = json.decode(response.body);
      return Repository.fromJson(jsonResponse);
    } else {
      throw Exception('Failed to fetch repositories');
    }
  }
}

class RepositoryListPage extends StatefulWidget {
  const RepositoryListPage({super.key});

  @override
  State<RepositoryListPage> createState() => _RepositoryListPageState();
}

class _RepositoryListPageState extends State<RepositoryListPage> {
  // 列表数据源
  final List<Repository> _repositories = [];
  // 是否正在加载数据
  bool _isLoading = false;
  // 滑动到底部是否加载更多
  bool _isLoadMore = false;

  @override
  void initState() {
    super.initState();
    // 加载初始数据
    _loadMore();
  }

  // 加载更多数据
  Future<void> _loadMore() async {
    if (_isLoading) {
      return;
    }
    setState(() {
      _isLoading = true;
    });
    List<Repository> newRepositories =
        await RepositoryService.fetch(page: _repositories.length, pageSize: 20);
    setState(() {
      _isLoading = false;
      _repositories.addAll(newRepositories);
    });
  }

  // 下拉刷新
  Future<void> _onRefresh() async {
    setState(() {
      _repositories.clear();
    });
    _loadMore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!_isLoading &&
                _isLoadMore &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              _loadMore();
            }
            return false;
          },
          child: ListView.builder(
            itemCount: _repositories.length,
            itemBuilder: (BuildContext context, int index) {
              if (index == _repositories.length - 1) {
                _isLoadMore = true;
              }
              Repository repository = _repositories[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(repository.avatarUrl),
                ),
                title: Text(repository.name),
                onTap: () {
                  HapticFeedback.vibrate();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RepositoryDetailPage(repository: repository),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
