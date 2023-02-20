import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:page_repository/page_repository.dart';

import 'app_dio.dart';

class ProductRepository {
  final String baseUrl;
  final Map<String, PageLayoutCache<SliceWrapper<Product>>> cache;
  final Dio client;
  final bool enableCache;

  ProductRepository({
    Dio? client,
    Map<String, PageLayoutCache<SliceWrapper<Product>>>? cache,
    this.baseUrl = '/products/by-category',
    this.enableCache = true,
  })  : client = client ?? AppDio.getInstance(),
        cache = cache ?? <String, PageLayoutCache<SliceWrapper<Product>>>{};

  Future<SliceWrapper<Product>> getByCategory(
      {required int categoryId, int page = 0}) async {
    debugPrint('ProductRepository.getByCategory($categoryId, $page)');
    final url = '$baseUrl/$categoryId/page?page=$page';
    final cachedResult = cache[url];
    if (enableCache && cachedResult != null && !cachedResult.isExpired) {
      debugPrint(
          'ProductRepository.getByCategory($categoryId, $page) - cache hit');
      return cachedResult.value;
    }

    debugPrint(
        'ProductRepository.getByCategory($categoryId, $page) - cache miss');

    final response = await client.get(url);

    if (response.statusCode != 200) {
      final problem = Problem.fromJson(response.data);
      debugPrint(
          'ProductRepository.getByCategory($categoryId, $page) - error: $problem');
      throw Exception(problem.title);
    }

    final result = SliceWrapper<Product>.fromJson(
        response.data, (json) => Product.fromJson(json));

    debugPrint('ProductRepository.getByCategory($categoryId, $page) - success');

    cache[url] = PageLayoutCache(
      value: result,
      expires: DateTime.now().add(const Duration(minutes: 10)),
    );

    debugPrint(
        'ProductRepository.getByCategory($categoryId, $page) - cache set');

    return result;
  }
}
