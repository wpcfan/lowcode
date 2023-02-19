import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:ua_client_hints/ua_client_hints.dart';

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
