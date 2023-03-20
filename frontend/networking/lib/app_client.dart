import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

import 'cache_options.dart';

/// AppDio
/// 为 App 定制的 Dio 实例
/// 用于访问 App 的后端接口
class AppClient {
  static Dio getInstance() {
    final options = BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/app',
      headers: Map.from({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }),
    );
    final dio = Dio(options);
    _setupInterceptors(dio);
    return dio;
  }

  static void _setupInterceptors(Dio dio) {
    dio.interceptors.add(PrettyDioLogger());
    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        debugPrint('AppDio.onRequest(${options.uri})');
        options.headers.addAll(await userAgentClientHintsHeader());
        return handler.next(options);
      },
    ));
  }
}
