import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'cache_options.dart';
import 'problem.dart';

/// AppDio
/// 为 App 定制的 Dio 实例
/// 用于访问 App 的后端接口
class AppClient with DioMixin implements Dio {
  static final AppClient _instance = AppClient._();
  factory AppClient() => _instance;

  AppClient._() {
    options = BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/app',
      headers: Map.from({
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      }),
    );
    httpClientAdapter = HttpClientAdapter();
    interceptors.add(PrettyDioLogger());
    interceptors.add(DioCacheInterceptor(options: cacheOptions));
    interceptors.add(InterceptorsWrapper(
      onError: (e, handler) {
        if (e.response?.data != null) {
          final problem = Problem.fromJson(e.response?.data);
          return handler.reject(DioError(
            requestOptions: e.requestOptions,
            error: problem,
            type: DioErrorType.badResponse,
            message: problem.title,
          ));
        }
        return handler.next(e);
      },
    ));
  }
}
