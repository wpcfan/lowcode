import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:networking/networking.dart';

class ProductRepository {
  final String baseUrl;
  final Dio client;
  final bool enableCache;
  final bool refreshCache;

  ProductRepository({
    Dio? client,
    this.baseUrl = '/products/by-category',
    this.enableCache = true,
    this.refreshCache = false,
  }) : client = client ?? AppClient.getInstance();

  Future<SliceWrapper<Product>> getByCategory(
      {required int categoryId, int page = 0}) async {
    debugPrint('ProductRepository.getByCategory($categoryId, $page)');
    final url = '$baseUrl/$categoryId/page?page=$page';

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

    final result = SliceWrapper<Product>.fromJson(
        response.data, (json) => Product.fromJson(json));

    debugPrint('ProductRepository.getByCategory($categoryId, $page) - success');

    return result;
  }
}
