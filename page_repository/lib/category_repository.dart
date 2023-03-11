import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart' hide Category;
import 'package:models/models.dart';
import 'package:networking/networking.dart';

/// 类目仓库
class CategoryRepository {
  final String baseUrl;
  final Dio client;
  final bool enableCache;
  final bool refreshCache;

  /// 构造函数
  /// [client] Dio实例
  /// [baseUrl] 接口基础地址
  /// [enableCache] 是否启用缓存
  CategoryRepository({
    Dio? client,
    this.baseUrl = '/categories',
    this.enableCache = true,
    this.refreshCache = false,
  }) : client = client ?? AdminClient.getInstance();

  Future<List<Category>> getCategories() async {
    debugPrint('CategoryRepository.getCategories()');

    final url = baseUrl;

    final response = await client.get(
      url,
      options: enableCache
          ? refreshCache
              ? cacheOptions
                  .copyWith(policy: CachePolicy.refreshForceCache)
                  .toOptions()
              : null
          : cacheOptions.copyWith(policy: CachePolicy.noCache).toOptions(),
    );

    final result =
        (response.data as List).map((json) => Category.fromJson(json)).toList();

    debugPrint('CategoryRepository.getCategories() - success');

    return result;
  }
}
