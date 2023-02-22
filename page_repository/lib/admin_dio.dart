import 'package:dio/browser.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class AdminDio with DioMixin implements Dio {
  AdminDio._([BaseOptions? options]) {
    options = BaseOptions(
      baseUrl: 'http://localhost:8080/api/v1/admin',
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
    );

    this.options = options;
    interceptors.add(PrettyDioLogger());
    httpClientAdapter = BrowserHttpClientAdapter();
  }

  static Dio getInstance() => AdminDio._();
}
