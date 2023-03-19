library repositories;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

export 'category_repository.dart';
export 'file_admin_repository.dart';
export 'file_upload_repository.dart';
export 'page_admin_repository.dart';
export 'page_block_data_repository.dart';
export 'page_block_repository.dart';
export 'product_repository.dart';

/// 页面布局仓库
class PageRepository {
  final String baseUrl;
  final Dio client;
  final bool enableCache;
  final bool refreshCache;

  /// 构造函数
  /// [client] Dio实例
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
  /// 这样就可以省略掉client参数
  /// 但是，如果你传入了client参数，那么就会覆盖掉默认值
  /// 例如：
  /// ```dart
  /// PageRepository(
  ///   client: Dio(),
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
    this.baseUrl = '/pages',
    this.enableCache = true,
    this.refreshCache = false,
  }) : client = client ?? AppClient.getInstance();

  Future<PageLayout> getByPageType(PageType pageType) async {
    debugPrint('PageRepository.getByPageType($pageType)');

    final url = '$baseUrl/published/${pageType.value}';

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

    final result = PageLayout.fromJson(response.data);

    debugPrint('PageRepository.getByPageType($pageType) - success');

    return result;
  }
}
