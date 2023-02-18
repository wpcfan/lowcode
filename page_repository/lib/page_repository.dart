library page_repository;

import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:models/models.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

export 'page_admin_repository.dart';
export 'product_repository.dart';

class AppDio with DioMixin implements Dio {
  AppDio._([BaseOptions? options]) {
    options = BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/app',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    );
    this.options = options;
    interceptors.add(PrettyDioLogger());
    interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        debugPrint('AppDio.onRequest(${options.uri})');
        options.headers.addAll(await userAgentClientHintsHeader());
        return handler.next(options);
      },
    ));
    httpClientAdapter = IOHttpClientAdapter();
  }

  static Dio getInstance() => AppDio._();
}

class PageLayoutCache<T> {
  final T value;
  final DateTime expires;

  PageLayoutCache({
    required this.value,
    required this.expires,
  });

  bool get isExpired => expires.isBefore(DateTime.now());
}

class PageRepository {
  final String baseUrl;
  final Map<String, PageLayoutCache> cache;
  final Dio client;
  final bool enableCache;

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

    try {
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
    } catch (e) {
      debugPrint('PageRepository.getByPageType($pageType) - error: $e');
      throw Exception(e);
    }
  }
}
