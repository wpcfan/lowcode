library page_repository;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';

import 'app_dio.dart';

export 'page_admin_repository.dart';
export 'product_repository.dart';

/// 页面布局缓存
class PageLayoutCache<T> {
  final T value;
  final DateTime expires;

  PageLayoutCache({
    required this.value,
    required this.expires,
  });

  bool get isExpired => expires.isBefore(DateTime.now());
}

/// 页面布局仓库
class PageRepository {
  final String baseUrl;
  final Map<String, PageLayoutCache> cache;
  final Dio client;
  final bool enableCache;

  /// 构造函数
  /// [client] Dio实例
  /// [cache] 缓存
  /// [baseUrl] 接口基础地址
  /// [enableCache] 是否启用缓存
  /// 注意下面的写法，是为了允许在调用时，只传入部分参数，而不是全部参数
  /// 例如：
  /// ```dart
  /// PageRepository(
  ///   baseUrl: '/pages',
  ///   enableCache: true,
  /// )
  /// ```
  /// 这样就可以省略掉client和cache参数
  /// 但是，如果你传入了client和cache参数，那么就会覆盖掉默认值
  /// 例如：
  /// ```dart
  /// PageRepository(
  ///   client: Dio(),
  ///   cache: <String, PageLayoutCache>{},
  ///   baseUrl: '/pages',
  ///   enableCache: true,
  /// )
  /// ```
  /// 构造函数的写法，在 `:` 后面，是初始化列表
  /// 初始化列表的写法，是为了在构造函数执行之前，先执行初始化列表中的代码
  /// 这样就可以在构造函数中，直接使用初始化列表中的变量，写法上更加简洁。
  ///
  PageRepository({
    Dio? client,
    Map<String, PageLayoutCache>? cache,
    this.baseUrl = '/pages',
    this.enableCache = true,
  })  : client = client ?? AppDio.getInstance(),
        cache = cache ?? <String, PageLayoutCache>{};

  Future<PageLayout> getByPageType(PageType pageType) async {
    debugPrint('PageRepository.getByPageType($pageType)');

    final url = '$baseUrl/published/${pageType.value}';
    final cachedResult = cache[url];

    if (enableCache && cachedResult != null && !cachedResult.isExpired) {
      debugPrint('PageRepository.getByPageType($pageType) - cache hit');
      return cachedResult.value;
    }

    debugPrint('PageRepository.getByPageType($pageType) - cache miss');

    final response = await client.get(url);
    if (response.statusCode != 200) {
      final problem = Problem.fromJson(response.data);
      debugPrint('PageRepository.getByPageType($pageType) - error: $problem');
      throw Exception(problem.title);
    }

    final result = PageLayout.fromJson(response.data);

    debugPrint('PageRepository.getByPageType($pageType) - success');

    cache[url] = PageLayoutCache(
      value: result,
      expires: DateTime.now().add(const Duration(minutes: 10)),
    );

    debugPrint('PageRepository.getByPageType($pageType) - cache set');

    return result;
  }
}
